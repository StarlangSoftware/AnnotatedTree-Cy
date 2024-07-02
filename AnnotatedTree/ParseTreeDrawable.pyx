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
        """
        Another constructor for the ParseTreeDrawable. Sets the file description and reads the tree from the file
        description.
        :param fileDescription: File description that contains the path, index and extension information.
        :param path: Path of the tree
        """
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
        """
        Mutator method for the fileDescription attribute.
        :param fileDescription: New fileDescription value.
        """
        self.__file_description = fileDescription

    cpdef FileDescription getFileDescription(self):
        """
        Accessor method for the fileDescription attribute.
        :return: FileDescription attribute.
        """
        return self.__file_description

    cpdef reload(self):
        """
        Reloads the tree from the input file.
        """
        self.readFromFile(self.__file_description.getFileName(self.__file_description.getPath()))

    cpdef readFromFile(self, str fileName):
        """
        Reads the parse tree from the given line. It sets the root node which calls ParseNodeDrawable constructor
        recursively.
        :param fileName: Name of the file containing the definition of the tree.
        """
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
        """
        Loads the next tree according to the index of the parse tree. For example, if the current
        tree fileName is 0123.train, after the call of nextTree(3), the method will load 0126.train. If the next tree
        does not exist, nothing will happen.
        :param count: Number of trees to go forward
        """
        if self.__file_description.nextFileExists(count):
            self.__file_description.addToIndex(count)
            self.reload()

    cpdef previousTree(self, int count):
        """
        Loads the previous tree according to the index of the parse tree. For example, if the current
        tree fileName is 0123.train, after the call of previousTree(4), the method will load 0119.train. If the
        previous tree does not exist, nothing will happen.
        :param count: Number of trees to go backward
        """
        if self.__file_description.previousFileExists(count):
            self.__file_description.addToIndex(-count)
            self.reload()

    cpdef saveWithFileName(self):
        """
        Saves current tree.
        """
        output_file = open(self.__file_description.getFileName(), mode='w', encoding="utf8")
        output_file.write("( " + self.__str__() + " )\n")
        output_file.close()

    cpdef saveWithPath(self, str newPath):
        """
        Saves current tree to the newPath with other file properties staying the same.
        :param newPath: Path to which tree will be saved
        """
        output_file = open(self.__file_description.getFileName(newPath), mode='w', encoding="utf8")
        output_file.write("( " + self.__str__() + " )\n")
        output_file.close()

    cpdef int maxDepth(self):
        """
        Calculates the maximum depth of the tree.
        :return: The maximum depth of the tree.
        """
        if isinstance(self.root, ParseNodeDrawable):
            return self.root.maxDepth()

    cpdef moveLeft(self, ParseNode node):
        if self.root != node:
            self.root.moveLeft(node)

    cpdef moveRight(self, ParseNode node):
        if self.root != node:
            self.root.moveRight(node)

    cpdef bint layerExists(self, object viewLayerType):
        """
        The method checks if all nodes in the tree has the annotation in the given layer.
        :param viewLayerType: Layer name
        :return: True if all nodes in the tree has the annotation in the given layer, false otherwise.
        """
        if self.root is not None and isinstance(self.root, ParseNodeDrawable):
            return self.root.layerExists(viewLayerType)
        else:
            return False

    cpdef bint layerAll(self, object viewLayerType):
        """
        Checks if all nodes in the tree has annotation with the given layer.
        :param viewLayerType: Layer name
        :return: True if all nodes in the tree has annotation with the given layer, false otherwise.
        """
        if self.root is not None and isinstance(self.root, ParseNodeDrawable):
            return self.root.layerAll(viewLayerType)
        else:
            return False

    cpdef clearLayer(self, object viewLayerType):
        """
        Clears the given layer for all nodes in the tree
        :param viewLayerType: Layer name
        """
        if self.root is not None and isinstance(self.root, ParseNodeDrawable):
            self.root.clearLayer(viewLayerType)

    cpdef AnnotatedSentence generateAnnotatedSentence(self, str language=None):
        """
        Constructs an AnnotatedSentence object from the Turkish tree. Collects all leaf nodes, then for each leaf node
        converts layer info of all words at that node to AnnotatedWords. Layers are converted to the counterparts in the
        AnnotatedWord.
        :param language: Language of the parse tree.
        :return: AnnotatedSentence counterpart of the English / Persian tree
        """
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
        """
        Recursive method that generates a new parse tree by replacing the tag information of the all parse nodes (with all
        its descendants) with respect to the morphological annotation of all parse nodes (with all its descendants)
        of the current parse tree.
        :param surfaceForm: If true, tag will be replaced with the surface form annotation.
        :return: A new parse tree generated by replacing the tag information of the all parse nodes (with all
        its descendants) with respect to the morphological annotation of all parse nodes (with all its descendants)
        of the current parse tree.
        """
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
