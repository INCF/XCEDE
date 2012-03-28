#!/usr/bin/env python

#
# Generated Mon Mar 26 16:33:24 2012 by generateDS.py version 2.7b.
#

"""
pyXCEDE is set of python bindings to the XCEDE-2.1-core.xsd schema that consists of
utilities for parsing, generating, and publishing XCEDE compliant files.

The xcede_bindings.py superclass defines the primary xml to python data structures, while pyxcede
aims to create an intuitive and high level interface for parsing XCEDE xml into a python object model,
and for serializing python objects into XCEDE xml.

You'll notice that there are primary objects/models, that each define their own hierarchy of nested elements and
attributtes. Each one other the primary objects, have a single data type (e.g. Project has project_t, and
Subject has subject_t).

However, secondary objects can have a number of different data types (e.g., Resource can have a
informationResource_t, dcResource_t, or a binaryDataResource_t). These additional types (xsi:type) are used
to extend the XML Schema to be specific about modeling different structures.
"""

import sys

import xcede_bindings as supermod

class Project(object):
    # This is a mess... need feedback. I should probably just subclass the project_t class rather than
    """
    Project entity and associated setter/getter methods
        The project entity can represent one or more projects, where each project consists of a
        hierarchy with minimal information about the project, including:
          - project
            - projectInfo
              - groupList
                - group
                  - subjectID

        Each level of the project hierarchy also has a set of attributes specific to the level

    """
    def __init__(self, ID=None, abbreviation=None, name=None, description=None, uri=None):
        self.ID = ID
        self.abbreviation = abbreviation
        self.name = name
        self.description = description
        self.uri = uri
        # create project level instances of the required datatypes
        self._xcedeType = supermod.XCEDE()
        self._projectType = supermod.project_t()
        self._projectInfoType = supermod.projectInfo_t()
        self._subjectGroupListType = supermod.subjectGroupListType()
        self._subjectGroupType = supermod.subjectGroup_t()

    def set_ID(self,ID):
        self._projectType.set_ID(ID=ID)
        self.ID = self._projectType.get_ID()
    def get_ID(self): return self.ID

    def set_abbreviation(self,abbreviation): self._projectType.set_abbreviation(abbreviation)

    def get_abbreviation(self): return self.abbreviation

    def set_name(self):
        pass
    def get_name(self):
        pass
    def set_description(self):
        pass
    def get_description(self):
        pass
    def set_uri(self):
        pass
    def get_uri(self):
        pass
        self._resourceList = supermod.resourceListType()
        self._resource = supermod.resource_t()

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

class XCEDE(supermod.XCEDE):
    def __init__(self, version=None, annotationList=None, revisionList=None, project=None, subject=None, visit=None, study=None, episode=None, acquisition=None, catalog=None, analysis=None, resource=None, protocol=None, data=None, provenance=None):
        super(XCEDE, self).__init__(version, annotationList, revisionList, project, subject, visit, study, episode, acquisition, catalog, analysis, resource, protocol, data, provenance, )
supermod.XCEDE.subclass = XCEDE
# end class XCEDE


class subjectGroup_t(supermod.subjectGroup_t):
    def __init__(self, ID=None, subjectID=None):
        super(subjectGroup_t, self).__init__(ID, subjectID, )
supermod.subjectGroup_t.subclass = subjectGroup_t
# end class subjectGroup_t


class levelDataRefs_t(supermod.levelDataRefs_t):
    def __init__(self, dataURI=None, dataID=None, analysisID=None, analysisURI=None, level=None):
        super(levelDataRefs_t, self).__init__(dataURI, dataID, analysisID, analysisURI, level, )
supermod.levelDataRefs_t.subclass = levelDataRefs_t
# end class levelDataRefs_t


class observation_t(supermod.observation_t):
    def __init__(self, units=None, type_=None, name=None, valueOf_=None):
        super(observation_t, self).__init__(units, type_, name, valueOf_, )
supermod.observation_t.subclass = observation_t
# end class observation_t

class projectInfo_t(supermod.projectInfo_t):
    def __init__(self, description=None, exptDesignList=None, subjectGroupList=None, anytypeobjs_=None):
        super(projectInfo_t, self).__init__(description, exptDesignList, subjectGroupList, anytypeobjs_, )
supermod.projectInfo_t.subclass = projectInfo_t
# end class projectInfo_t


class subjectInfo_t(supermod.subjectInfo_t):
    def __init__(self, description=None, sex=None, species=None, birthdate=None, anytypeobjs_=None):
        super(subjectInfo_t, self).__init__(description, sex, species, birthdate, anytypeobjs_, )
supermod.subjectInfo_t.subclass = subjectInfo_t
# end class subjectInfo_t


class studyInfo_t(supermod.studyInfo_t):
    def __init__(self, description=None, timeStamp=None):
        super(studyInfo_t, self).__init__(description, timeStamp, )
supermod.studyInfo_t.subclass = studyInfo_t
# end class studyInfo_t


