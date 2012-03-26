#!/usr/bin/env python

#
# Generated Mon Mar 26 16:33:24 2012 by generateDS.py version 2.7b.
#

import sys

import xcede_bindings as supermod

etree_ = None
Verbose_import_ = False
(   XMLParser_import_none, XMLParser_import_lxml,
    XMLParser_import_elementtree
    ) = range(3)
XMLParser_import_library = None
try:
    # lxml
    from lxml import etree as etree_
    XMLParser_import_library = XMLParser_import_lxml
    if Verbose_import_:
        print("running with lxml.etree")
except ImportError:
    try:
        # cElementTree from Python 2.5+
        import xml.etree.cElementTree as etree_
        XMLParser_import_library = XMLParser_import_elementtree
        if Verbose_import_:
            print("running with cElementTree on Python 2.5+")
    except ImportError:
        try:
            # ElementTree from Python 2.5+
            import xml.etree.ElementTree as etree_
            XMLParser_import_library = XMLParser_import_elementtree
            if Verbose_import_:
                print("running with ElementTree on Python 2.5+")
        except ImportError:
            try:
                # normal cElementTree install
                import cElementTree as etree_
                XMLParser_import_library = XMLParser_import_elementtree
                if Verbose_import_:
                    print("running with cElementTree")
            except ImportError:
                try:
                    # normal ElementTree install
                    import elementtree.ElementTree as etree_
                    XMLParser_import_library = XMLParser_import_elementtree
                    if Verbose_import_:
                        print("running with ElementTree")
                except ImportError:
                    raise ImportError("Failed to import ElementTree from any known place")

def parsexml_(*args, **kwargs):
    if (XMLParser_import_library == XMLParser_import_lxml and
        'parser' not in kwargs):
        # Use the lxml ElementTree compatible parser so that, e.g.,
        #   we ignore comments.
        kwargs['parser'] = etree_.ETCompatXMLParser()
    doc = etree_.parse(*args, **kwargs)
    return doc

#
# Globals
#

ExternalEncoding = 'ascii'

#
# Data representation classes
#

class XCEDESub(supermod.XCEDE):
    def __init__(self, version=None, annotationList=None, revisionList=None, project=None, subject=None, visit=None, study=None, episode=None, acquisition=None, catalog=None, analysis=None, resource=None, protocol=None, data=None, provenance=None):
        super(XCEDESub, self).__init__(version, annotationList, revisionList, project, subject, visit, study, episode, acquisition, catalog, analysis, resource, protocol, data, provenance, )
supermod.XCEDE.subclass = XCEDESub
# end class XCEDESub


class subjectGroup_tSub(supermod.subjectGroup_t):
    def __init__(self, ID=None, subjectID=None):
        super(subjectGroup_tSub, self).__init__(ID, subjectID, )
supermod.subjectGroup_t.subclass = subjectGroup_tSub
# end class subjectGroup_tSub


class levelDataRefs_tSub(supermod.levelDataRefs_t):
    def __init__(self, dataURI=None, dataID=None, analysisID=None, analysisURI=None, level=None):
        super(levelDataRefs_tSub, self).__init__(dataURI, dataID, analysisID, analysisURI, level, )
supermod.levelDataRefs_t.subclass = levelDataRefs_tSub
# end class levelDataRefs_tSub


class observation_tSub(supermod.observation_t):
    def __init__(self, units=None, type_=None, name=None, valueOf_=None):
        super(observation_tSub, self).__init__(units, type_, name, valueOf_, )
supermod.observation_t.subclass = observation_tSub
# end class observation_tSub


class abstract_entity_tSub(supermod.abstract_entity_t):
    def __init__(self, preferredEntityLabel=None, ID=None, description=None, extensiontype_=None):
        super(abstract_entity_tSub, self).__init__(preferredEntityLabel, ID, description, extensiontype_, )
supermod.abstract_entity_t.subclass = abstract_entity_tSub
# end class abstract_entity_tSub


class abstract_info_tSub(supermod.abstract_info_t):
    def __init__(self, description=None, extensiontype_=None):
        super(abstract_info_tSub, self).__init__(description, extensiontype_, )
supermod.abstract_info_t.subclass = abstract_info_tSub
# end class abstract_info_tSub


class abstract_protocol_tSub(supermod.abstract_protocol_t):
    def __init__(self, termPath=None, description=None, maxOccurences=None, required=None, nomenclature=None, minOccurences=None, abbreviation=None, preferredLabel=None, termID=None, level=None, ID=None, name=None, protocolOffset=None, extensiontype_=None):
        super(abstract_protocol_tSub, self).__init__(termPath, description, maxOccurences, required, nomenclature, minOccurences, abbreviation, preferredLabel, termID, level, ID, name, protocolOffset, extensiontype_, )
supermod.abstract_protocol_t.subclass = abstract_protocol_tSub
# end class abstract_protocol_tSub


class projectInfo_tSub(supermod.projectInfo_t):
    def __init__(self, description=None, exptDesignList=None, subjectGroupList=None, anytypeobjs_=None):
        super(projectInfo_tSub, self).__init__(description, exptDesignList, subjectGroupList, anytypeobjs_, )
supermod.projectInfo_t.subclass = projectInfo_tSub
# end class projectInfo_tSub


class subjectInfo_tSub(supermod.subjectInfo_t):
    def __init__(self, description=None, sex=None, species=None, birthdate=None, anytypeobjs_=None):
        super(subjectInfo_tSub, self).__init__(description, sex, species, birthdate, anytypeobjs_, )
supermod.subjectInfo_t.subclass = subjectInfo_tSub
# end class subjectInfo_tSub


class studyInfo_tSub(supermod.studyInfo_t):
    def __init__(self, description=None, timeStamp=None):
        super(studyInfo_tSub, self).__init__(description, timeStamp, )
supermod.studyInfo_t.subclass = studyInfo_tSub
# end class studyInfo_tSub


