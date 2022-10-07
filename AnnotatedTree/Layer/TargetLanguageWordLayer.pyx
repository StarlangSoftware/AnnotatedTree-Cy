from AnnotatedTree.Layer.MultiWordLayer cimport MultiWordLayer


cdef class TargetLanguageWordLayer(MultiWordLayer):

    def __init__(self, layerValue: str):
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        cdef list split_words
        self.items = []
        self.layer_value = layerValue
        if layerValue is not None:
            split_words = layerValue.split(" ")
            self.items.extend(split_words)

    cpdef int getLayerSize(self, object viewLayer):
        return 0

    cpdef str getLayerInfoAt(self,
                             object viewLayer,
                             int index):
        return None
