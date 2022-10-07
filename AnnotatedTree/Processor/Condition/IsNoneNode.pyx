from AnnotatedSentence.ViewLayerType import ViewLayerType


cdef class IsNoneNode(IsLeafNode):

    def __init__(self, secondLanguage: ViewLayerType):
        self.__second_language = secondLanguage

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef str data
        if parseNode.numberOfChildren() == 0:
            data = parseNode.getLayerData(self.__second_language)
            return data is not None and data == "*NONE*"
        return False
