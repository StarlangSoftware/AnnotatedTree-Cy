from MorphologicalAnalysis.MetamorphicParse cimport MetamorphicParse


cdef class MetaMorphemesMovedLayer(MultiWordMultiItemLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "metaMorphemesMoved"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        cdef list split_words
        cdef str word
        self.items = []
        self.layer_value = layerValue
        if layerValue is not None:
            split_words = layerValue.split(" ")
            for word in split_words:
                self.items.append(MetamorphicParse(word))

    cpdef int getLayerSize(self, object viewLayer):
        cdef int size
        cdef MetamorphicParse parse
        size = 0
        for parse in self.items:
            if isinstance(parse, MetamorphicParse):
                size += parse.size()
        return size

    cpdef str getLayerInfoAt(self, object viewLayer, int index):
        cdef int size
        cdef MetamorphicParse parse
        size = 0
        for parse in self.items:
            if isinstance(parse, MetamorphicParse) and index < size + parse.size():
                return parse.getMetaMorpheme(index - size)
            size += parse.size()
        return None