class visitInfo_tSub(supermod.visitInfo_t):
    def __init__(self, description=None, timeStamp=None, subjectAge=None):
        super(visitInfo_tSub, self).__init__(description, timeStamp, subjectAge, )
supermod.visitInfo_t.subclass = visitInfo_tSub
# end class visitInfo_tSub


class episodeInfo_tSub(supermod.episodeInfo_t):
    def __init__(self, description=None, timeStamp=None):
        super(episodeInfo_tSub, self).__init__(description, timeStamp, )
supermod.episodeInfo_t.subclass = episodeInfo_tSub
# end class episodeInfo_tSub


class acquisitionInfo_tSub(supermod.acquisitionInfo_t):
    def __init__(self, description=None, timeStamp=None):
        super(acquisitionInfo_tSub, self).__init__(description, timeStamp, )
supermod.acquisitionInfo_t.subclass = acquisitionInfo_tSub
# end class acquisitionInfo_tSub


class binaryDataDimension_tSub(supermod.binaryDataDimension_t):
    def __init__(self, splitRank=None, outputSelect=None, label=None, size=None, extensiontype_=None):
        super(binaryDataDimension_tSub, self).__init__(splitRank, outputSelect, label, size, extensiontype_, )
supermod.binaryDataDimension_t.subclass = binaryDataDimension_tSub
# end class binaryDataDimension_tSub


class mappedBinaryDataDimension_tSub(supermod.mappedBinaryDataDimension_t):
    def __init__(self, splitRank=None, outputSelect=None, label=None, size=None, origin=None, spacing=None, gap=None, datapoints=None, direction=None, units=None, measurementFrame=None):
        super(mappedBinaryDataDimension_tSub, self).__init__(splitRank, outputSelect, label, size, origin, spacing, gap, datapoints, direction, units, measurementFrame, )
supermod.mappedBinaryDataDimension_t.subclass = mappedBinaryDataDimension_tSub
# end class mappedBinaryDataDimension_tSub


class frag_uri_tSub(supermod.frag_uri_t):
    def __init__(self, size=None, offset=None, valueOf_=None):
        super(frag_uri_tSub, self).__init__(size, offset, valueOf_, )
supermod.frag_uri_t.subclass = frag_uri_tSub
# end class frag_uri_tSub


class format_tSub(supermod.format_t):
    def __init__(self, name=None, description=None, documentationList=None, extensionList=None):
        super(format_tSub, self).__init__(name, description, documentationList, extensionList, )
supermod.format_t.subclass = format_tSub
# end class format_tSub


class processStep_tSub(supermod.processStep_t):
    def __init__(self, ID=None, parent=None, program=None, programArguments=None, parameters=None, workingURI=None, timeStamp=None, user=None, hostName=None, architecture=None, platform=None, cvs=None, compiler=None, library=None, buildTimeStamp=None, package=None, repository=None):
        super(processStep_tSub, self).__init__(ID, parent, program, programArguments, parameters, workingURI, timeStamp, user, hostName, architecture, platform, cvs, compiler, library, buildTimeStamp, package, repository, )
supermod.processStep_t.subclass = processStep_tSub
# end class processStep_tSub


class provenance_tSub(supermod.provenance_t):
    def __init__(self, ID=None, processStep=None):
        super(provenance_tSub, self).__init__(ID, processStep, )
supermod.provenance_t.subclass = provenance_tSub
# end class provenance_tSub


class argumentsType_tSub(supermod.argumentsType_t):
    def __init__(self, inputs=None, outputs=None, valueOf_=None):
        super(argumentsType_tSub, self).__init__(inputs, outputs, valueOf_, )
supermod.argumentsType_t.subclass = argumentsType_tSub
# end class argumentsType_tSub


class namedParameterList_tSub(supermod.namedParameterList_t):
    def __init__(self, param=None):
        super(namedParameterList_tSub, self).__init__(param, )
supermod.namedParameterList_t.subclass = namedParameterList_tSub
# end class namedParameterList_tSub


class namedParameter_tSub(supermod.namedParameter_t):
    def __init__(self, ispath=False, type_=None, name=None, io=None, description=None, valueOf_=None):
        super(namedParameter_tSub, self).__init__(ispath, type_, name, io, description, valueOf_, )
supermod.namedParameter_t.subclass = namedParameter_tSub
# end class namedParameter_tSub


class versionedEntity_tSub(supermod.versionedEntity_t):
    def __init__(self, version=None, valueOf_=None):
        super(versionedEntity_tSub, self).__init__(version, valueOf_, )
supermod.versionedEntity_t.subclass = versionedEntity_tSub
# end class versionedEntity_tSub


class versionedProgramEntity_tSub(supermod.versionedProgramEntity_t):
    def __init__(self, version=None, build_=None, package=None, valueOf_=None):
        super(versionedProgramEntity_tSub, self).__init__(version, build_, package, valueOf_, )
supermod.versionedProgramEntity_t.subclass = versionedProgramEntity_tSub
# end class versionedProgramEntity_tSub


class event_tSub(supermod.event_t):
    def __init__(self, units=None, type_=None, name=None, onset=None, duration=None, value=None, annotation=None):
        super(event_tSub, self).__init__(units, type_, name, onset, duration, value, annotation, )
supermod.event_t.subclass = event_tSub
# end class event_tSub


class eventValue_tSub(supermod.eventValue_t):
    def __init__(self, name=None, valueOf_=None):
        super(eventValue_tSub, self).__init__(name, valueOf_, )
supermod.eventValue_t.subclass = eventValue_tSub
# end class eventValue_tSub


class eventParams_tSub(supermod.eventParams_t):
    def __init__(self, value=None):
        super(eventParams_tSub, self).__init__(value, )
supermod.eventParams_t.subclass = eventParams_tSub
# end class eventParams_tSub


