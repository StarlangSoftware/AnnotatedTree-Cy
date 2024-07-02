from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.LeafConverter.LeafToStringConverter cimport LeafToStringConverter
from AnnotatedTree.LayerInfo cimport LayerInfo


cdef class LeafToRootFormConverter(LeafToStringConverter):

    cpdef str leafConverter(self, ParseNodeDrawable parseNodeDrawable):
        """
        Converts the data in the leaf node to string. If there are multiple words in the leaf node, they are concatenated
        with space.
        :param parseNodeDrawable: Node to be converted to string.
        :return: String form of the data. If there are multiple words in the leaf node, they are concatenated
        with space.
        """
        cdef str root_words, root
        cdef int i
        cdef LayerInfo layer_info
        layer_info = parseNodeDrawable.getLayerInfo()
        root_words = " "
        for i in range(layer_info.getNumberOfWords()):
            root = layer_info.getMorphologicalParseAt(i).getWord().getName()
            if root is not None and len(root) != 0:
                root_words += " " + root
        return root_words
