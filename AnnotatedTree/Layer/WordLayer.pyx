cdef class WordLayer:

    cpdef str getLayerValue(self):
        """
        Accessor for the layerValue attribute.
        :return: LayerValue attribute.
        """
        return self.layer_value

    cpdef str getLayerName(self):
        """
        Accessor for the layerName attribute.
        :return: LayerName attribute.
        """
        return self.layer_name

    cpdef str getLayerDescription(self):
        """
        Returns string form of the word layer.
        :return: String form of the word layer.
        """
        return "{" + self.layer_name + "=" + self.layer_value + "}"
