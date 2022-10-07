cdef class ShallowParseLayer(MultiWordLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "shallowParse"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        cdef list split_parse
        self.items = []
        self.layer_value = layerValue
        if layerValue is not None:
            split_parse = layerValue.split(" ")
            self.items.extend(split_parse)
