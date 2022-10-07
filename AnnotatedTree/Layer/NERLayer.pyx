from NamedEntityRecognition.NamedEntityType import NamedEntityType


cdef class NERLayer(SingleWordLayer):

    def __init__(self, layerValue: str):
        self.layer_name = "namedEntity"
        self.setLayerValue(layerValue)

    cpdef setLayerValue(self, str layerValue):
        self.layer_value = layerValue
        self.__named_entity = NamedEntityType.getNamedEntityType(layerValue)

    cpdef str getLayerValue(self):
        return NamedEntityType.getNamedEntityString(self.__named_entity)
