This dataset represents the data collected during one fMRI run
of an auditory oddball task on a healthy subject.  This XCEDE 2
dataset shows examples of the binary data interface (the
resource element in ACQUISITION.xcede), catalogs (the catalog
element in CATALOG.xcede), experimental hierarchy elements
(PROJECT.xcede, SUBJECT.xcede, VISIT.xcede, STUDY.xcede, EPISODE.xcede),
analysis (ANALYSIS.xml), protocol (what steps, and in what order
should things be done -- protocol element in
AssessmentProtocolExample.xcede), and clinical assessment
data (data element in AssessmentProtocolExample.xcede).

Both EPISODE.xcede and ACQUISITION.xcede show how extensions to
the core XCEDE 2 schema are used.  EPISODE.xcede uses the
fbirn:fipsEpisodeInfo_t type to extend episodeInfo with
metadata specific to FIPS (fBIRN Image Processing Stream).
The extended type is defined in ../../extensions/fbirn/xcede-fbirn-base.xsd.
ACQUISITION.xcede uses the mrAcquisitionInfo_t type in ../../xcede-2.0-mr.xsd
to extend the acquisitionInfo element with MR-specific types (using
the DICOM MR Image Module as a basis for naming and for default
terminological links [see xcede-2.0-mr.xsd for the exact mappings]).
