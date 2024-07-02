cdef class SingleWordLayer(WordLayer):

    cpdef setLayerValue(self, str layerValue):
        """
        Sets the property of the word
        :param layerValue: Layer info
        """
        self.layer_value = layerValue
