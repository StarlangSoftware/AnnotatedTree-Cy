cdef class WordLayer:

    cpdef str getLayerValue(self):
        return self.layer_value

    cpdef str getLayerName(self):
        return self.layer_name

    cpdef str getLayerDescription(self):
        return "{" + self.layer_name + "=" + self.layer_value + "}"
