import os
import re

from Corpus.FileDescription cimport FileDescription

cdef class TreeBankDrawable(TreeBank):

    def __init__(self,
                 folder: str = None,
                 pattern: str = None):
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
        return self.parse_trees

    cpdef ParseTreeDrawable get(self, int index):
        return self.parse_trees[index]

    cpdef clearLayer(self, object layerType):
        cdef ParseTreeDrawable tree
        for tree in self.parse_trees:
            if isinstance(tree, ParseTreeDrawable):
                tree.clearLayer(layerType)
                tree.saveWithFileName()

    cpdef removeTree(self, int index):
        self.parse_trees.pop(index)
