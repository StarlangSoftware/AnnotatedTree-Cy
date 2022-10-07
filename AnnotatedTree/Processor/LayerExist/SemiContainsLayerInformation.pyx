from AnnotatedSentence.ViewLayerType import ViewLayerType
from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.Condition.IsTurkishLeafNode cimport IsTurkishLeafNode
from AnnotatedTree.Processor.LayerExist.LeafListCondition cimport LeafListCondition


cdef class ContainsLayerInformation(LeafListCondition):

    cdef object __view_layer_type

    def __init__(self, viewLayerType: ViewLayerType):
        self.__view_layer_type = viewLayerType

    cpdef bint satisfies(self, list leafList):
        cdef int not_done, done
        cdef ParseNodeDrawable parse_node
        not_done = 0
        done = 0
        for parse_node in leafList:
            if isinstance(parse_node, ParseNodeDrawable) and "*" \
                    not in parse_node.getLayerData(ViewLayerType.ENGLISH_WORD):
                if self.__view_layer_type == ViewLayerType.TURKISH_WORD:
                    if parse_node.getLayerData(self.__view_layer_type) is not None:
                        done = done + 1
                    else:
                        not_done = not_done + 1
                elif self.__view_layer_type == ViewLayerType.PART_OF_SPEECH or \
                        self.__view_layer_type == ViewLayerType.INFLECTIONAL_GROUP or \
                        self.__view_layer_type == ViewLayerType.NER or self.__view_layer_type == ViewLayerType.SEMANTICS or\
                        self.__view_layer_type == ViewLayerType.PROPBANK:
                    if IsTurkishLeafNode().satisfies(parse_node):
                        if parse_node.getLayerData(self.__view_layer_type) is not None:
                            done = done + 1
                        else:
                            not_done = not_done + 1
        return done != 0 and not_done != 0