class visitInfo_t(supermod.visitInfo_t):
    def __init__(self, description=None, timeStamp=None, subjectAge=None):
        super(visitInfo_t, self).__init__(description, timeStamp, subjectAge, )
supermod.visitInfo_t.subclass = visitInfo_t
# end class visitInfo_t


class episodeInfo_t(supermod.episodeInfo_t):
    def __init__(self, description=None, timeStamp=None):
        super(episodeInfo_t, self).__init__(description, timeStamp, )
supermod.episodeInfo_t.subclass = episodeInfo_t
# end class episodeInfo_t


class acquisitionInfo_t(supermod.acquisitionInfo_t):
    def __init__(self, description=None, timeStamp=None):
        super(acquisitionInfo_t, self).__init__(description, timeStamp, )
supermod.acquisitionInfo_t.subclass = acquisitionInfo_t
# end class acquisitionInfo_t


class binaryDataDimension_t(supermod.binaryDataDimension_t):
    def __init__(self, splitRank=None, outputSelect=None, label=None, size=None, extensiontype_=None):
        super(binaryDataDimension_t, self).__init__(splitRank, outputSelect, label, size, extensiontype_, )
supermod.binaryDataDimension_t.subclass = binaryDataDimension_t
# end class binaryDataDimension_t


class mappedBinaryDataDimension_t(supermod.mappedBinaryDataDimension_t):
    def __init__(self, splitRank=None, outputSelect=None, label=None, size=None, origin=None, spacing=None, gap=None, datapoints=None, direction=None, units=None, measurementFrame=None):
        super(mappedBinaryDataDimension_t, self).__init__(splitRank, outputSelect, label, size, origin, spacing, gap, datapoints, direction, units, measurementFrame, )
supermod.mappedBinaryDataDimension_t.subclass = mappedBinaryDataDimension_t
# end class mappedBinaryDataDimension_t


class frag_uri_t(supermod.frag_uri_t):
    def __init__(self, size=None, offset=None, valueOf_=None):
        super(frag_uri_t, self).__init__(size, offset, valueOf_, )
supermod.frag_uri_t.subclass = frag_uri_t
# end class frag_uri_t


class format_t(supermod.format_t):
    def __init__(self, name=None, description=None, documentationList=None, extensionList=None):
        super(format_t, self).__init__(name, description, documentationList, extensionList, )
supermod.format_t.subclass = format_t
# end class format_t


class processStep_t(supermod.processStep_t):
    def __init__(self, ID=None, parent=None, program=None, programArguments=None, parameters=None, workingURI=None, timeStamp=None, user=None, hostName=None, architecture=None, platform=None, cvs=None, compiler=None, library=None, buildTimeStamp=None, package=None, repository=None):
        super(processStep_t, self).__init__(ID, parent, program, programArguments, parameters, workingURI, timeStamp, user, hostName, architecture, platform, cvs, compiler, library, buildTimeStamp, package, repository, )
supermod.processStep_t.subclass = processStep_t
# end class processStep_t


class provenance_t(supermod.provenance_t):
    def __init__(self, ID=None, processStep=None):
        super(provenance_t, self).__init__(ID, processStep, )
supermod.provenance_t.subclass = provenance_t
# end class provenance_t


class argumentsType_t(supermod.argumentsType_t):
    def __init__(self, inputs=None, outputs=None, valueOf_=None):
        super(argumentsType_t, self).__init__(inputs, outputs, valueOf_, )
supermod.argumentsType_t.subclass = argumentsType_t
# end class argumentsType_t


class namedParameterList_t(supermod.namedParameterList_t):
    def __init__(self, param=None):
        super(namedParameterList_t, self).__init__(param, )
supermod.namedParameterList_t.subclass = namedParameterList_t
# end class namedParameterList_t


class namedParameter_t(supermod.namedParameter_t):
    def __init__(self, ispath=False, type_=None, name=None, io=None, description=None, valueOf_=None):
        super(namedParameter_t, self).__init__(ispath, type_, name, io, description, valueOf_, )
supermod.namedParameter_t.subclass = namedParameter_t
# end class namedParameter_t


class versionedEntity_t(supermod.versionedEntity_t):
    def __init__(self, version=None, valueOf_=None):
        super(versionedEntity_t, self).__init__(version, valueOf_, )
supermod.versionedEntity_t.subclass = versionedEntity_t
# end class versionedEntity_t


class versionedProgramEntity_t(supermod.versionedProgramEntity_t):
    def __init__(self, version=None, build_=None, package=None, valueOf_=None):
        super(versionedProgramEntity_t, self).__init__(version, build_, package, valueOf_, )
supermod.versionedProgramEntity_t.subclass = versionedProgramEntity_t
# end class versionedProgramEntity_t


class event_t(supermod.event_t):
    def __init__(self, units=None, type_=None, name=None, onset=None, duration=None, value=None, annotation=None):
        super(event_t, self).__init__(units, type_, name, onset, duration, value, annotation, )
supermod.event_t.subclass = event_t
# end class event_t


