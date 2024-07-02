from AnnotatedTree.ParseTreeDrawable cimport ParseTreeDrawable
from AnnotatedTree.TreeBankDrawable cimport TreeBankDrawable
from ParseTree.ParallelTreeBank cimport ParallelTreeBank


cdef class ParallelTreeBankDrawable(ParallelTreeBank):

    def __init__(self,
                 folder1: str,
                 folder2: str,
                 pattern: str = None):
        """
        Constructor for two parallel treebanks.
        :param folder1: Folder containing the parse tree for the first tree bank.
        :param folder2: Folder containing the parse tree for the second tree bank.
        :param pattern: File name pattern for the files.
        """
        self.from_tree_bank = TreeBankDrawable(folder1, pattern)
        self.to_tree_bank = TreeBankDrawable(folder2, pattern)
        self.removeDifferentTrees()

    cpdef ParseTreeDrawable fromTree(self, int index):
        """
        Accessor for the parse tree of the first tree bank.
        :param index: Position of the parse tree for the first tree bank.
        :return: The parse tree of the first tree bank at position index.
        """
        return self.from_tree_bank.get(index)

    cpdef ParseTreeDrawable toTree(self, int index):
        """
        Accessor for the parse tree of the second tree bank.
        :param index: Position of the parse tree for the second tree bank.
        :return: The parse tree of the second tree bank at position index.
        """
        return self.to_tree_bank.get(index)

    cpdef TreeBankDrawable getFromTreeBank(self):
        """
        Accessor for the first tree bank.
        :return: First tree bank.
        """
        return self.from_tree_bank

    cpdef TreeBankDrawable getToTreeBank(self):
        """
        Accessor for the second tree bank.
        :return: Second tree bank.
        """
        return self.to_tree_bank
