cdef class TurkishPropbankLayer(SingleWordLayer):

    def __init__(self, layerValue: str):
        """
        Constructor for the Turkish propbank layer. Sets single semantic role information for multiple words in
        the node.
        :param layerValue: Layer value for the propbank information. Consists of semantic role information
                       of multiple words.
        """
        self.layer_name = "propbank"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        """
        Sets the layer value for Turkish propbank layer. Converts the string form to an Argument.
        :param layerValue: New value for Turkish propbank layer.
        """
        self.layer_value = layerValue
        self.__propbank = Argument(layerValue)

    cpdef Argument getArgument(self):
        """
        Accessor for the propbank field.
        :return: Propbank field.
        """
        return self.__propbank

    cpdef str getLayerValue(self):
        """
        Another accessor for the propbank field.
        :return: String form of the propbank field.
        """
        return self.__propbank.getArgumentType() + "$" + self.__propbank.getId()