class eventValue_t(supermod.eventValue_t):
    def __init__(self, name=None, valueOf_=None):
        super(eventValue_t, self).__init__(name, valueOf_, )
supermod.eventValue_t.subclass = eventValue_t
# end class eventValue_t


class eventParams_t(supermod.eventParams_t):
    def __init__(self, value=None):
        super(eventParams_t, self).__init__(value, )
supermod.eventParams_t.subclass = eventParams_t
# end class eventParams_t

class protocolItem_t(supermod.protocolItem_t):
    def __init__(self, required=None, name=None, ID=None, itemText=None, itemRange=None, itemChoice=None, extensiontype_=None):
        super(protocolItem_t, self).__init__(required, name, ID, itemText, itemRange, itemChoice, extensiontype_, )
supermod.protocolItem_t.subclass = protocolItem_t
# end class protocolItem_t


class protocolOffset_t(supermod.protocolOffset_t):
    def __init__(self, protocolTimeRef=None, preferredTimeOffset=None, minTimeOffset=None, maxTimeOffset=None):
        super(protocolOffset_t, self).__init__(protocolTimeRef, preferredTimeOffset, minTimeOffset, maxTimeOffset, )
supermod.protocolOffset_t.subclass = protocolOffset_t
# end class protocolOffset_t


class protocolItemChoice_t(supermod.protocolItemChoice_t):
    def __init__(self, units=None, value=None):
        super(protocolItemChoice_t, self).__init__(units, value, )
supermod.protocolItemChoice_t.subclass = protocolItemChoice_t
# end class protocolItemChoice_t


class protocolItemRange_t(supermod.protocolItemRange_t):
    def __init__(self, units=None, max=None, min=None):
        super(protocolItemRange_t, self).__init__(units, max, min, )
supermod.protocolItemRange_t.subclass = protocolItemRange_t
# end class protocolItemRange_t


class assessmentInfo_t(supermod.assessmentInfo_t):
    def __init__(self, description=None):
        super(assessmentInfo_t, self).__init__(description, )
supermod.assessmentInfo_t.subclass = assessmentInfo_t
# end class assessmentInfo_t


class assessmentDescItem_t(supermod.assessmentDescItem_t):
    def __init__(self, required=None, name=None, ID=None, itemText=None, itemRange=None, itemChoice=None, formRef=None, version=None):
        super(assessmentDescItem_t, self).__init__(required, name, ID, itemText, itemRange, itemChoice, formRef, version, )
supermod.assessmentDescItem_t.subclass = assessmentDescItem_t
# end class assessmentDescItem_t


class assessmentItem_t(supermod.assessmentItem_t):
    def __init__(self, termPath=None, name=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, ID=None, valueStatus=None, value=None, normValue=None, reconciliationNote=None, annotation=None):
        super(assessmentItem_t, self).__init__(termPath, name, nomenclature, abbreviation, preferredLabel, termID, ID, valueStatus, value, normValue, reconciliationNote, annotation, )
supermod.assessmentItem_t.subclass = assessmentItem_t
# end class assessmentItem_t


class terminologyString_t(supermod.terminologyString_t):
    def __init__(self, abbreviation=None, preferredLabel=None, termID=None, termPath=None, nomenclature=None, valueOf_=None):
        super(terminologyString_t, self).__init__(abbreviation, preferredLabel, termID, termPath, nomenclature, valueOf_, )
supermod.terminologyString_t.subclass = terminologyString_t
# end class terminologyString_t


class nomenclature_t(supermod.nomenclature_t):
    def __init__(self, abbreviation=None, nomenclature=None, valueOf_=None):
        super(nomenclature_t, self).__init__(abbreviation, nomenclature, valueOf_, )
supermod.nomenclature_t.subclass = nomenclature_t
# end class nomenclature_t


class atlasEntity_t(supermod.atlasEntity_t):
    def __init__(self, preferredEntityLabel=None, ID=None, description=None, geometry=None):
        super(atlasEntity_t, self).__init__(preferredEntityLabel, ID, description, geometry, )
supermod.atlasEntity_t.subclass = atlasEntity_t
# end class atlasEntity_t

class anatomicalEntity_t(supermod.anatomicalEntity_t):
    def __init__(self, preferredEntityLabel=None, ID=None, description=None, laterality=None, tissueType=None, label=None):
        super(anatomicalEntity_t, self).__init__(preferredEntityLabel, ID, description, laterality, tissueType, label, )
supermod.anatomicalEntity_t.subclass = anatomicalEntity_t
# end class anatomicalEntity_t


class nameValue_t(supermod.nameValue_t):
    def __init__(self, name=None, valueOf_=None):
        super(nameValue_t, self).__init__(name, valueOf_, )
supermod.nameValue_t.subclass = nameValue_t
# end class nameValue_t


class metadataList_t(supermod.metadataList_t):
    def __init__(self, value=None):
        super(metadataList_t, self).__init__(value, )
supermod.metadataList_t.subclass = metadataList_t
# end class metadataList_t


