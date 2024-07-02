from MorphologicalAnalysis.MetamorphicParse cimport MetamorphicParse


cdef class MetaMorphemesMovedLayer(MultiWordMultiItemLayer):

    def __init__(self, layerValue: str):
        """
        Constructor for the metaMorphemesMoved layer. Sets the metamorpheme information for multiple words in the node.
        :param layerValue: Layer value for the metaMorphemesMoved information. Consists of metamorpheme information of
                       multiple words separated via space character.
        """
        self.layer_name = "metaMorphemesMoved"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        """
        Sets the layer value to the string form of the given parse.
        :param layerValue: New metamorphic parse.
        """
        cdef list split_words
        cdef str word
        self.items = []
        self.layer_value = layerValue
        if layerValue is not None:
            split_words = layerValue.split(" ")
            for word in split_words:
                self.items.append(MetamorphicParse(word))

    cpdef int getLayerSize(self, object viewLayer):
        """
        Returns the total number of metamorphemes in the words in the node.
        :param viewLayer: Not used.
        :return: Total number of metamorphemes in the words in the node.
        """
        cdef int size
        cdef MetamorphicParse parse
        size = 0
        for parse in self.items:
            if isinstance(parse, MetamorphicParse):
                size += parse.size()
        return size

    cpdef str getLayerInfoAt(self, object viewLayer, int index):
        """
        Returns the metamorpheme at position index in the metamorpheme list.
        :param viewLayer: Not used.
        :param index: Position in the metamorpheme list.
        :return: The metamorpheme at position index in the metamorpheme list.
        """
        cdef int size
        cdef MetamorphicParse parse
        size = 0
        for parse in self.items:
            if isinstance(parse, MetamorphicParse) and index < size + parse.size():
                return parse.getMetaMorpheme(index - size)
            size += parse.size()
        return None
