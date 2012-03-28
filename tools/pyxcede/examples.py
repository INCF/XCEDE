#!/usr/local/bin/python

__author__ = 'Nolan Nichols'


import pyxcede, sys

# Lets start out with the XCEDE 'Project' object and see how we might populate an XML file starting from the
# ground up - that is from a group of subjects.

# first create a subject list for two groups
groupA = ['subject1','subject2','subject3','subject4','subject5',]
groupB = ['subject6','subject7','subject8','subject9','subject10',]

# next we create an instance of the subjectGroup_t data type
subjectGroupA = pyxcede.subjectGroup_t(ID='groupA', subjectID=groupA)
subjectGroupB = pyxcede.subjectGroup_t(ID='groupB', subjectID=groupB)
# note that when creating the instance we can populate it takes the full list of subjectsID
# alternatively we can add one subject at a time with subjectGroupA.add_subjectID('subject1')

# once we have our instances of subjectGroup_t for both subject groups we can add them to a
# subjectGroupListType object which is a container for groups in a single project
subjectGroupListA = pyxcede.subjectGroupListType(subjectGroup=[subjectGroupA,subjectGroupB])

# the next step is to add our subjectGroupListA to a projectInfo_t data type, and add a description
projectInfoA = pyxcede.projectInfo_t(subjectGroupList=subjectGroupListA, description="This is ProjectA")

# now that we have a description and a container for out project, we need to create the Project object itself
projectA = pyxcede.project_t(ID='projectA', projectInfo=projectInfoA)
# note that there are several other attributes we can add to the Project object - either upon instantiation or using
# set methods like so:

projectA.set_abbreviation('proj-a')
# and set a semantic annotation
projectA.set_nomenclature('DOAP')
projectA.set_termID('Project')
projectA.set_termPath('http://usefulinc.com/ns/doap#Project')

# now that we have built up to hierarchy for a single project let's add it to the root XCEDE object
xcede = pyxcede.XCEDE(project=[projectA,])

# we can print out the project object to the terminal after adding a few namespaces
namespace = 'xmlns:prov="http://openprovenance.org/prov-xml#" '
namespace += 'xmlns:cu="http://www.w3.org/1999/xhtml/datatypes/" '
namespace += 'xmlns="http://www.xcede.org/xcede-2" '
namespace += 'xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" '
namespace += 'xsi:schemaLocation="http://www.xcede.org/xcede-2 http://...xcede-2.1-core.xsd" '
namespace += 'xmlns:xcede2="http://www.xcede.org/xcede-2" xcede2:version="version1"'

# and print it out
xcede.export(sys.stdout,0, namespacedef_= namespace)

'''
<xcede2:XCEDE xmlns:prov="http://openprovenance.org/prov-xml#" xmlns:cu="http://www.w3.org/1999/xhtml/datatypes/" xmlns="http://www.xcede.org/xcede-2" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.xcede.org/xcede-2 xcede-2.1.1-core.xsd" xmlns:xcede2="http://www.xcede.org/xcede-2" xcede2:version="version1">
    <xcede2:project termPath="http://usefulinc.com/ns/doap#Project" nomenclature="DOAP" abbreviation="proj-a" termID="Project" ID="projectA">
        <xcede2:projectInfo>
            <xcede2:description>This is ProjectA</xcede2:description>
            <xcede2:subjectGroupList>
                <xcede2:subjectGroup ID="groupA">
                    <xcede2:subjectID>subject1</xcede2:subjectID>
                    <xcede2:subjectID>subject2</xcede2:subjectID>
                    <xcede2:subjectID>subject3</xcede2:subjectID>
                    <xcede2:subjectID>subject4</xcede2:subjectID>
                    <xcede2:subjectID>subject5</xcede2:subjectID>
                </xcede2:subjectGroup>
                <xcede2:subjectGroup ID="groupB">
                    <xcede2:subjectID>subject6</xcede2:subjectID>
                    <xcede2:subjectID>subject7</xcede2:subjectID>
                    <xcede2:subjectID>subject8</xcede2:subjectID>
                    <xcede2:subjectID>subject9</xcede2:subjectID>
                    <xcede2:subjectID>subject10</xcede2:subjectID>
                </xcede2:subjectGroup>
            </xcede2:subjectGroupList>
        </xcede2:projectInfo>
    </xcede2:project>
</xcede2:XCEDE>
'''