class abstract_tagged_entity_tSub(supermod.abstract_tagged_entity_t):
    def __init__(self, metaFields=None, extensiontype_=None):
        super(abstract_tagged_entity_tSub, self).__init__(metaFields, extensiontype_, )
supermod.abstract_tagged_entity_t.subclass = abstract_tagged_entity_tSub
# end class abstract_tagged_entity_tSub


class protocolItem_tSub(supermod.protocolItem_t):
    def __init__(self, required=None, name=None, ID=None, itemText=None, itemRange=None, itemChoice=None, extensiontype_=None):
        super(protocolItem_tSub, self).__init__(required, name, ID, itemText, itemRange, itemChoice, extensiontype_, )
supermod.protocolItem_t.subclass = protocolItem_tSub
# end class protocolItem_tSub


class protocolOffset_tSub(supermod.protocolOffset_t):
    def __init__(self, protocolTimeRef=None, preferredTimeOffset=None, minTimeOffset=None, maxTimeOffset=None):
        super(protocolOffset_tSub, self).__init__(protocolTimeRef, preferredTimeOffset, minTimeOffset, maxTimeOffset, )
supermod.protocolOffset_t.subclass = protocolOffset_tSub
# end class protocolOffset_tSub


class protocolItemChoice_tSub(supermod.protocolItemChoice_t):
    def __init__(self, units=None, value=None):
        super(protocolItemChoice_tSub, self).__init__(units, value, )
supermod.protocolItemChoice_t.subclass = protocolItemChoice_tSub
# end class protocolItemChoice_tSub


class protocolItemRange_tSub(supermod.protocolItemRange_t):
    def __init__(self, units=None, max=None, min=None):
        super(protocolItemRange_tSub, self).__init__(units, max, min, )
supermod.protocolItemRange_t.subclass = protocolItemRange_tSub
# end class protocolItemRange_tSub


class assessmentInfo_tSub(supermod.assessmentInfo_t):
    def __init__(self, description=None):
        super(assessmentInfo_tSub, self).__init__(description, )
supermod.assessmentInfo_t.subclass = assessmentInfo_tSub
# end class assessmentInfo_tSub


class assessmentDescItem_tSub(supermod.assessmentDescItem_t):
    def __init__(self, required=None, name=None, ID=None, itemText=None, itemRange=None, itemChoice=None, formRef=None, version=None):
        super(assessmentDescItem_tSub, self).__init__(required, name, ID, itemText, itemRange, itemChoice, formRef, version, )
supermod.assessmentDescItem_t.subclass = assessmentDescItem_tSub
# end class assessmentDescItem_tSub


class assessmentItem_tSub(supermod.assessmentItem_t):
    def __init__(self, termPath=None, name=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, ID=None, valueStatus=None, value=None, normValue=None, reconciliationNote=None, annotation=None):
        super(assessmentItem_tSub, self).__init__(termPath, name, nomenclature, abbreviation, preferredLabel, termID, ID, valueStatus, value, normValue, reconciliationNote, annotation, )
supermod.assessmentItem_t.subclass = assessmentItem_tSub
# end class assessmentItem_tSub


class terminologyString_tSub(supermod.terminologyString_t):
    def __init__(self, abbreviation=None, preferredLabel=None, termID=None, termPath=None, nomenclature=None, valueOf_=None):
        super(terminologyString_tSub, self).__init__(abbreviation, preferredLabel, termID, termPath, nomenclature, valueOf_, )
supermod.terminologyString_t.subclass = terminologyString_tSub
# end class terminologyString_tSub


class nomenclature_tSub(supermod.nomenclature_t):
    def __init__(self, abbreviation=None, nomenclature=None, valueOf_=None):
        super(nomenclature_tSub, self).__init__(abbreviation, nomenclature, valueOf_, )
supermod.nomenclature_t.subclass = nomenclature_tSub
# end class nomenclature_tSub


class atlasEntity_tSub(supermod.atlasEntity_t):
    def __init__(self, preferredEntityLabel=None, ID=None, description=None, geometry=None):
        super(atlasEntity_tSub, self).__init__(preferredEntityLabel, ID, description, geometry, )
supermod.atlasEntity_t.subclass = atlasEntity_tSub
# end class atlasEntity_tSub


class abstract_geometry_tSub(supermod.abstract_geometry_t):
    def __init__(self):
        super(abstract_geometry_tSub, self).__init__()
supermod.abstract_geometry_t.subclass = abstract_geometry_tSub
# end class abstract_geometry_tSub


class anatomicalEntity_tSub(supermod.anatomicalEntity_t):
    def __init__(self, preferredEntityLabel=None, ID=None, description=None, laterality=None, tissueType=None, label=None):
        super(anatomicalEntity_tSub, self).__init__(preferredEntityLabel, ID, description, laterality, tissueType, label, )
supermod.anatomicalEntity_t.subclass = anatomicalEntity_tSub
# end class anatomicalEntity_tSub


class nameValue_tSub(supermod.nameValue_t):
    def __init__(self, name=None, valueOf_=None):
        super(nameValue_tSub, self).__init__(name, valueOf_, )
supermod.nameValue_t.subclass = nameValue_tSub
# end class nameValue_tSub


class metadataList_tSub(supermod.metadataList_t):
    def __init__(self, value=None):
        super(metadataList_tSub, self).__init__(value, )
supermod.metadataList_t.subclass = metadataList_tSub
# end class metadataList_tSub


class ref_tSub(supermod.ref_t):
    def __init__(self, ID=None, URI=None, valueOf_=None):
        super(ref_tSub, self).__init__(ID, URI, valueOf_, )
supermod.ref_t.subclass = ref_tSub
# end class ref_tSub


class authoredText_tSub(supermod.authoredText_t):
    def __init__(self, timestamp=None, author=None, valueOf_=None):
        super(authoredText_tSub, self).__init__(timestamp, author, valueOf_, )
supermod.authoredText_t.subclass = authoredText_tSub
# end class authoredText_tSub


