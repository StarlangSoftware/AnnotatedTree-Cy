cdef class SingleWordLayer(WordLayer):

    cpdef setLayerValue(self, str layerValue):
        self.layer_value = layerValue
