import re
from AnnotatedSentence.ViewLayerType import ViewLayerType
from AnnotatedTree.Layer.DependencyLayer cimport DependencyLayer
from AnnotatedTree.Layer.EnglishPropbankLayer cimport EnglishPropbankLayer
from AnnotatedTree.Layer.EnglishSemanticLayer cimport EnglishSemanticLayer
from AnnotatedTree.Layer.EnglishWordLayer cimport EnglishWordLayer
from AnnotatedTree.Layer.MetaMorphemeLayer cimport MetaMorphemeLayer
from AnnotatedTree.Layer.MetaMorphemesMovedLayer cimport MetaMorphemesMovedLayer
from AnnotatedTree.Layer.MorphologicalAnalysisLayer cimport MorphologicalAnalysisLayer
from AnnotatedTree.Layer.MultiWordLayer cimport MultiWordLayer
from AnnotatedTree.Layer.MultiWordMultiItemLayer cimport MultiWordMultiItemLayer
from AnnotatedTree.Layer.NERLayer cimport NERLayer
from AnnotatedTree.Layer.PersianWordLayer cimport PersianWordLayer
from AnnotatedTree.Layer.ShallowParseLayer cimport ShallowParseLayer
from AnnotatedTree.Layer.SingleWordMultiItemLayer cimport SingleWordMultiItemLayer
from AnnotatedTree.Layer.TurkishPropbankLayer cimport TurkishPropbankLayer
from AnnotatedTree.Layer.TurkishSemanticLayer cimport TurkishSemanticLayer
from AnnotatedTree.Layer.TurkishWordLayer cimport TurkishWordLayer