class abstract_annotation_tSub(supermod.abstract_annotation_t):
    def __init__(self, timestamp=None, author=None, extensiontype_=None):
        super(abstract_annotation_tSub, self).__init__(timestamp, author, extensiontype_, )
supermod.abstract_annotation_t.subclass = abstract_annotation_tSub
# end class abstract_annotation_tSub


class textAnnotation_tSub(supermod.textAnnotation_t):
    def __init__(self, timestamp=None, author=None, comment=None):
        super(textAnnotation_tSub, self).__init__(timestamp, author, comment, )
supermod.textAnnotation_t.subclass = textAnnotation_tSub
# end class textAnnotation_tSub


class generator_tSub(supermod.generator_t):
    def __init__(self, application=None, invocation=None, dataSource=None):
        super(generator_tSub, self).__init__(application, invocation, dataSource, )
supermod.generator_t.subclass = generator_tSub
# end class generator_tSub


class person_tSub(supermod.person_t):
    def __init__(self, role=None, ID=None, salutation=None, givenName=None, middleName=None, surname=None, academicTitles=None, institution=None, department=None):
        super(person_tSub, self).__init__(role, ID, salutation, givenName, middleName, surname, academicTitles, institution, department, )
supermod.person_t.subclass = person_tSub
# end class person_tSub


class unitString_tSub(supermod.unitString_t):
    def __init__(self, units=None, valueOf_=None):
        super(unitString_tSub, self).__init__(units, valueOf_, )
supermod.unitString_t.subclass = unitString_tSub
# end class unitString_tSub


class revision_tSub(supermod.revision_t):
    def __init__(self, ID=None, timestamp=None, generator=None, annotation=None):
        super(revision_tSub, self).__init__(ID, timestamp, generator, annotation, )
supermod.revision_t.subclass = revision_tSub
# end class revision_tSub


class orderedString_tSub(supermod.orderedString_t):
    def __init__(self, order=None, valueOf_=None):
        super(orderedString_tSub, self).__init__(order, valueOf_, )
supermod.orderedString_t.subclass = orderedString_tSub
# end class orderedString_tSub


class value_tSub(supermod.value_t):
    def __init__(self, units=None, valueOf_=None):
        super(value_tSub, self).__init__(units, valueOf_, )
supermod.value_t.subclass = value_tSub
# end class value_tSub


class EntitySub(supermod.Entity):
    def __init__(self, id=None, label=None, type_=None, anytypeobjs_=None):
        super(EntitySub, self).__init__(id, label, type_, anytypeobjs_, )
supermod.Entity.subclass = EntitySub
# end class EntitySub


class ActivitySub(supermod.Activity):
    def __init__(self, id=None, startTime=None, endTime=None, label=None, type_=None, anytypeobjs_=None):
        super(ActivitySub, self).__init__(id, startTime, endTime, label, type_, anytypeobjs_, )
supermod.Activity.subclass = ActivitySub
# end class ActivitySub


class UsedSub(supermod.Used):
    def __init__(self, id=None, time=None, activity=None, entity=None, type_=None, role=None, anytypeobjs_=None):
        super(UsedSub, self).__init__(id, time, activity, entity, type_, role, anytypeobjs_, )
supermod.Used.subclass = UsedSub
# end class UsedSub


class WasGeneratedBySub(supermod.WasGeneratedBy):
    def __init__(self, id=None, time=None, entity=None, activity=None, type_=None, role=None, anytypeobjs_=None):
        super(WasGeneratedBySub, self).__init__(id, time, entity, activity, type_, role, anytypeobjs_, )
supermod.WasGeneratedBy.subclass = WasGeneratedBySub
# end class WasGeneratedBySub


class WasStartedBySub(supermod.WasStartedBy):
    def __init__(self, id=None, time=None, activity=None, trigger=None, type_=None, role=None, anytypeobjs_=None):
        super(WasStartedBySub, self).__init__(id, time, activity, trigger, type_, role, anytypeobjs_, )
supermod.WasStartedBy.subclass = WasStartedBySub
# end class WasStartedBySub


class WasEndedBySub(supermod.WasEndedBy):
    def __init__(self, id=None, time=None, activity=None, trigger=None, type_=None, role=None, anytypeobjs_=None):
        super(WasEndedBySub, self).__init__(id, time, activity, trigger, type_, role, anytypeobjs_, )
supermod.WasEndedBy.subclass = WasEndedBySub
# end class WasEndedBySub


class WasInformedBySub(supermod.WasInformedBy):
    def __init__(self, id=None, time=None, effect=None, cause=None, type_=None, role=None, anytypeobjs_=None):
        super(WasInformedBySub, self).__init__(id, time, effect, cause, type_, role, anytypeobjs_, )
supermod.WasInformedBy.subclass = WasInformedBySub
# end class WasInformedBySub


class WasStartedByActivitySub(supermod.WasStartedByActivity):
    def __init__(self, id=None, started=None, starter=None, type_=None, role=None, anytypeobjs_=None):
        super(WasStartedByActivitySub, self).__init__(id, started, starter, type_, role, anytypeobjs_, )
supermod.WasStartedByActivity.subclass = WasStartedByActivitySub
# end class WasStartedByActivitySub


class AgentSub(supermod.Agent):
    def __init__(self, id=None, label=None, type_=None, anytypeobjs_=None):
        super(AgentSub, self).__init__(id, label, type_, anytypeobjs_, )
supermod.Agent.subclass = AgentSub
# end class AgentSub


class WasAssociatedWithSub(supermod.WasAssociatedWith):
    def __init__(self, id=None, activity=None, agent=None, plan=None, type_=None, role=None, anytypeobjs_=None):
        super(WasAssociatedWithSub, self).__init__(id, activity, agent, plan, type_, role, anytypeobjs_, )
supermod.WasAssociatedWith.subclass = WasAssociatedWithSub
# end class WasAssociatedWithSub


