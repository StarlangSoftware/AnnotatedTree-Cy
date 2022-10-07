from AnnotatedTree.LayerInfo cimport LayerInfo


cdef class IsNodeWithSynSetId(IsLeafNode):

    def __init__(self, id: str):
        self.__id = id

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef LayerInfo layer_info
        cdef int i
        cdef str syn_set_id
        if parseNode.numberOfChildren() == 0:
            layer_info = parseNode.getLayerInfo()
            for i in range(layer_info.getNumberOfMeanings()):
                syn_set_id = layer_info.getSemanticAt(i)
                if syn_set_id == self.__id:
                    return True
        return False
