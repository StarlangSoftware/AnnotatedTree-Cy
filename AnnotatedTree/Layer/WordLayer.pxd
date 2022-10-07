cdef class WordLayer:

    cdef str layer_value, layer_name

    cpdef str getLayerValue(self)
    cpdef str getLayerName(self)
    cpdef str getLayerDescription(self)
