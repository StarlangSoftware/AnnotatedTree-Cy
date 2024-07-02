from AnnotatedSentence.ViewLayerType import ViewLayerType


cdef class MetaMorphemeLayer(MetaMorphemesMovedLayer):

    def __init__(self, layerValue: str):
        """
        Constructor for the metamorpheme layer. Sets the metamorpheme information for multiple words in the node.
        :param layerValue: Layer value for the metamorpheme information. Consists of metamorpheme information of
        multiple words separated via space character.
        """
        super().__init__(layerValue)
        self.layer_name = "metaMorphemes"

    cpdef setLayerValueWithMetamorphicParse(self, MetamorphicParse layerValue):
        """
        Sets the layer value to the string form of the given parse.
        :param layerValue: New metamorphic parse.
        """
        cdef list split_words
        cdef str word
        if isinstance(layerValue, MetamorphicParse):
            parse = layerValue
            self.layer_value = parse.__str__()
            self.items = []
            if layerValue is not None:
                split_words = self.layerValue.split(" ")
                for word in split_words:
                    self.items.append(MetamorphicParse(word))

    cpdef str getLayerInfoFrom(self, int index):
        """
        Constructs metamorpheme information starting from the position index.
        :param index: Position of the morpheme to start.
        :return: Metamorpheme information starting from the position index.
        """
        cdef int size
        cdef MetamorphicParse parse
        cdef str result
        size = 0
        for parse in self.items:
            if isinstance(parse, MetamorphicParse) and index < size + parse.size():
                result = parse.getMetaMorpheme(index - size)
                index = index + 1
                while index < size + parse.size():
                    result = result + "+" + parse.getMetaMorpheme(index - size)
                    index = index + 1
                return result
            size += parse.size()
        return None

    cpdef MetamorphicParse metaMorphemeRemoveFromIndex(self, int index):
        """
        Removes metamorphemes from the given index. Index shows the position of the metamorpheme in the metamorphemes
        list.
        :param index: Position of the metamorpheme from which the other metamorphemes will be removed.
        :return: New metamorphic parse not containing the removed parts.
        """
        cdef int size
        cdef MetamorphicParse parse
        if 0 <= index < self.getLayerSize(ViewLayerType.META_MORPHEME):
            size = 0
            for parse in self.items:
                if isinstance(parse, MetamorphicParse) and index < size + parse.size():
                    parse.removeMetaMorphemeFromIndex(index - size)
                    return parse
            size += parse.size()
        return None
