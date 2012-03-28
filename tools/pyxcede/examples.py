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

# we can print out the project object to the terminal as xml by running this
xcede.export(sys.stdout,0)
