cdef class EnglishSemanticLayer(SingleWordLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "englishSemantics"
        self.setLayerValue(layerValue)
