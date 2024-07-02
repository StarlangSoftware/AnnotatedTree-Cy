import os
import re

from Corpus.FileDescription cimport FileDescription

cdef class TreeBankDrawable(TreeBank):

    def __init__(self,
                 folder: str = None,
                 pattern: str = None):
        """
        A constructor of {@link TreeBankDrawable} class which reads all {@link ParseTreeDrawable} files inside the given
        folder. For each file inside that folder, the constructor creates a ParseTreeDrawable and puts in inside the list
        parseTrees.
        :param folder: Folder where all parseTrees reside.
        """
        cdef ParseTreeDrawable parse_tree
        self.parse_trees = []
        if folder is not None:
            for root, dirs, files in os.walk(folder):
                for file in files:
                    fileName = os.path.join(root, file)
                    if (pattern is None or pattern in fileName) and re.match("\\d+\\.", file):
                        parse_tree = ParseTreeDrawable(fileName)
                        if parse_tree.getRoot() is not None:
                            parse_tree.setFileDescription(FileDescription(root, file))
                            self.parse_trees.append(parse_tree)

    cpdef list getParseTrees(self):
        """
        Accessor for the parseTrees attribute
        :return: ParseTrees attribute
        """
        return self.parse_trees

    cpdef ParseTreeDrawable get(self, int index):
        """
        Accessor for a specific tree with the given position in the array.
        :param index: Index of the parseTree.
        :return: Tree that is in the position index
        """
        return self.parse_trees[index]

    cpdef clearLayer(self, object layerType):
        """
        Clears the given layer for all nodes in all trees
        :param layerType: Layer name
        """
        cdef ParseTreeDrawable tree
        for tree in self.parse_trees:
            if isinstance(tree, ParseTreeDrawable):
                tree.clearLayer(layerType)
                tree.saveWithFileName()

    cpdef removeTree(self, int index):
        """
        Removes a tree with the given position from the treebank.
        :param index: Position of the tree to be removed.
        """
        self.parse_trees.pop(index)
