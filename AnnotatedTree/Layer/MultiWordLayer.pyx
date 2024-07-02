cdef class MultiWordLayer(WordLayer):

    cpdef object getItemAt(self, int index):
        """
        Returns the item (word or its property) at position index.
        :param index: Position of the item (word or its property).
        :return: The item at position index.
        """
        if index < len(self.items):
            return self.items[index]
        else:
            return None

    cpdef int size(self):
        """
        Returns number of items (words) in the items array list.
        :return: Number of items (words) in the items array list.
        """
        return len(self.items)

    cpdef setLayerValue(self, str layerValue):
        pass
