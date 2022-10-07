import re
from AnnotatedSentence.ViewLayerType import ViewLayerType
from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.Condition.IsLeafNode cimport IsLeafNode


cdef class IsNumber(IsLeafNode):

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef str data, parent_data
        if parseNode.numberOfChildren() == 0:
            data = parseNode.getLayerData(ViewLayerType.ENGLISH_WORD)
            parent_data = parseNode.getParent().getData().getName()
            return parent_data == "CD" and re.fullmatch("[0-9,.]+", data) is not None
        return False
