from AnnotatedTree.LayerInfo cimport LayerInfo
from WordNet.WordNet cimport WordNet


cdef class IsPredicateVerbNode(IsVerbNode):

    def __init__(self, wordNet: WordNet):
        super().__init__(wordNet)

    cpdef bint satisfies(self, ParseNodeDrawable parseNode):
        cdef LayerInfo layer_info
        layer_info = parseNode.getLayerInfo()
        return super().satisfies(parseNode) and layer_info is not None and layer_info.getArgument() is not None \
               and layer_info.getArgument().getArgumentType() == "PREDICATE"
