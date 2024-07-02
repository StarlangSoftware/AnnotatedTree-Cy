cdef class SingleWordMultiItemLayer(SingleWordLayer):

    cpdef object getItemAt(self, int index):
        """
        Returns the property at position index for the word.
        :param index: Position of the property
        """
        if index < len(self.items):
            return self.items[index]
        else:
            return None

    cpdef getLayerSize(self, object viewLayer):
        """
        Returns the total number of properties for the word in the node.
        :param viewLayer: Not used.
        :return: Total number of properties for the word in the node.
        """
        return len(self.items)
