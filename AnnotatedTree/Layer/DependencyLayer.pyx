cdef class DependencyLayer(SingleWordLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "dependency"
        self.setLayerValue(layerValue)
