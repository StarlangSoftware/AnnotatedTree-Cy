cdef class EnglishWordLayer(SourceLanguageWordLayer):

    def __init__(self, layerValue: str):
        super().__init__(layerValue)
        self.layer_name = "english"
