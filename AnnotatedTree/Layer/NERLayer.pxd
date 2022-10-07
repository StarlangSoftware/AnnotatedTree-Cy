from AnnotatedTree.Layer.SingleWordLayer cimport SingleWordLayer


cdef class NERLayer(SingleWordLayer):

    cdef object __named_entity

    cpdef setLayerValue(self, str layerValue)
    cpdef str getLayerValue(self)
