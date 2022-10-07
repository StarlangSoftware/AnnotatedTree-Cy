from AnnotatedSentence.ViewLayerType import ViewLayerType
from AnnotatedTree.Processor.LeafConverter.LeafToLanguageConverter cimport LeafToLanguageConverter


cdef class LeafToTurkish(LeafToLanguageConverter):

    def __init__(self):
        self.view_layer_type = ViewLayerType.TURKISH_WORD
