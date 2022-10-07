from AnnotatedTree.ParseTreeDrawable cimport ParseTreeDrawable
from AnnotatedTree.TreeBankDrawable cimport TreeBankDrawable
from ParseTree.ParallelTreeBank cimport ParallelTreeBank


cdef class ParallelTreeBankDrawable(ParallelTreeBank):

    def __init__(self,
                 folder1: str,
                 folder2: str,
                 pattern: str = None):
        self.from_tree_bank = TreeBankDrawable(folder1, pattern)
        self.to_tree_bank = TreeBankDrawable(folder2, pattern)
        self.removeDifferentTrees()

    cpdef ParseTreeDrawable fromTree(self, int index):
        return self.from_tree_bank.get(index)

    cpdef ParseTreeDrawable toTree(self, int index):
        return self.to_tree_bank.get(index)

    cpdef TreeBankDrawable getFromTreeBank(self):
        return self.from_tree_bank

    cpdef TreeBankDrawable getToTreeBank(self):
        return self.to_tree_bank
