from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.Condition.IsLeafNode cimport IsLeafNode
from AnnotatedTree.Processor.Condition.IsNullElement cimport IsNullElement


cdef class IsEnglishLeafNode(IsLeafNode):

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        if super().satisfies(parseNode):
            return not IsNullElement().satisfies(parseNode)
        return False