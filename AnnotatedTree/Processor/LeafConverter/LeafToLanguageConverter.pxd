from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.LeafConverter.LeafToStringConverter cimport LeafToStringConverter


cdef class LeafToLanguageConverter(LeafToStringConverter):

    cdef object view_layer_type

    cpdef str leafConverter(self, ParseNodeDrawable leafNode)
