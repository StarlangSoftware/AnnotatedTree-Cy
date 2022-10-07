import os

from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedSentence.AnnotatedWord cimport AnnotatedWord
from AnnotatedTree.Processor.Condition.IsPredicateVerbNode cimport IsPredicateVerbNode
from AnnotatedTree.Processor.Condition.IsTurkishLeafNode cimport IsTurkishLeafNode
from AnnotatedTree.Processor.Condition.IsEnglishLeafNode cimport IsEnglishLeafNode
from AnnotatedTree.Processor.Condition.IsVerbNode cimport IsVerbNode
from AnnotatedTree.Processor.NodeDrawableCollector cimport NodeDrawableCollector
from AnnotatedTree.LayerInfo cimport LayerInfo


cdef class ParseTreeDrawable(ParseTree):

    def __init__(self,
                 fileDescription,
                 path: str=None):
        if path is None:
            if isinstance(fileDescription, FileDescription):
                self.__file_description = fileDescription
                self.name = fileDescription.getRawFileName()
                self.readFromFile(self.__file_description.getFileName(fileDescription.getPath()))
            elif isinstance(fileDescription, str):
                self.name = os.path.split(fileDescription)[1]
                self.readFromFile(fileDescription)
        else:
            self.__file_description = FileDescription(path, fileDescription.getExtension(), fileDescription.getIndex())
            self.name = self.__file_description.getRawFileName()
            self.readFromFile(self.__file_description.getFileName(fileDescription.getPath()))

    cpdef setFileDescription(self, FileDescription fileDescription):
        self.__file_description = fileDescription

    cpdef FileDescription getFileDescription(self):
        return self.__file_description

    cpdef reload(self):
        self.readFromFile(self.__file_description.getFileName(self.__file_description.getPath()))

    cpdef readFromFile(self, str fileName):
        cdef str line
        input_file = open(fileName, encoding="utf8")
        line = input_file.readline().strip()
        if "(" in line and ")" in line:
            line = line[line.index("(") + 1:line.rindex(")")].strip()
            self.root = ParseNodeDrawable(None, line, False, 0)
        else:
            self.root = None
        input_file.close()

    cpdef nextTree(self, int count):
        if self.__file_description.nextFileExists(count):
            self.__file_description.addToIndex(count)
            self.reload()

    cpdef previousTree(self, int count):
        if self.__file_description.previousFileExists(count):
            self.__file_description.addToIndex(-count)
            self.reload()

    cpdef saveWithFileName(self):
        output_file = open(self.__file_description.getFileName(), mode='w', encoding="utf8")
        output_file.write("( " + self.__str__() + " )\n")
        output_file.close()

    cpdef saveWithPath(self, str newPath):
        output_file = open(self.__file_description.getFileName(newPath), mode='w', encoding="utf8")
        output_file.write("( " + self.__str__() + " )\n")
        output_file.close()

    cpdef int maxDepth(self):
        if isinstance(self.root, ParseNodeDrawable):
            return self.root.maxDepth()

    cpdef moveLeft(self, ParseNode node):
        if self.root != node:
            self.root.moveLeft(node)

    cpdef moveRight(self, ParseNode node):
        if self.root != node:
            self.root.moveRight(node)

    cpdef bint layerExists(self, object viewLayerType):
        if self.root is not None and isinstance(self.root, ParseNodeDrawable):
            return self.root.layerExists(viewLayerType)
        else:
            return False

    cpdef bint layerAll(self, object viewLayerType):
        if self.root is not None and isinstance(self.root, ParseNodeDrawable):
            return self.root.layerAll(viewLayerType)
        else:
            return False

    cpdef clearLayer(self, object viewLayerType):
        if self.root is not None and isinstance(self.root, ParseNodeDrawable):
            self.root.clearLayer(viewLayerType)

    cpdef AnnotatedSentence generateAnnotatedSentence(self, str language=None):
        cdef AnnotatedSentence sentence
        cdef NodeDrawableCollector node_drawable_collector
        cdef list leaf_list
        cdef int i
        cdef ParseNodeDrawable parse_node
        cdef LayerInfo layers
        sentence = AnnotatedSentence()
        if language is None:
            node_drawable_collector = NodeDrawableCollector(self.root, IsTurkishLeafNode())
            leaf_list = node_drawable_collector.collect()
            for parse_node in leaf_list:
                if isinstance(parse_node, ParseNodeDrawable):
                    layers = parse_node.getLayerInfo()
                    for i in range(layers.getNumberOfWords()):
                        sentence.addWord(layers.toAnnotatedWord(i))
        else:
            node_drawable_collector = NodeDrawableCollector(self.root, IsEnglishLeafNode())
            leaf_list = node_drawable_collector.collect()
            for parse_node in leaf_list:
                if isinstance(parse_node, ParseNodeDrawable):
                    newWord = AnnotatedWord("{" + language + "=" + parse_node.getData().getName() + "}{posTag="
                                        + parse_node.getParent().getData().getName() + "}")
                    sentence.addWord(newWord)
        return sentence

    cpdef ParseTree generateParseTree(self, bint surfaceForm):
        result = ParseTree(ParseNode(self.root.getData()))
        self.root.generateParseNode(result.getRoot(), surfaceForm)
        return result

    cpdef list extractNodesWithVerbs(self, WordNet wordNet):
        cdef NodeDrawableCollector node_drawable_collector
        node_drawable_collector = NodeDrawableCollector(self.root, IsVerbNode(wordNet))
        return node_drawable_collector.collect()

    cpdef list extractNodesWithPredicateVerbs(self, WordNet wordNet):
        cdef NodeDrawableCollector node_drawable_collector
        node_drawable_collector = NodeDrawableCollector(self.root, IsPredicateVerbNode(wordNet))
        return node_drawable_collector.collect()