class ref_t(supermod.ref_t):
    def __init__(self, ID=None, URI=None, valueOf_=None):
        super(ref_t, self).__init__(ID, URI, valueOf_, )
supermod.ref_t.subclass = ref_t
# end class ref_t


class authoredText_t(supermod.authoredText_t):
    def __init__(self, timestamp=None, author=None, valueOf_=None):
        super(authoredText_t, self).__init__(timestamp, author, valueOf_, )
supermod.authoredText_t.subclass = authoredText_t
# end class authoredText_t

class textAnnotation_t(supermod.textAnnotation_t):
    def __init__(self, timestamp=None, author=None, comment=None):
        super(textAnnotation_t, self).__init__(timestamp, author, comment, )
supermod.textAnnotation_t.subclass = textAnnotation_t
# end class textAnnotation_t


class generator_t(supermod.generator_t):
    def __init__(self, application=None, invocation=None, dataSource=None):
        super(generator_t, self).__init__(application, invocation, dataSource, )
supermod.generator_t.subclass = generator_t
# end class generator_t


class person_t(supermod.person_t):
    def __init__(self, role=None, ID=None, salutation=None, givenName=None, middleName=None, surname=None, academicTitles=None, institution=None, department=None):
        super(person_t, self).__init__(role, ID, salutation, givenName, middleName, surname, academicTitles, institution, department, )
supermod.person_t.subclass = person_t
# end class person_t


class unitString_t(supermod.unitString_t):
    def __init__(self, units=None, valueOf_=None):
        super(unitString_t, self).__init__(units, valueOf_, )
supermod.unitString_t.subclass = unitString_t
# end class unitString_t


class revision_t(supermod.revision_t):
    def __init__(self, ID=None, timestamp=None, generator=None, annotation=None):
        super(revision_t, self).__init__(ID, timestamp, generator, annotation, )
supermod.revision_t.subclass = revision_t
# end class revision_t


class orderedString_t(supermod.orderedString_t):
    def __init__(self, order=None, valueOf_=None):
        super(orderedString_t, self).__init__(order, valueOf_, )
supermod.orderedString_t.subclass = orderedString_t
# end class orderedString_t


class value_t(supermod.value_t):
    def __init__(self, units=None, valueOf_=None):
        super(value_t, self).__init__(units, valueOf_, )
supermod.value_t.subclass = value_t
# end class value_t


class Entity(supermod.Entity):
    def __init__(self, id=None, label=None, type_=None, anytypeobjs_=None):
        super(Entity, self).__init__(id, label, type_, anytypeobjs_, )
supermod.Entity.subclass = Entity
# end class Entity


class Activity(supermod.Activity):
    def __init__(self, id=None, startTime=None, endTime=None, label=None, type_=None, anytypeobjs_=None):
        super(Activity, self).__init__(id, startTime, endTime, label, type_, anytypeobjs_, )
supermod.Activity.subclass = Activity
# end class Activity


class Used(supermod.Used):
    def __init__(self, id=None, time=None, activity=None, entity=None, type_=None, role=None, anytypeobjs_=None):
        super(Used, self).__init__(id, time, activity, entity, type_, role, anytypeobjs_, )
supermod.Used.subclass = Used
# end class Used


class WasGeneratedBy(supermod.WasGeneratedBy):
    def __init__(self, id=None, time=None, entity=None, activity=None, type_=None, role=None, anytypeobjs_=None):
        super(WasGeneratedBy, self).__init__(id, time, entity, activity, type_, role, anytypeobjs_, )
supermod.WasGeneratedBy.subclass = WasGeneratedBy
# end class WasGeneratedBy


class WasStartedBy(supermod.WasStartedBy):
    def __init__(self, id=None, time=None, activity=None, trigger=None, type_=None, role=None, anytypeobjs_=None):
        super(WasStartedBy, self).__init__(id, time, activity, trigger, type_, role, anytypeobjs_, )
supermod.WasStartedBy.subclass = WasStartedBy
# end class WasStartedBy


class WasEndedBy(supermod.WasEndedBy):
    def __init__(self, id=None, time=None, activity=None, trigger=None, type_=None, role=None, anytypeobjs_=None):
        super(WasEndedBy, self).__init__(id, time, activity, trigger, type_, role, anytypeobjs_, )
supermod.WasEndedBy.subclass = WasEndedBy
# end class WasEndedBy


class WasInformedBy(supermod.WasInformedBy):
    def __init__(self, id=None, time=None, effect=None, cause=None, type_=None, role=None, anytypeobjs_=None):
        super(WasInformedBy, self).__init__(id, time, effect, cause, type_, role, anytypeobjs_, )
supermod.WasInformedBy.subclass = WasInformedBy
# end class WasInformedBy


class WasStartedByActivity(supermod.WasStartedByActivity):
    def __init__(self, id=None, started=None, starter=None, type_=None, role=None, anytypeobjs_=None):
        super(WasStartedByActivity, self).__init__(id, started, starter, type_, role, anytypeobjs_, )
