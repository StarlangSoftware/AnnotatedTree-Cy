from AnnotatedSentence.ViewLayerType import ViewLayerType


cdef class IsNullElement(IsLeafNode):

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef str data, parent_data
        if parseNode.numberOfChildren() == 0:
            data = parseNode.getLayerData(ViewLayerType.ENGLISH_WORD)
            parent_data = parseNode.getParent().getData().getName()
            return "*" in data or (data == "0" and parent_data == "-NONE-")
        return False
