from PropBank.Argument cimport Argument


cdef class EnglishPropbankLayer(SingleWordMultiItemLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "englishPropbank"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        cdef list split_words
        cdef str word
        self.items = []
        self.layer_value = layerValue
        if layerValue is not None:
            split_words = layerValue.split("#")
            for word in split_words:
                self.items.append(Argument(word))
