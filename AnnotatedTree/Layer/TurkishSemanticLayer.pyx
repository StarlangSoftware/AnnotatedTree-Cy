cdef class TurkishSemanticLayer(MultiWordLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "semantics"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        cdef list split_meanings
        self.items = []
        self.layer_value = layerValue
        if layerValue is not None:
            split_meanings = layerValue.split("\\$")
            self.items.extend(split_meanings)