class WasAttributedToSub(supermod.WasAttributedTo):
    def __init__(self, id=None, entity=None, agent=None, type_=None, role=None, anytypeobjs_=None):
        super(WasAttributedToSub, self).__init__(id, entity, agent, type_, role, anytypeobjs_, )
supermod.WasAttributedTo.subclass = WasAttributedToSub
# end class WasAttributedToSub


class ActedOnBehalfOfSub(supermod.ActedOnBehalfOf):
    def __init__(self, id=None, subordinate=None, responsible=None, activity=None, type_=None, role=None, anytypeobjs_=None):
        super(ActedOnBehalfOfSub, self).__init__(id, subordinate, responsible, activity, type_, role, anytypeobjs_, )
supermod.ActedOnBehalfOf.subclass = ActedOnBehalfOfSub
# end class ActedOnBehalfOfSub


class WasDerivedFromSub(supermod.WasDerivedFrom):
    def __init__(self, id=None, generation=None, usage=None, activity=None, generatedEntity=None, usedEntity=None, type_=None, role=None, anytypeobjs_=None):
        super(WasDerivedFromSub, self).__init__(id, generation, usage, activity, generatedEntity, usedEntity, type_, role, anytypeobjs_, )
supermod.WasDerivedFrom.subclass = WasDerivedFromSub
# end class WasDerivedFromSub


class WasRevisionOfSub(supermod.WasRevisionOf):
    def __init__(self, id=None, newer=None, older=None, responsibility=None, type_=None, anytypeobjs_=None):
        super(WasRevisionOfSub, self).__init__(id, newer, older, responsibility, type_, anytypeobjs_, )
supermod.WasRevisionOf.subclass = WasRevisionOfSub
# end class WasRevisionOfSub


class WasQuotedFromSub(supermod.WasQuotedFrom):
    def __init__(self, id=None, quote=None, original=None, quoterAgent=None, quotedAgent=None, type_=None, anytypeobjs_=None):
        super(WasQuotedFromSub, self).__init__(id, quote, original, quoterAgent, quotedAgent, type_, anytypeobjs_, )
supermod.WasQuotedFrom.subclass = WasQuotedFromSub
# end class WasQuotedFromSub


class HadOriginalSourceSub(supermod.HadOriginalSource):
    def __init__(self, id=None, derived=None, source=None, type_=None, anytypeobjs_=None):
        super(HadOriginalSourceSub, self).__init__(id, derived, source, type_, anytypeobjs_, )
supermod.HadOriginalSource.subclass = HadOriginalSourceSub
# end class HadOriginalSourceSub


class TracedToSub(supermod.TracedTo):
    def __init__(self, id=None, entity=None, ancestor=None, type_=None, anytypeobjs_=None):
        super(TracedToSub, self).__init__(id, entity, ancestor, type_, anytypeobjs_, )
supermod.TracedTo.subclass = TracedToSub
# end class TracedToSub


class AlternateOfSub(supermod.AlternateOf):
    def __init__(self, entity2=None, entity1=None):
        super(AlternateOfSub, self).__init__(entity2, entity1, )
supermod.AlternateOf.subclass = AlternateOfSub
# end class AlternateOfSub


class SpecializationOfSub(supermod.SpecializationOf):
    def __init__(self, specializedEntity=None, generalEntity=None):
        super(SpecializationOfSub, self).__init__(specializedEntity, generalEntity, )
supermod.SpecializationOf.subclass = SpecializationOfSub
# end class SpecializationOfSub


class NoteSub(supermod.Note):
    def __init__(self, id=None, anytypeobjs_=None):
        super(NoteSub, self).__init__(id, anytypeobjs_, )
supermod.Note.subclass = NoteSub
# end class NoteSub


class HasAnnotationSub(supermod.HasAnnotation):
    def __init__(self, id=None, thing=None, note=None, anytypeobjs_=None):
        super(HasAnnotationSub, self).__init__(id, thing, note, anytypeobjs_, )
supermod.HasAnnotation.subclass = HasAnnotationSub
# end class HasAnnotationSub


class ActivityRefSub(supermod.ActivityRef):
    def __init__(self, ref=None):
        super(ActivityRefSub, self).__init__(ref, )
supermod.ActivityRef.subclass = ActivityRefSub
# end class ActivityRefSub


class EntityRefSub(supermod.EntityRef):
    def __init__(self, ref=None):
        super(EntityRefSub, self).__init__(ref, )
supermod.EntityRef.subclass = EntityRefSub
# end class EntityRefSub


class AgentRefSub(supermod.AgentRef):
    def __init__(self, ref=None):
        super(AgentRefSub, self).__init__(ref, )
supermod.AgentRef.subclass = AgentRefSub
# end class AgentRefSub


class DependencyRefSub(supermod.DependencyRef):
    def __init__(self, ref=None):
        super(DependencyRefSub, self).__init__(ref, )
supermod.DependencyRef.subclass = DependencyRefSub
# end class DependencyRefSub


class NoteRefSub(supermod.NoteRef):
    def __init__(self, ref=None):
        super(NoteRefSub, self).__init__(ref, )
supermod.NoteRef.subclass = NoteRefSub
# end class NoteRefSub


class DependenciesSub(supermod.Dependencies):
    def __init__(self, used=None, wasGeneratedBy=None, wasStartedBy=None, wasEndedBy=None, wasInformedBy=None, wasStartedByActivity=None, wasAttributedTo=None, wasAssociatedWith=None, actedOnBehalfOf=None, wasDerivedFrom=None, wasRevisionOf=None, wasQuotedFrom=None, hadOriginalSource=None, tracedTo=None, alternateOf=None, specializationOf=None, hasAnnotation=None):
        super(DependenciesSub, self).__init__(used, wasGeneratedBy, wasStartedBy, wasEndedBy, wasInformedBy, wasStartedByActivity, wasAttributedTo, wasAssociatedWith, actedOnBehalfOf, wasDerivedFrom, wasRevisionOf, wasQuotedFrom, hadOriginalSource, tracedTo, alternateOf, specializationOf, hasAnnotation, )