supermod.WasStartedByActivity.subclass = WasStartedByActivity
# end class WasStartedByActivity


class Agent(supermod.Agent):
    def __init__(self, id=None, label=None, type_=None, anytypeobjs_=None):
        super(Agent, self).__init__(id, label, type_, anytypeobjs_, )
supermod.Agent.subclass = Agent
# end class Agent


class WasAssociatedWith(supermod.WasAssociatedWith):
    def __init__(self, id=None, activity=None, agent=None, plan=None, type_=None, role=None, anytypeobjs_=None):
        super(WasAssociatedWith, self).__init__(id, activity, agent, plan, type_, role, anytypeobjs_, )
supermod.WasAssociatedWith.subclass = WasAssociatedWith
# end class WasAssociatedWith


class WasAttributedTo(supermod.WasAttributedTo):
    def __init__(self, id=None, entity=None, agent=None, type_=None, role=None, anytypeobjs_=None):
        super(WasAttributedTo, self).__init__(id, entity, agent, type_, role, anytypeobjs_, )
supermod.WasAttributedTo.subclass = WasAttributedTo
# end class WasAttributedTo


class ActedOnBehalfOf(supermod.ActedOnBehalfOf):
    def __init__(self, id=None, subordinate=None, responsible=None, activity=None, type_=None, role=None, anytypeobjs_=None):
        super(ActedOnBehalfOf, self).__init__(id, subordinate, responsible, activity, type_, role, anytypeobjs_, )
supermod.ActedOnBehalfOf.subclass = ActedOnBehalfOf
# end class ActedOnBehalfOf


class WasDerivedFrom(supermod.WasDerivedFrom):
    def __init__(self, id=None, generation=None, usage=None, activity=None, generatedEntity=None, usedEntity=None, type_=None, role=None, anytypeobjs_=None):
        super(WasDerivedFrom, self).__init__(id, generation, usage, activity, generatedEntity, usedEntity, type_, role, anytypeobjs_, )
supermod.WasDerivedFrom.subclass = WasDerivedFrom
# end class WasDerivedFrom


class WasRevisionOf(supermod.WasRevisionOf):
    def __init__(self, id=None, newer=None, older=None, responsibility=None, type_=None, anytypeobjs_=None):
        super(WasRevisionOf, self).__init__(id, newer, older, responsibility, type_, anytypeobjs_, )
supermod.WasRevisionOf.subclass = WasRevisionOf
# end class WasRevisionOf


class WasQuotedFrom(supermod.WasQuotedFrom):
    def __init__(self, id=None, quote=None, original=None, quoterAgent=None, quotedAgent=None, type_=None, anytypeobjs_=None):
        super(WasQuotedFrom, self).__init__(id, quote, original, quoterAgent, quotedAgent, type_, anytypeobjs_, )
supermod.WasQuotedFrom.subclass = WasQuotedFrom
# end class WasQuotedFrom


class HadOriginalSource(supermod.HadOriginalSource):
    def __init__(self, id=None, derived=None, source=None, type_=None, anytypeobjs_=None):
        super(HadOriginalSource, self).__init__(id, derived, source, type_, anytypeobjs_, )
supermod.HadOriginalSource.subclass = HadOriginalSource
# end class HadOriginalSource


class TracedTo(supermod.TracedTo):
    def __init__(self, id=None, entity=None, ancestor=None, type_=None, anytypeobjs_=None):
        super(TracedTo, self).__init__(id, entity, ancestor, type_, anytypeobjs_, )
supermod.TracedTo.subclass = TracedTo
# end class TracedTo


class AlternateOf(supermod.AlternateOf):
    def __init__(self, entity2=None, entity1=None):
        super(AlternateOf, self).__init__(entity2, entity1, )
supermod.AlternateOf.subclass = AlternateOf
# end class AlternateOf


class SpecializationOf(supermod.SpecializationOf):
    def __init__(self, specializedEntity=None, generalEntity=None):
        super(SpecializationOf, self).__init__(specializedEntity, generalEntity, )
supermod.SpecializationOf.subclass = SpecializationOf
# end class SpecializationOf


class Note(supermod.Note):
    def __init__(self, id=None, anytypeobjs_=None):
        super(Note, self).__init__(id, anytypeobjs_, )
supermod.Note.subclass = Note
# end class Note


class HasAnnotation(supermod.HasAnnotation):
    def __init__(self, id=None, thing=None, note=None, anytypeobjs_=None):
        super(HasAnnotation, self).__init__(id, thing, note, anytypeobjs_, )
supermod.HasAnnotation.subclass = HasAnnotation
# end class HasAnnotation


class ActivityRef(supermod.ActivityRef):
    def __init__(self, ref=None):
        super(ActivityRef, self).__init__(ref, )
supermod.ActivityRef.subclass = ActivityRef
# end class ActivityRef


class EntityRef(supermod.EntityRef):
    def __init__(self, ref=None):
        super(EntityRef, self).__init__(ref, )
