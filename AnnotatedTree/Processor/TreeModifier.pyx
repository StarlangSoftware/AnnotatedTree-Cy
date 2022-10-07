from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.ParseTreeDrawable cimport ParseTreeDrawable
from AnnotatedTree.Processor.NodeModification.NodeModifier cimport NodeModifier


cdef class TreeModifier:

    cdef ParseTreeDrawable __parse_tree
    cdef NodeModifier __node_modifier

    cpdef nodeModify(self, ParseNodeDrawable parseNode):
        cdef int i
        self.__node_modifier.modifier(parseNode)
        for i in range(parseNode.numberOfChildren()):
            self.nodeModify(parseNode.getChild(i))

    cpdef modify(self):
        self.nodeModify(self.__parse_tree.getRoot())

    def __init__(self, parseTree: ParseTreeDrawable, nodeModifier: NodeModifier):
        self.__parse_tree = parseTree
        self.__node_modifier = nodeModifier
