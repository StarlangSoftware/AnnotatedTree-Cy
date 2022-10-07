from AnnotatedTree.LayerInfo cimport LayerInfo
from AnnotatedSentence.ViewLayerType import ViewLayerType
from Dictionary.Pos import Pos


cdef class IsVerbNode(IsLeafNode):

    def __init__(self, wordNet: WordNet):
        self.__word_net = wordNet

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef LayerInfo layer_info
        cdef int i
        cdef str syn_set_id
        layer_info = parseNode.getLayerInfo()
        if parseNode.numberOfChildren() == 0 and layer_info is not None and \
            layer_info.getLayerData(ViewLayerType.SEMANTICS) is not None:
            for i in range(layer_info.getNumberOfMeanings()):
                syn_set_id = layer_info.getSemanticAt(i)
                if self.__word_net.getSynSetWithId(syn_set_id) is not None and \
                        self.__word_net.getSynSetWithId(syn_set_id).getPos() == Pos.VERB:
                    return True
        return False