supermod.EntityRef.subclass = EntityRef
# end class EntityRef


class AgentRef(supermod.AgentRef):
    def __init__(self, ref=None):
        super(AgentRef, self).__init__(ref, )
supermod.AgentRef.subclass = AgentRef
# end class AgentRef


class DependencyRef(supermod.DependencyRef):
    def __init__(self, ref=None):
        super(DependencyRef, self).__init__(ref, )
supermod.DependencyRef.subclass = DependencyRef
# end class DependencyRef


class NoteRef(supermod.NoteRef):
    def __init__(self, ref=None):
        super(NoteRef, self).__init__(ref, )
supermod.NoteRef.subclass = NoteRef
# end class NoteRef


class Dependencies(supermod.Dependencies):
    def __init__(self, used=None, wasGeneratedBy=None, wasStartedBy=None, wasEndedBy=None, wasInformedBy=None, wasStartedByActivity=None, wasAttributedTo=None, wasAssociatedWith=None, actedOnBehalfOf=None, wasDerivedFrom=None, wasRevisionOf=None, wasQuotedFrom=None, hadOriginalSource=None, tracedTo=None, alternateOf=None, specializationOf=None, hasAnnotation=None):
        super(Dependencies, self).__init__(used, wasGeneratedBy, wasStartedBy, wasEndedBy, wasInformedBy, wasStartedByActivity, wasAttributedTo, wasAssociatedWith, actedOnBehalfOf, wasDerivedFrom, wasRevisionOf, wasQuotedFrom, hadOriginalSource, tracedTo, alternateOf, specializationOf, hasAnnotation, )
supermod.Dependencies.subclass = Dependencies
# end class Dependencies


class Account(supermod.Account):
    def __init__(self, id=None, asserter=None, records=None):
        super(Account, self).__init__(id, asserter, records, )
supermod.Account.subclass = Account
# end class Account


class Records(supermod.Records):
    def __init__(self, id=None, account=None, activity=None, entity=None, agent=None, note=None, dependencies=None):
        super(Records, self).__init__(id, account, activity, entity, agent, note, dependencies, )
supermod.Records.subclass = Records
# end class Records


class Container(supermod.Container):
    def __init__(self, id=None, records=None):
        super(Container, self).__init__(id, records, )
supermod.Container.subclass = Container
# end class Container


class annotationListType(supermod.annotationListType):
    def __init__(self, annotation=None):
        super(annotationListType, self).__init__(annotation, )
supermod.annotationListType.subclass = annotationListType
# end class annotationListType


class revisionListType(supermod.revisionListType):
    def __init__(self, revision=None):
        super(revisionListType, self).__init__(revision, )
supermod.revisionListType.subclass = revisionListType
# end class revisionListType


class contributorListType(supermod.contributorListType):
    def __init__(self, contributor=None):
        super(contributorListType, self).__init__(contributor, )
supermod.contributorListType.subclass = contributorListType
# end class contributorListType


class stepsType(supermod.stepsType):
    def __init__(self, step=None, stepRef=None):
        super(stepsType, self).__init__(step, stepRef, )
supermod.stepsType.subclass = stepsType
# end class stepsType


class itemsType(supermod.itemsType):
    def __init__(self, item=None):
        super(itemsType, self).__init__(item, )
supermod.itemsType.subclass = itemsType
# end class itemsType


class catalogListType(supermod.catalogListType):
    def __init__(self, catalog=None, catalogRef=None):
        super(catalogListType, self).__init__(catalog, catalogRef, )
supermod.catalogListType.subclass = catalogListType
# end class catalogListType


class catalogRefType(supermod.catalogRefType):
    def __init__(self, catalogID=None):
        super(catalogRefType, self).__init__(catalogID, )
supermod.catalogRefType.subclass = catalogRefType
# end class catalogRefType


class entryListType(supermod.entryListType):
    def __init__(self, entry=None, entryDataRef=None, entryResourceRef=None):
        super(entryListType, self).__init__(entry, entryDataRef, entryResourceRef, )
supermod.entryListType.subclass = entryListType
# end class entryListType


class commentListType(supermod.commentListType):
    def __init__(self, comment=None):
        super(commentListType, self).__init__(comment, )
supermod.commentListType.subclass = commentListType
# end class commentListType


class annotationListType1(supermod.annotationListType1):
    def __init__(self, annotation=None):
        super(annotationListType1, self).__init__(annotation, )
supermod.annotationListType1.subclass = annotationListType1
# end class annotationListType1


class resourceListType(supermod.resourceListType):
    def __init__(self, resource=None):
        super(resourceListType, self).__init__(resource, )
supermod.resourceListType.subclass = resourceListType
# end class resourceListType


class exptDesignListType(supermod.exptDesignListType):
    def __init__(self, exptDesign=None, exptDesignRef=None):
        super(exptDesignListType, self).__init__(exptDesign, exptDesignRef, )
supermod.exptDesignListType.subclass = exptDesignListType
# end class exptDesignListType


