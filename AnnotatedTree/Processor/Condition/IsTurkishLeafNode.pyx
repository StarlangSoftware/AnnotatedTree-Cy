from AnnotatedSentence.ViewLayerType import ViewLayerType


cdef class IsTurkishLeafNode(IsLeafNode):

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef str data
        cdef str parent_data
        if parseNode.numberOfChildren() == 0:
            data = parseNode.getLayerData(ViewLayerType.TURKISH_WORD)
            parent_data = parseNode.getParent().getData().getName()
            return data is not None and "*" not in data and (not (data == "0" and parent_data == "-NONE-"))
        return False
