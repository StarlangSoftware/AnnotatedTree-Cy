cdef class TurkishPropbankLayer(SingleWordLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "propbank"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        self.layer_value = layerValue
        self.__propbank = Argument(layerValue)

    cpdef Argument getArgument(self):
        return self.__propbank

    cpdef str getLayerValue(self):
        return self.__propbank.getArgumentType() + "$" + self.__propbank.getId()