supermod.Dependencies.subclass = DependenciesSub
# end class DependenciesSub


class AccountSub(supermod.Account):
    def __init__(self, id=None, asserter=None, records=None):
        super(AccountSub, self).__init__(id, asserter, records, )
supermod.Account.subclass = AccountSub
# end class AccountSub


class RecordsSub(supermod.Records):
    def __init__(self, id=None, account=None, activity=None, entity=None, agent=None, note=None, dependencies=None):
        super(RecordsSub, self).__init__(id, account, activity, entity, agent, note, dependencies, )
supermod.Records.subclass = RecordsSub
# end class RecordsSub


class ContainerSub(supermod.Container):
    def __init__(self, id=None, records=None):
        super(ContainerSub, self).__init__(id, records, )
supermod.Container.subclass = ContainerSub
# end class ContainerSub


class annotationListTypeSub(supermod.annotationListType):
    def __init__(self, annotation=None):
        super(annotationListTypeSub, self).__init__(annotation, )
supermod.annotationListType.subclass = annotationListTypeSub
# end class annotationListTypeSub


class revisionListTypeSub(supermod.revisionListType):
    def __init__(self, revision=None):
        super(revisionListTypeSub, self).__init__(revision, )
supermod.revisionListType.subclass = revisionListTypeSub
# end class revisionListTypeSub


class contributorListTypeSub(supermod.contributorListType):
    def __init__(self, contributor=None):
        super(contributorListTypeSub, self).__init__(contributor, )
supermod.contributorListType.subclass = contributorListTypeSub
# end class contributorListTypeSub


class stepsTypeSub(supermod.stepsType):
    def __init__(self, step=None, stepRef=None):
        super(stepsTypeSub, self).__init__(step, stepRef, )
supermod.stepsType.subclass = stepsTypeSub
# end class stepsTypeSub


class itemsTypeSub(supermod.itemsType):
    def __init__(self, item=None):
        super(itemsTypeSub, self).__init__(item, )
supermod.itemsType.subclass = itemsTypeSub
# end class itemsTypeSub


class catalogListTypeSub(supermod.catalogListType):
    def __init__(self, catalog=None, catalogRef=None):
        super(catalogListTypeSub, self).__init__(catalog, catalogRef, )
supermod.catalogListType.subclass = catalogListTypeSub
# end class catalogListTypeSub


class catalogRefTypeSub(supermod.catalogRefType):
    def __init__(self, catalogID=None):
        super(catalogRefTypeSub, self).__init__(catalogID, )
supermod.catalogRefType.subclass = catalogRefTypeSub
# end class catalogRefTypeSub


class entryListTypeSub(supermod.entryListType):
    def __init__(self, entry=None, entryDataRef=None, entryResourceRef=None):
        super(entryListTypeSub, self).__init__(entry, entryDataRef, entryResourceRef, )
supermod.entryListType.subclass = entryListTypeSub
# end class entryListTypeSub


class commentListTypeSub(supermod.commentListType):
    def __init__(self, comment=None):
        super(commentListTypeSub, self).__init__(comment, )
supermod.commentListType.subclass = commentListTypeSub
# end class commentListTypeSub


class annotationListType1Sub(supermod.annotationListType1):
    def __init__(self, annotation=None):
        super(annotationListType1Sub, self).__init__(annotation, )
supermod.annotationListType1.subclass = annotationListType1Sub
# end class annotationListType1Sub


class resourceListTypeSub(supermod.resourceListType):
    def __init__(self, resource=None):
        super(resourceListTypeSub, self).__init__(resource, )
supermod.resourceListType.subclass = resourceListTypeSub
# end class resourceListTypeSub


class exptDesignListTypeSub(supermod.exptDesignListType):
    def __init__(self, exptDesign=None, exptDesignRef=None):
        super(exptDesignListTypeSub, self).__init__(exptDesign, exptDesignRef, )
supermod.exptDesignListType.subclass = exptDesignListTypeSub
# end class exptDesignListTypeSub


class subjectGroupListTypeSub(supermod.subjectGroupListType):
    def __init__(self, subjectGroup=None):
        super(subjectGroupListTypeSub, self).__init__(subjectGroup, )
supermod.subjectGroupListType.subclass = subjectGroupListTypeSub
# end class subjectGroupListTypeSub


class datapointsTypeSub(supermod.datapointsType):
    def __init__(self, label=None, value=None, valueOf_=None, mixedclass_=None, content_=None):
        super(datapointsTypeSub, self).__init__(label, value, valueOf_, mixedclass_, content_, )
supermod.datapointsType.subclass = datapointsTypeSub
# end class datapointsTypeSub


class measurementFrameTypeSub(supermod.measurementFrameType):
    def __init__(self, vector=None):
        super(measurementFrameTypeSub, self).__init__(vector, )
supermod.measurementFrameType.subclass = measurementFrameTypeSub
# end class measurementFrameTypeSub


class documentationListTypeSub(supermod.documentationListType):
    def __init__(self, documentation=None):
        super(documentationListTypeSub, self).__init__(documentation, )
supermod.documentationListType.subclass = documentationListTypeSub
# end class documentationListTypeSub


class extensionListTypeSub(supermod.extensionListType):
    def __init__(self, extension=None):
        super(extensionListTypeSub, self).__init__(extension, )
supermod.extensionListType.subclass = extensionListTypeSub
# end class extensionListTypeSub


class metaFieldsTypeSub(supermod.metaFieldsType):
    def __init__(self, metaField=None):
        super(metaFieldsTypeSub, self).__init__(metaField, )
supermod.metaFieldsType.subclass = metaFieldsTypeSub
# end class metaFieldsTypeSub


