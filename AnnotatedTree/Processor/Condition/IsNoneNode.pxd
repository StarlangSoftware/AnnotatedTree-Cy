from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.Condition.IsLeafNode cimport IsLeafNode


cdef class IsNoneNode(IsLeafNode):

    cdef object __second_language

    cpdef bint satisfies(self, ParseNodeDrawable parseNode)