class subjectGroupListType(supermod.subjectGroupListType):
    def __init__(self, subjectGroup=None):
        super(subjectGroupListType, self).__init__(subjectGroup, )
supermod.subjectGroupListType.subclass = subjectGroupListType
# end class subjectGroupListType


class datapointsType(supermod.datapointsType):
    def __init__(self, label=None, value=None, valueOf_=None, mixedclass_=None, content_=None):
        super(datapointsType, self).__init__(label, value, valueOf_, mixedclass_, content_, )
supermod.datapointsType.subclass = datapointsType
# end class datapointsType


class measurementFrameType(supermod.measurementFrameType):
    def __init__(self, vector=None):
        super(measurementFrameType, self).__init__(vector, )
supermod.measurementFrameType.subclass = measurementFrameType
# end class measurementFrameType


class documentationListType(supermod.documentationListType):
    def __init__(self, documentation=None):
        super(documentationListType, self).__init__(documentation, )
supermod.documentationListType.subclass = documentationListType
# end class documentationListType


class extensionListType(supermod.extensionListType):
    def __init__(self, extension=None):
        super(extensionListType, self).__init__(extension, )
supermod.extensionListType.subclass = extensionListType
# end class extensionListType


class metaFieldsType(supermod.metaFieldsType):
    def __init__(self, metaField=None):
        super(metaFieldsType, self).__init__(metaField, )
supermod.metaFieldsType.subclass = metaFieldsType
# end class metaFieldsType


class metaFieldType(supermod.metaFieldType):
    def __init__(self, name=None, valueOf_=None):
        super(metaFieldType, self).__init__(name, valueOf_, )
supermod.metaFieldType.subclass = metaFieldType
# end class metaFieldType


class itemTextType(supermod.itemTextType):
    def __init__(self, textLabel=None):
        super(itemTextType, self).__init__(textLabel, )
supermod.itemTextType.subclass = itemTextType
# end class itemTextType


class textLabelType(supermod.textLabelType):
    def __init__(self, location=None, value=None):
        super(textLabelType, self).__init__(location, value, )
supermod.textLabelType.subclass = textLabelType
# end class textLabelType


class itemChoiceType(supermod.itemChoiceType):
    def __init__(self, units=None, itemCode=None, itemValue=None, ID=None):
        super(itemChoiceType, self).__init__(units, itemCode, itemValue, ID, )
supermod.itemChoiceType.subclass = itemChoiceType
# end class itemChoiceType


class dataInstanceType(supermod.dataInstanceType):
    def __init__(self, validated=None, assessmentInfo=None, assessmentItem=None):
        super(dataInstanceType, self).__init__(validated, assessmentInfo, assessmentItem, )
supermod.dataInstanceType.subclass = dataInstanceType
# end class dataInstanceType


class nsOntologyAnnotation_t(supermod.nsOntologyAnnotation_t):
    def __init__(self, timestamp=None, author=None, term=None):
        super(nsOntologyAnnotation_t, self).__init__(timestamp, author, term, )
supermod.nsOntologyAnnotation_t.subclass = nsOntologyAnnotation_t
# end class nsOntologyAnnotation_t


class nsTermAnnotation_t(supermod.nsTermAnnotation_t):
    def __init__(self, timestamp=None, author=None, ontologyClass=None):
        super(nsTermAnnotation_t, self).__init__(timestamp, author, ontologyClass, )
supermod.nsTermAnnotation_t.subclass = nsTermAnnotation_t
# end class nsTermAnnotation_t


class resource_t(supermod.resource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, extensiontype_=None):
        super(resource_t, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, extensiontype_, )
supermod.resource_t.subclass = resource_t
# end class resource_t


class catalog_t(supermod.catalog_t):
    def __init__(self, metaFields=None, level=None, description=None, name=None, ID=None, catalogList=None, entryList=None):
        super(catalog_t, self).__init__(metaFields, level, description, name, ID, catalogList, entryList, )
supermod.catalog_t.subclass = catalog_t
# end class catalog_t


class protocol_t(supermod.protocol_t):
    def __init__(self, termPath=None, description=None, maxOccurences=None, required=None, nomenclature=None, minOccurences=None, abbreviation=None, preferredLabel=None, termID=None, level=None, ID=None, name=None, protocolOffset=None, steps=None, items=None):
        super(protocol_t, self).__init__(termPath, description, maxOccurences, required, nomenclature, minOccurences, abbreviation, preferredLabel, termID, level, ID, name, protocolOffset, steps, items, )
supermod.protocol_t.subclass = protocol_t
# end class protocol_t


class analysis_t(supermod.analysis_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, level=None, provenance=None, input=None, output=None, measurementGroup=None):
        super(analysis_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, level, provenance, input, output, measurementGroup, )
supermod.analysis_t.subclass = analysis_t
# end class analysis_t


class subject_t(supermod.subject_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, subjectInfo=None):
        super(subject_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, subjectInfo, )
supermod.subject_t.subclass = subject_t
# end class subject_t