class metaFieldTypeSub(supermod.metaFieldType):
    def __init__(self, name=None, valueOf_=None):
        super(metaFieldTypeSub, self).__init__(name, valueOf_, )
supermod.metaFieldType.subclass = metaFieldTypeSub
# end class metaFieldTypeSub


class itemTextTypeSub(supermod.itemTextType):
    def __init__(self, textLabel=None):
        super(itemTextTypeSub, self).__init__(textLabel, )
supermod.itemTextType.subclass = itemTextTypeSub
# end class itemTextTypeSub


class textLabelTypeSub(supermod.textLabelType):
    def __init__(self, location=None, value=None):
        super(textLabelTypeSub, self).__init__(location, value, )
supermod.textLabelType.subclass = textLabelTypeSub
# end class textLabelTypeSub


class itemChoiceTypeSub(supermod.itemChoiceType):
    def __init__(self, units=None, itemCode=None, itemValue=None, ID=None):
        super(itemChoiceTypeSub, self).__init__(units, itemCode, itemValue, ID, )
supermod.itemChoiceType.subclass = itemChoiceTypeSub
# end class itemChoiceTypeSub


class dataInstanceTypeSub(supermod.dataInstanceType):
    def __init__(self, validated=None, assessmentInfo=None, assessmentItem=None):
        super(dataInstanceTypeSub, self).__init__(validated, assessmentInfo, assessmentItem, )
supermod.dataInstanceType.subclass = dataInstanceTypeSub
# end class dataInstanceTypeSub


class nsOntologyAnnotation_tSub(supermod.nsOntologyAnnotation_t):
    def __init__(self, timestamp=None, author=None, term=None):
        super(nsOntologyAnnotation_tSub, self).__init__(timestamp, author, term, )
supermod.nsOntologyAnnotation_t.subclass = nsOntologyAnnotation_tSub
# end class nsOntologyAnnotation_tSub


class nsTermAnnotation_tSub(supermod.nsTermAnnotation_t):
    def __init__(self, timestamp=None, author=None, ontologyClass=None):
        super(nsTermAnnotation_tSub, self).__init__(timestamp, author, ontologyClass, )
supermod.nsTermAnnotation_t.subclass = nsTermAnnotation_tSub
# end class nsTermAnnotation_tSub


class abstract_container_tSub(supermod.abstract_container_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, extensiontype_=None):
        super(abstract_container_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, extensiontype_, )
supermod.abstract_container_t.subclass = abstract_container_tSub
# end class abstract_container_tSub


class abstract_process_tSub(supermod.abstract_process_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, extensiontype_=None):
        super(abstract_process_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, extensiontype_, )
supermod.abstract_process_t.subclass = abstract_process_tSub
# end class abstract_process_tSub


class abstract_data_tSub(supermod.abstract_data_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provEntityID=None, level=None, extensiontype_=None):
        super(abstract_data_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provEntityID, level, extensiontype_, )
supermod.abstract_data_t.subclass = abstract_data_tSub
# end class abstract_data_tSub


class resource_tSub(supermod.resource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, extensiontype_=None):
        super(resource_tSub, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, extensiontype_, )
supermod.resource_t.subclass = resource_tSub
# end class resource_tSub


class catalog_tSub(supermod.catalog_t):
    def __init__(self, metaFields=None, level=None, description=None, name=None, ID=None, catalogList=None, entryList=None):
        super(catalog_tSub, self).__init__(metaFields, level, description, name, ID, catalogList, entryList, )
supermod.catalog_t.subclass = catalog_tSub
# end class catalog_tSub


class protocol_tSub(supermod.protocol_t):
    def __init__(self, termPath=None, description=None, maxOccurences=None, required=None, nomenclature=None, minOccurences=None, abbreviation=None, preferredLabel=None, termID=None, level=None, ID=None, name=None, protocolOffset=None, steps=None, items=None):
        super(protocol_tSub, self).__init__(termPath, description, maxOccurences, required, nomenclature, minOccurences, abbreviation, preferredLabel, termID, level, ID, name, protocolOffset, steps, items, )
supermod.protocol_t.subclass = protocol_tSub
# end class protocol_tSub


class analysis_tSub(supermod.analysis_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, level=None, provenance=None, input=None, output=None, measurementGroup=None):
        super(analysis_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, level, provenance, input, output, measurementGroup, )
supermod.analysis_t.subclass = analysis_tSub
# end class analysis_tSub


class subject_tSub(supermod.subject_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, subjectInfo=None):
        super(subject_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, subjectInfo, )
supermod.subject_t.subclass = subject_tSub
# end class subject_tSub


class measurementGroup_tSub(supermod.measurementGroup_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, entity=None, observation=None):
        super(measurementGroup_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, entity, observation, )
supermod.measurementGroup_t.subclass = measurementGroup_tSub
# end class measurementGroup_tSub


class assessment_tSub(supermod.assessment_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provEntityID=None, level=None, name=None, dataInstance=None, annotation=None):
        super(assessment_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provEntityID, level, name, dataInstance, annotation, )
supermod.assessment_t.subclass = assessment_tSub
# end class assessment_tSub


class events_tSub(supermod.events_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provEntityID=None, level=None, params=None, event=None, description=None, annotation=None):
        super(events_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provEntityID, level, params, event, description, annotation, )
supermod.events_t.subclass = events_tSub
# end class events_tSub


class dataResource_tSub(supermod.dataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, extensiontype_=None):
        super(dataResource_tSub, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, extensiontype_, )
supermod.dataResource_t.subclass = dataResource_tSub
# end class dataResource_tSub


class informationResource_tSub(supermod.informationResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, extensiontype_=None):
        super(informationResource_tSub, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, extensiontype_, )
supermod.informationResource_t.subclass = informationResource_tSub
# end class informationResource_tSub


class abstract_level_tSub(supermod.abstract_level_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, extensiontype_=None):
        super(abstract_level_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, extensiontype_, )