cdef class LayerInfo:

    def __init__(self, info: str = None):
        cdef str layer_type, layer_value, layer
        cdef list split_layers
        if info is None:
            self.layers = {}
        else:
            self.layers = {}
            splitLayers = re.split("[{}]", info)
            for layer in splitLayers:
                if len(layer) == 0:
                    continue
                layerType = layer[:layer.index("=")]
                layerValue = layer[layer.index("=") + 1:]
                if layerType == "turkish":
                    self.layers[ViewLayerType.TURKISH_WORD] = TurkishWordLayer(layerValue)
                elif layerType == "persian":
                    self.layers[ViewLayerType.PERSIAN_WORD] = PersianWordLayer(layerValue)
                elif layerType == "english":
                    self.layers[ViewLayerType.ENGLISH_WORD] = EnglishWordLayer(layerValue)
                elif layerType == "morphologicalAnalysis":
                    self.layers[ViewLayerType.INFLECTIONAL_GROUP] = MorphologicalAnalysisLayer(layerValue)
                    self.layers[ViewLayerType.PART_OF_SPEECH] = MorphologicalAnalysisLayer(layerValue)
                elif layerType == "metaMorphemes":
                    self.layers[ViewLayerType.META_MORPHEME] = MetaMorphemeLayer(layerValue)
                elif layerType == "metaMorphemesMoved":
                    self.layers[ViewLayerType.META_MORPHEME_MOVED] = MetaMorphemesMovedLayer(layerValue)
                elif layerType == "dependency":
                    self.layers[ViewLayerType.DEPENDENCY] = DependencyLayer(layerValue)
                elif layerType == "semantics":
                    self.layers[ViewLayerType.SEMANTICS] = TurkishSemanticLayer(layerValue)
                elif layerType == "namedEntity":
                    self.layers[ViewLayerType.NER] = NERLayer(layerValue)
                elif layerType == "propbank" or layerType == "propBank":
                    self.layers[ViewLayerType.PROPBANK] = TurkishPropbankLayer(layerValue)
                elif layerType == "englishPropbank":
                    self.layers[ViewLayerType.ENGLISH_PROPBANK] = EnglishPropbankLayer(layerValue)
                elif layerType == "englishSemantics":
                    self.layers[ViewLayerType.ENGLISH_SEMANTICS] = EnglishSemanticLayer(layerValue)

    cpdef setLayerData(self,
                       object viewLayer,
                       str layerValue):
        if viewLayer == ViewLayerType.PERSIAN_WORD:
            self.layers[ViewLayerType.PERSIAN_WORD] = PersianWordLayer(layerValue)
            self.layers.pop(ViewLayerType.PERSIAN_WORD)
        elif viewLayer == ViewLayerType.TURKISH_WORD:
            self.layers[ViewLayerType.TURKISH_WORD] = TurkishWordLayer(layerValue)
            self.layers.pop(ViewLayerType.INFLECTIONAL_GROUP)
            self.layers.pop(ViewLayerType.PART_OF_SPEECH)
            self.layers.pop(ViewLayerType.META_MORPHEME)
            self.layers.pop(ViewLayerType.META_MORPHEME_MOVED)
            self.layers.pop(ViewLayerType.SEMANTICS)
        elif viewLayer == ViewLayerType.ENGLISH_WORD:
            self.layers[ViewLayerType.ENGLISH_WORD] = EnglishWordLayer(layerValue)
        elif viewLayer == ViewLayerType.PART_OF_SPEECH or viewLayer == ViewLayerType.INFLECTIONAL_GROUP:
            self.layers[ViewLayerType.INFLECTIONAL_GROUP] = MorphologicalAnalysisLayer(layerValue)
            self.layers[ViewLayerType.PART_OF_SPEECH] = MorphologicalAnalysisLayer(layerValue)
            self.layers.pop(ViewLayerType.META_MORPHEME_MOVED)
        elif viewLayer == ViewLayerType.META_MORPHEME:
            self.layers[ViewLayerType.META_MORPHEME] = MetaMorphemeLayer(layerValue)
        elif viewLayer == ViewLayerType.META_MORPHEME_MOVED:
            self.layers[ViewLayerType.META_MORPHEME_MOVED] = MetaMorphemesMovedLayer(layerValue)
        elif viewLayer == ViewLayerType.DEPENDENCY:
            self.layers[ViewLayerType.DEPENDENCY] = DependencyLayer(layerValue)
        elif viewLayer == ViewLayerType.SEMANTICS:
            self.layers[ViewLayerType.SEMANTICS] = TurkishSemanticLayer(layerValue)
        elif viewLayer == ViewLayerType.ENGLISH_SEMANTICS:
            self.layers[ViewLayerType.ENGLISH_SEMANTICS] = EnglishSemanticLayer(layerValue)
        elif viewLayer == ViewLayerType.NER:
            self.layers[ViewLayerType.NER] = NERLayer(layerValue)
        elif viewLayer == ViewLayerType.PROPBANK:
            self.layers[ViewLayerType.PROPBANK] = TurkishPropbankLayer(layerValue)
        elif viewLayer == ViewLayerType.ENGLISH_PROPBANK:
            self.layers[ViewLayerType.ENGLISH_PROPBANK] = EnglishPropbankLayer(layerValue)
        elif viewLayer == ViewLayerType.SHALLOW_PARSE:
            self.layers[ViewLayerType.SHALLOW_PARSE] = ShallowParseLayer(layerValue)

    cpdef setMorphologicalAnalysis(self, MorphologicalParse parse):
        self.layers[ViewLayerType.INFLECTIONAL_GROUP] = MorphologicalAnalysisLayer(parse.__str__())
        self.layers[ViewLayerType.PART_OF_SPEECH] = MorphologicalAnalysisLayer(parse.__str__())

    cpdef setMetaMorphemes(self, MetamorphicParse parse):
        self.layers[ViewLayerType.META_MORPHEME] = MetaMorphemeLayer(parse.__str__())

    cpdef bint layerExists(self, object viewLayerType):
        return viewLayerType in self.layers

    cpdef object checkLayer(self, object viewLayer):
        if viewLayer == ViewLayerType.TURKISH_WORD or viewLayer == ViewLayerType.PERSIAN_WORD or \
                viewLayer == ViewLayerType.ENGLISH_SEMANTICS:
            if viewLayer not in self.layers:
                return ViewLayerType.ENGLISH_WORD
        elif viewLayer == ViewLayerType.PART_OF_SPEECH or viewLayer == ViewLayerType.INFLECTIONAL_GROUP or \
                viewLayer == ViewLayerType.META_MORPHEME or viewLayer == ViewLayerType.SEMANTICS or \
                viewLayer == ViewLayerType.NER or viewLayer == ViewLayerType.PROPBANK or \
                viewLayer == ViewLayerType.SHALLOW_PARSE or viewLayer == ViewLayerType.ENGLISH_PROPBANK:
            if viewLayer not in self.layers:
                return ViewLayerType.TURKISH_WORD
        elif viewLayer == ViewLayerType.META_MORPHEME_MOVED:
            if viewLayer not in self.layers:
                return ViewLayerType.META_MORPHEME
        return viewLayer

    cpdef int getNumberOfWords(self):
        if ViewLayerType.TURKISH_WORD in self.layers:
            return self.layers[ViewLayerType.TURKISH_WORD].size()
        elif ViewLayerType.PERSIAN_WORD in self.layers:
            return self.layers[ViewLayerType.PERSIAN_WORD].size()

    cpdef str getMultiWordAt(self,
                             object viewLayerType,
                             int index,
                             str layerName):
        cdef MultiWordLayer multi_word_layer
        if viewLayerType in self.layers:
            if isinstance(self.layers[viewLayerType], MultiWordLayer):
                multi_word_layer = self.layers[viewLayerType]
                if 0 <= index < multi_word_layer.size():
                    return multi_word_layer.getItemAt(index)
                else:
                    if viewLayerType == ViewLayerType.SEMANTICS:
                        return multi_word_layer.getItemAt(multi_word_layer.size() - 1)

    cpdef str getTurkishWordAt(self, int index):
        return self.getMultiWordAt(ViewLayerType.TURKISH_WORD, index, "turkish")

    cpdef int getNumberOfMeanings(self):
        if ViewLayerType.SEMANTICS in self.layers:
            return self.layers[ViewLayerType.SEMANTICS].size()
        else:
            return 0

    cpdef str getSemanticAt(self, int index):
        return self.getMultiWordAt(ViewLayerType.SEMANTICS, index, "semantics")

    cpdef str getShallowParseAt(self, int index):
        return self.getMultiWordAt(ViewLayerType.SHALLOW_PARSE, index, "shallowParse")

    cpdef Argument getArgument(self):
        cdef TurkishPropbankLayer argument_layer
        if ViewLayerType.PROPBANK in self.layers:
            if isinstance(self.layers[ViewLayerType.PROPBANK], TurkishPropbankLayer):
                argument_layer = self.layers[ViewLayerType.PROPBANK]
                return argument_layer.getArgument()
            else:
                return None
        else:
            return None

    cpdef Argument getArgumentAt(self, int index):
        cdef SingleWordMultiItemLayer multi_argument_layer
        if ViewLayerType.ENGLISH_PROPBANK in self.layers:
            if isinstance(self.layers[ViewLayerType.ENGLISH_PROPBANK], SingleWordMultiItemLayer):
                multi_argument_layer = self.layers[ViewLayerType.ENGLISH_PROPBANK]
                return multi_argument_layer.getItemAt(index)

    cpdef MorphologicalParse getMorphologicalParseAt(self, int index):
        cdef MultiWordLayer multi_word_layer
        if ViewLayerType.INFLECTIONAL_GROUP in self.layers:
            if isinstance(self.layers[ViewLayerType.INFLECTIONAL_GROUP], MultiWordLayer):
                multi_word_layer = self.layers[ViewLayerType.INFLECTIONAL_GROUP]
                if 0 <= index < multi_word_layer.size():
                    return multi_word_layer.getItemAt(index)

    cpdef MetamorphicParse getMetamorphicParseAt(self, int index):
        cdef MultiWordLayer multi_word_layer
        if ViewLayerType.META_MORPHEME in self.layers:
            if isinstance(self.layers[ViewLayerType.META_MORPHEME], MultiWordLayer):
                multiWordLayer = self.layers[ViewLayerType.META_MORPHEME]
                if 0 <= index < multiWordLayer.size():
                    return multiWordLayer.getItemAt(index)

    cpdef str getMetaMorphemeAtIndex(self, int index):
        cdef MetaMorphemeLayer meta_morpheme_layer
        if ViewLayerType.META_MORPHEME in self.layers:
            if isinstance(self.layers[ViewLayerType.META_MORPHEME], MetaMorphemeLayer):
                meta_morpheme_layer = self.layers[ViewLayerType.META_MORPHEME]
                if 0 <= index < meta_morpheme_layer.getLayerSize(ViewLayerType.META_MORPHEME):
                    return meta_morpheme_layer.getLayerInfoAt(ViewLayerType.META_MORPHEME, index)

    cpdef str getMetaMorphemeFromIndex(self, int index):
        cdef MetaMorphemeLayer meta_morpheme_layer
        if ViewLayerType.META_MORPHEME in self.layers:
            if isinstance(self.layers[ViewLayerType.META_MORPHEME], MetaMorphemeLayer):
                meta_morpheme_layer = self.layers[ViewLayerType.META_MORPHEME]
                if 0 <= index < meta_morpheme_layer.getLayerSize(ViewLayerType.META_MORPHEME):
                    return meta_morpheme_layer.getLayerInfoFrom(index)

    cpdef int getLayerSize(self, object viewLayer):
        if isinstance(self.layers[viewLayer], MultiWordMultiItemLayer):
            return self.layers[viewLayer].getLayerSize(viewLayer)
        elif isinstance(self.layers[viewLayer], SingleWordMultiItemLayer):
            return self.layers[viewLayer].getLayerSize(viewLayer)

    cpdef str getLayerInfoAt(self,
                             object viewLayer,
                             int index):
        if viewLayer == ViewLayerType.META_MORPHEME_MOVED or viewLayer == ViewLayerType.PART_OF_SPEECH or \
                viewLayer == ViewLayerType.INFLECTIONAL_GROUP:
            if isinstance(self.layers[viewLayer], MultiWordMultiItemLayer):
                return self.layers[viewLayer].getLayerInfoAt(viewLayer, index)
        elif viewLayer == ViewLayerType.META_MORPHEME:
            return self.getMetaMorphemeAtIndex(index)
        elif viewLayer == ViewLayerType.ENGLISH_PROPBANK:
            return self.getArgumentAt(index).getArgumentType()
        else:
            return None

    cpdef str getLayerDescription(self):
        cdef str result
        result = ""
        for view_layer_type in self.layers.keys():
            if view_layer_type != ViewLayerType.PART_OF_SPEECH:
                result += self.layers[view_layer_type].getLayerDescription()
        return result

    cpdef str getLayerData(self, object viewLayer):
        if viewLayer in self.layers:
            return self.layers[viewLayer].getLayerValue()
        else:
            return None

    cpdef str getRobustLayerData(self, object viewLayer):
        viewLayer = self.checkLayer(viewLayer)
        return self.getLayerData(viewLayer)

    cpdef updateMetaMorphemesMoved(self):
        cdef str result
        cdef int i
        cdef MetaMorphemeLayer meta_morpheme_layer
        if ViewLayerType.META_MORPHEME in self.layers:
            meta_morpheme_layer = self.layers[ViewLayerType.META_MORPHEME]
            if meta_morpheme_layer.size() > 0:
                result = meta_morpheme_layer.getItemAt(0).__str__()
                for i in range(1, meta_morpheme_layer.size()):
                    result += " " + meta_morpheme_layer.getItemAt(i).__str__()
                self.layers[ViewLayerType.META_MORPHEME_MOVED] = MetaMorphemesMovedLayer(result)

    cpdef removeLayer(self, object layerType):
        self.layers.pop(layerType)

    cpdef metaMorphemeClear(self):
        self.layers.pop(ViewLayerType.META_MORPHEME)
        self.layers.pop(ViewLayerType.META_MORPHEME_MOVED)

    cpdef englishClear(self):
        self.layers.pop(ViewLayerType.ENGLISH_WORD)

    cpdef dependencyLayer(self):
        self.layers.pop(ViewLayerType.DEPENDENCY)

    cpdef metaMorphemesMovedClear(self):
        self.layers.pop(ViewLayerType.META_MORPHEME_MOVED)

    cpdef semanticClear(self):
        self.layers.pop(ViewLayerType.SEMANTICS)

    cpdef englishSemanticClear(self):
        self.layers.pop(ViewLayerType.ENGLISH_SEMANTICS)

    cpdef morphologicalAnalysisClear(self):
        self.layers.pop(ViewLayerType.INFLECTIONAL_GROUP)
        self.layers.pop(ViewLayerType.PART_OF_SPEECH)
        self.layers.pop(ViewLayerType.META_MORPHEME)
        self.layers.pop(ViewLayerType.META_MORPHEME_MOVED)

    cpdef MetamorphicParse metaMorphemeRemove(self, int index):
        cdef MetaMorphemeLayer meta_morpheme_layer
        if ViewLayerType.META_MORPHEME in self.layers:
            meta_morpheme_layer = self.layers[ViewLayerType.META_MORPHEME]
            if 0 <= index < meta_morpheme_layer.getLayerSize(ViewLayerType.META_MORPHEME):
                removed_parse = meta_morpheme_layer.metaMorphemeRemoveFromIndex(index)
                self.updateMetaMorphemesMoved()
        return removed_parse

    cpdef divideIntoWords(self):
        cdef list result
        cdef int i
        cdef LayerInfo layer_info
        result = []
        for i in range(self.getNumberOfWords()):
            layer_info = LayerInfo()
            layer_info.setLayerData(ViewLayerType.TURKISH_WORD, self.getTurkishWordAt(i))
            layer_info.setLayerData(ViewLayerType.ENGLISH_WORD, self.getLayerData(ViewLayerType.ENGLISH_WORD))
            if self.layerExists(ViewLayerType.INFLECTIONAL_GROUP):
                layer_info.setMorphologicalAnalysis(self.getMorphologicalParseAt(i))
            if self.layerExists(ViewLayerType.META_MORPHEME):
                layer_info.setMetaMorphemes(self.getMetamorphicParseAt(i))
            if self.layerExists(ViewLayerType.ENGLISH_PROPBANK):
                layer_info.setLayerData(ViewLayerType.ENGLISH_PROPBANK, self.getLayerData(ViewLayerType.ENGLISH_PROPBANK))
            if self.layerExists(ViewLayerType.ENGLISH_SEMANTICS):
                layer_info.setLayerData(ViewLayerType.ENGLISH_SEMANTICS, self.getLayerData(ViewLayerType.ENGLISH_SEMANTICS))
            if self.layerExists(ViewLayerType.NER):
                layer_info.setLayerData(ViewLayerType.NER, self.getLayerData(ViewLayerType.NER))
            if self.layerExists(ViewLayerType.SEMANTICS):
                layer_info.setLayerData(ViewLayerType.SEMANTICS, self.getSemanticAt(i))
            if self.layerExists(ViewLayerType.PROPBANK):
                layer_info.setLayerData(ViewLayerType.PROPBANK, self.getArgument().__str__())
            if self.layerExists(ViewLayerType.SHALLOW_PARSE):
                layer_info.setLayerData(ViewLayerType.SHALLOW_PARSE, self.getShallowParseAt(i))
            result.append(layer_info)
        return result

    cpdef AnnotatedWord toAnnotatedWord(self, int wordIndex):
        cdef AnnotatedWord annotated_word
        annotated_word = AnnotatedWord(self.getTurkishWordAt(wordIndex))
        if self.layerExists(ViewLayerType.INFLECTIONAL_GROUP):
            annotated_word.setParse(self.getMorphologicalParseAt(wordIndex).__str__())
        if self.layerExists(ViewLayerType.META_MORPHEME):
            annotated_word.setMetamorphicParse(self.getMetamorphicParseAt(wordIndex).__str__())
        if self.layerExists(ViewLayerType.SEMANTICS):
            annotated_word.setSemantic(self.getSemanticAt(wordIndex))
        if self.layerExists(ViewLayerType.NER):
            annotated_word.setNamedEntityType(self.getLayerData(ViewLayerType.NER))
        if self.layerExists(ViewLayerType.PROPBANK):
            annotated_word.setArgument(self.getArgument().__str__())
        if self.layerExists(ViewLayerType.SHALLOW_PARSE):
            annotated_word.setShallowParse(self.getShallowParseAt(wordIndex))
        return annotated_word
