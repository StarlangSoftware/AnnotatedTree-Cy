from AnnotatedSentence.ViewLayerType import ViewLayerType
from AnnotatedTree.Processor.LeafConverter.LeafToLanguageConverter cimport LeafToLanguageConverter


cdef class LeafToEnglish(LeafToLanguageConverter):

    def __init__(self):
        """
        Constructor for LeafToEnglish. Sets viewLayerType to ENGLISH.
        """
        self.view_layer_type = ViewLayerType.ENGLISH_WORD