class measurementGroup_t(supermod.measurementGroup_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, entity=None, observation=None):
        super(measurementGroup_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, entity, observation, )
supermod.measurementGroup_t.subclass = measurementGroup_t
# end class measurementGroup_t


class assessment_t(supermod.assessment_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provEntityID=None, level=None, name=None, dataInstance=None, annotation=None):
        super(assessment_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provEntityID, level, name, dataInstance, annotation, )
supermod.assessment_t.subclass = assessment_t
# end class assessment_t


class events_t(supermod.events_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provEntityID=None, level=None, params=None, event=None, description=None, annotation=None):
        super(events_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provEntityID, level, params, event, description, annotation, )
supermod.events_t.subclass = events_t
# end class events_t


class dataResource_t(supermod.dataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, extensiontype_=None):
        super(dataResource_t, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, extensiontype_, )
supermod.dataResource_t.subclass = dataResource_t
# end class dataResource_t


class informationResource_t(supermod.informationResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, extensiontype_=None):
        super(informationResource_t, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, extensiontype_, )
supermod.informationResource_t.subclass = informationResource_t
# end class informationResource_t

class acquisition_t(supermod.acquisition_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, acquisitionProtocol=None, acquisitionInfo=None, dataResourceRef=None, dataRef=None, anytypeobjs_=None):
        super(acquisition_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, acquisitionProtocol, acquisitionInfo, dataResourceRef, dataRef, anytypeobjs_, )
supermod.acquisition_t.subclass = acquisition_t
# end class acquisition_t


class episode_t(supermod.episode_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, episodeInfo=None, anytypeobjs_=None):
        super(episode_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, episodeInfo, anytypeobjs_, )
supermod.episode_t.subclass = episode_t
# end class episode_t


class study_t(supermod.study_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, studyInfo=None, anytypeobjs_=None):
        super(study_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, studyInfo, anytypeobjs_, )
supermod.study_t.subclass = study_t
# end class study_t


class visit_t(supermod.visit_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, subjectURI=None, projectID=None, subjectGroupID=None, projectURI=None, subjectID=None, visitInfo=None, anytypeobjs_=None):
        super(visit_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, subjectURI, projectID, subjectGroupID, projectURI, subjectID, visitInfo, anytypeobjs_, )
supermod.visit_t.subclass = visit_t
# end class visit_t


class project_t(supermod.project_t):
    def __init__(self, metaFields=None, termPath=None, rev=None, nomenclature=None, abbreviation=None, preferredLabel=None, termID=None, type_=None, ID=None, commentList=None, annotationList=None, resourceList=None, provActivityID=None, projectInfo=None, contributorList=None, anytypeobjs_=None):
        super(project_t, self).__init__(metaFields, termPath, rev, nomenclature, abbreviation, preferredLabel, termID, type_, ID, commentList, annotationList, resourceList, provActivityID, projectInfo, contributorList, anytypeobjs_, )
supermod.project_t.subclass = project_t
# end class project_t


class binaryDataResource_t(supermod.binaryDataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, elementType=None, byteOrder=None, compression=None, extensiontype_=None):
        super(binaryDataResource_t, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, elementType, byteOrder, compression, extensiontype_, )
supermod.binaryDataResource_t.subclass = binaryDataResource_t
# end class binaryDataResource_t


class dcResource_t(supermod.dcResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, title=None, creator=None, subject=None, publisher=None, contributor=None, date=None, type_=None, identifier=None, source=None, language=None, relation=None, coverage=None, rights=None):
        super(dcResource_t, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, title, creator, subject, publisher, contributor, date, type_, identifier, source, language, relation, coverage, rights, )
supermod.dcResource_t.subclass = dcResource_t
# end class dcResource_t


class mappedBinaryDataResource_t(supermod.mappedBinaryDataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, elementType=None, byteOrder=None, compression=None, dimension=None, originCoords=None):
        super(mappedBinaryDataResource_t, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, elementType, byteOrder, compression, dimension, originCoords, )
supermod.mappedBinaryDataResource_t.subclass = mappedBinaryDataResource_t
# end class mappedBinaryDataResource_t


class dimensionedBinaryDataResource_t(supermod.dimensionedBinaryDataResource_t):
    def __init__(self, metaFields=None, dataID=None, description=None, format=None, dataURI=None, cachePath=None, level=None, content=None, provEntityID=None, analysisURI=None, analysisID=None, ID=None, name=None, uri=None, provenance=None, elementType=None, byteOrder=None, compression=None, dimension=None):
        super(dimensionedBinaryDataResource_t, self).__init__(metaFields, dataID, description, format, dataURI, cachePath, level, content, provEntityID, analysisURI, analysisID, ID, name, uri, provenance, elementType, byteOrder, compression, dimension, )
supermod.dimensionedBinaryDataResource_t.subclass = dimensionedBinaryDataResource_t
# end class dimensionedBinaryDataResource_t



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
Usage: python pyxcede.py <infilename>
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