supermod.abstract_level_t.subclass = abstract_level_tSub
# end class abstract_level_tSub


class acquisition_tSub(supermod.acquisition_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, acquisitionProtocol=None, acquisitionInfo=None, dataResourceRef=None, dataRef=None, anytypeobjs_=None):
        super(acquisition_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, acquisitionProtocol, acquisitionInfo, dataResourceRef, dataRef, anytypeobjs_, )
supermod.acquisition_t.subclass = acquisition_tSub
# end class acquisition_tSub


class episode_tSub(supermod.episode_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, episodeInfo=None, anytypeobjs_=None):
        super(episode_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, episodeInfo, anytypeobjs_, )
supermod.episode_t.subclass = episode_tSub
# end class episode_tSub


class study_tSub(supermod.study_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, studyInfo=None, anytypeobjs_=None):
        super(study_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, studyInfo, anytypeobjs_, )
supermod.study_t.subclass = study_tSub
# end class study_tSub


class visit_tSub(supermod.visit_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, subjectURI=None, projectID=None, subjectGroupID=None, projectURI=None, subjectID=None, visitInfo=None, anytypeobjs_=None):
        super(visit_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, subjectURI, projectID, subjectGroupID, projectURI, subjectID, visitInfo, anytypeobjs_, )
supermod.visit_t.subclass = visit_tSub
# end class visit_tSub


class project_tSub(supermod.project_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, projectInfo=None, contributorList=None, anytypeobjs_=None):
        super(project_tSub, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, projectInfo, contributorList, anytypeobjs_, )
supermod.project_t.subclass = project_tSub
# end class project_tSub


class binaryDataResource_tSub(supermod.binaryDataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, elementType=None, byteOrder=None, compression=None, extensiontype_=None):
        super(binaryDataResource_tSub, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, elementType, byteOrder, compression, extensiontype_, )
supermod.binaryDataResource_t.subclass = binaryDataResource_tSub
# end class binaryDataResource_tSub


class dcResource_tSub(supermod.dcResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, title=None, creator=None, subject=None, publisher=None, contributor=None, date=None, type_=None, identifier=None, source=None, language=None, relation=None, coverage=None, rights=None):
        super(dcResource_tSub, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, title, creator, subject, publisher, contributor, date, type_, identifier, source, language, relation, coverage, rights, )
supermod.dcResource_t.subclass = dcResource_tSub
# end class dcResource_tSub


class mappedBinaryDataResource_tSub(supermod.mappedBinaryDataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, elementType=None, byteOrder=None, compression=None, dimension=None, originCoords=None):
        super(mappedBinaryDataResource_tSub, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, elementType, byteOrder, compression, dimension, originCoords, )
supermod.mappedBinaryDataResource_t.subclass = mappedBinaryDataResource_tSub
# end class mappedBinaryDataResource_tSub


class dimensionedBinaryDataResource_tSub(supermod.dimensionedBinaryDataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, elementType=None, byteOrder=None, compression=None, dimension=None):
        super(dimensionedBinaryDataResource_tSub, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, elementType, byteOrder, compression, dimension, )
supermod.dimensionedBinaryDataResource_t.subclass = dimensionedBinaryDataResource_tSub
# end class dimensionedBinaryDataResource_tSub



def get_root_tag(node):
    tag = supermod.Tag_pattern_.match(node.tag).groups()[-1]
    rootClass = None
    if hasattr(supermod, tag):
        rootClass = getattr(supermod, tag)
    return tag, rootClass


def parse(inFilename):
    doc = parsexml_(inFilename)
    rootNode = doc.getroot()
    rootTag, rootClass = get_root_tag(rootNode)
    if rootClass is None:
        rootTag = 'XCEDE'
        rootClass = supermod.XCEDE
    rootObj = rootClass.factory()
    rootObj.build(rootNode)
    # Enable Python to collect the space used by the DOM.
    doc = None
    sys.stdout.write('<?xml version="1.0" ?>\n')
    rootObj.export(sys.stdout, 0, name_=rootTag,
        namespacedef_='xmlns:xcede2="http://www.xcede.org/xcede-2"')
    doc = None
    return rootObj


def parseString(inString):
    from StringIO import StringIO
    doc = parsexml_(StringIO(inString))
    rootNode = doc.getroot()
    rootTag, rootClass = get_root_tag(rootNode)
    if rootClass is None:
        rootTag = 'XCEDE'
        rootClass = supermod.XCEDE
    rootObj = rootClass.factory()
    rootObj.build(rootNode)
    # Enable Python to collect the space used by the DOM.
    doc = None
    sys.stdout.write('<?xml version="1.0" ?>\n')
    rootObj.export(sys.stdout, 0, name_=rootTag,
        namespacedef_='xmlns:xcede2="http://www.xcede.org/xcede-2"')
    return rootObj


def parseLiteral(inFilename):
    doc = parsexml_(inFilename)
    rootNode = doc.getroot()
    rootTag, rootClass = get_root_tag(rootNode)
    if rootClass is None:
        rootTag = 'XCEDE'
        rootClass = supermod.XCEDE
    rootObj = rootClass.factory()
    rootObj.build(rootNode)
    # Enable Python to collect the space used by the DOM.
    doc = None
    sys.stdout.write('#from xcede_bindings import *\n\n')
    sys.stdout.write('import xcede_bindings as model_\n\n')
    sys.stdout.write('rootObj = model_.XCEDE(\n')
    rootObj.exportLiteral(sys.stdout, 0, name_="XCEDE")
    sys.stdout.write(')\n')
    return rootObj


USAGE_TEXT = """
Usage: python ???.py <infilename>
"""

def usage():
    print USAGE_TEXT
    sys.exit(1)


def main():
    args = sys.argv[1:]
    if len(args) != 1:
        usage()
    infilename = args[0]
    root = parse(infilename)


if __name__ == '__main__':
    #import pdb; pdb.set_trace()
    main()


