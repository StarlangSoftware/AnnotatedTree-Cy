from AnnotatedTree.ParseNodeDrawable cimport ParseNodeDrawable
from AnnotatedTree.Processor.Condition.NodeDrawableCondition cimport NodeDrawableCondition


cdef class NodeDrawableCollector:

    cdef NodeDrawableCondition __condition
    cdef ParseNodeDrawable __root_node

    cpdef collectNodes(self, ParseNodeDrawable parseNode, list collected)
    cpdef list collect(self)
