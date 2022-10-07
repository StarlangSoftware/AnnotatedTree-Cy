from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.Condition.IsLeafNode cimport IsLeafNode


cdef class IsProperNoun(IsLeafNode):

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef str parent_data
        if parseNode.numberOfChildren() == 0:
            parent_data = parseNode.getParent().getData().getName()
            return parent_data == "NNP" or parent_data == "NNPS"
        return False
