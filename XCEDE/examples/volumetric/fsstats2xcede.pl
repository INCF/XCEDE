#!/usr/bin/perl -w

# This script converts aseg.stats files from FreeSurfer
# into XCEDE 2.

use strict;

use File::Spec;

my $usage = <<EOM;
Usage:
  $0 aseg_stats_file
EOM

my $projectid = undef;
my $subjectid = undef;
my $visitid = undef;
my $studyid = undef;
my $episodeid = undef;
my $acquisitionid = undef;

my @oldARGV = @ARGV;
@ARGV = ();
while (scalar(@oldARGV)) {
  my $arg = shift @oldARGV;
  if ($arg =~ /^--$/) {
    push @ARGV, @oldARGV;
    last;
  }
  if ($arg !~ /^--/) {
    push @ARGV, $arg;
    next;
  }
  my ($opt, undef, $opteq, $optarg) = ($arg =~ /^--([^=]+)((=)?(.*))$/);
  if (defined($opteq)) {
    unshift @oldARGV, $optarg;
  }
  if (scalar(@oldARGV) > 0) {
    $optarg = $oldARGV[0]; # in case option takes argument
  }
  if ($opt eq 'help') {
    print STDERR $usage;
    exit(-1);
  } elsif ($opt eq 'projectid' && defined($optarg)) {
    shift @oldARGV;
    $projectid = $optarg;
  } elsif ($opt eq 'subjectid' && defined($optarg)) {
    shift @oldARGV;
    $subjectid = $optarg;
  } elsif ($opt eq 'visitid' && defined($optarg)) {
    shift @oldARGV;
    $visitid = $optarg;
  } elsif ($opt eq 'studyid' && defined($optarg)) {
    shift @oldARGV;
    $studyid = $optarg;
  } elsif ($opt eq 'episodeid' && defined($optarg)) {
    shift @oldARGV;
    $episodeid = $optarg;
  } elsif ($opt eq 'acquisitionid' && defined($optarg)) {
    shift @oldARGV;
    $acquisitionid = $optarg;
  } else {
    die "Unrecognized option '$opt' (or missing argument?)\nUse --help for options.\n";
  }
}

if (@ARGV != 1) {
  die "Wrong number of arguments!\n$usage"
}

my $STATSfile = shift;

my (undef, undef, $STATSfilename) = File::Spec->splitpath($STATSfile);

my %colheader2type =
  (
   'Index' => 'integer',
   'SegId' => 'integer',
   'NVoxels' => 'integer',
   'Volume_mm3' => 'float',
   'StructName' => 'varchar',
   'normMean' => 'float',
   'normStdDev' => 'float',
   'normMin' => 'float',
   'normMax' => 'float',
   'normRange' => 'float',
   'NumVert' => 'integer',
   'SurfArea' => 'float',
   'GrayVol' => 'float',
   'ThickAvg' => 'float',
   'ThickStd' => 'float',
   'MeanCurv' => 'float',
   'GausCurv' => 'float',
   'FoldInd' => 'float',
   'CurvInd' => 'float',
  );

# the actual definition of the struct is in a function at the end of the file
# to aid readability of this (ultimately simple) script.
my $structpropsref = &get_struct_props();

my %metafields = ();
my @tablecols = ();
my %colname2num = ();
my @tabledata = ();
open(FH, '<', $STATSfile) || die "Error opening $STATSfile: $!\n";
while (<FH>) {
  my $iscomment = 0;
  if (/^#/) {
    $iscomment = 1;
    s/^#//;
  }
  s/^\s+//;
  s/\s+$//;
  next if /^$/;
  if ($iscomment) {
    my ($name, $value) = split(/\s+/, $_, 2);
    if ($name eq 'TableCol') {
      my ($colnum, $colfield, $colvalue) = split(/\s+/, $value, 3);
      $tablecols[$colnum]->{$colfield} = $colvalue;
    } else {
      $metafields{$name} = $value;
    }
  } else {
    # add an undef element at the beginning to represent dummy column 0
    # since column indexes start at 1
    push @tabledata, [undef, split(/\s+/, $_)];
  }
}
close FH;
for my $colnum (1..$#tablecols) {
  my $tablecolref = $tablecols[$colnum];
  $colname2num{$tablecolref->{'ColHeader'}} = $colnum;
}

my $nomenclature = undef;
my $fileHemi = undef;
my $anatomytype = $metafields{'anatomy_type'};
my $analysistype = undef;
if ($STATSfilename eq 'aseg.stats') {
  $nomenclature = 'FreeSurferColorLUT';
  $analysistype = "FreeSurfer-${anatomytype}-aseg";
} elsif ($STATSfilename eq 'wmparc.stats') {
  $nomenclature = 'FreeSurferColorLUT';
  $analysistype = "FreeSurfer-${anatomytype}-wmparc";
} elsif ($STATSfilename eq 'lh.aparc.stats') {
  $nomenclature = 'lh.aparc.annot';
  $fileHemi = 'left';
  $analysistype = "FreeSurfer-${anatomytype}-aparc";
} elsif ($STATSfilename eq 'rh.aparc.stats') {
  $nomenclature = 'rh.aparc.annot';
  $fileHemi = 'right';
  $analysistype = "FreeSurfer-${anatomytype}-aparc";
} elsif ($STATSfilename eq 'lh.aparc.a2005s.stats') {
  $nomenclature = 'lh.aparc.a2005s.annot';
  $fileHemi = 'left';
  $analysistype = "FreeSurfer-${anatomytype}-aparc";
} elsif ($STATSfilename eq 'rh.aparc.a2005s.stats') {
  $nomenclature = 'rh.aparc.a2005s.annot';
  $fileHemi = 'right';
  $analysistype = "FreeSurfer-${anatomytype}-aparc";
}

my $subject = <<EOM;
EOM

my $provenance = <<EOM;
    <provenance>
      <processStep>
        <program>$metafields{'generating_program'}</program>
        <programArguments>$metafields{'cmdline'}</programArguments>
        <user>$metafields{'user'}</user>
        <hostName>$metafields{'hostname'}</hostName>
        <platform>$metafields{'sysname'}</platform>
        <cvs>$metafields{'cvs_version'}</cvs>
        <package>FreeSurfer</package>
      </processStep>
    </provenance>
EOM

my $measurementgroups = '';
my @colheaders = split(/\s+/, $metafields{'ColHeaders'});
my $colnum_structname = $colname2num{'StructName'};
my $colnum_segid = undef;
if (exists($colname2num{'SegId'})) {
  $colnum_segid = $colname2num{'SegId'};
}
for my $rowref (@tabledata) {
  my $structname = $rowref->[$colnum_structname];
  my ($structHemi, $structTissue);
  if (exists($structpropsref->{$structname})) {
    ($structHemi, $structTissue, undef, undef) =
      @{$structpropsref->{$structname}};
  }
  my $segid = undef;
  if (defined($colnum_segid)) {
    $segid = $rowref->[$colnum_segid];
  } else {
    $segid = $structname;
  }

  my $laterality = undef;
  my $laterality_attr = '';
  if (defined($structHemi)) {
    $laterality = $structHemi;
  } elsif (defined($fileHemi)) {
    $laterality = $fileHemi;
  } elsif ($structname =~ /^(Left|Right)-/) {
    $laterality = lc($1);
  } elsif ($structname =~ /.*-(lh|rh)-.*/) {
    if ($1 eq 'lh') {
      $laterality = 'left';
    } elsif ($1 eq 'rh') {
      $laterality = 'right';
    }
  }
  if (defined($laterality)) {
    $laterality_attr = " laterality=\"$laterality\"";
  }

  my $tissuetype = undef;
  my $tissuetype_attr = '';
  if (defined($structTissue)) {
    $tissuetype = $structTissue;
  } elsif ($structname =~ /^ctx-/) {
    $tissuetype = 'gray';
  } elsif ($structname =~ /^wm-/) {
    $tissuetype = 'white';
  }
  if (defined($tissuetype)) {
    $tissuetype_attr = " tissueType=\"$tissuetype\"";
  }

  $measurementgroups .= "    <measurementGroup>\n";
  $measurementgroups .= "      <entity xsi:type=\"anatomicalEntity_t\"${laterality_attr}${tissuetype_attr}>\n";
  $measurementgroups .= "        <label nomenclature=\"${nomenclature}\" termID=\"${segid}\">${structname}</label>\n";
  $measurementgroups .= "      </entity>\n";
  for my $colnum (1..$#colheaders) {
    my $tablecolref = $tablecols[$colnum];
    my $colheader = $tablecolref->{'ColHeader'};
    next if ($colheader eq 'Index' ||
	     $colheader eq 'StructName' ||
	     $colheader eq 'SegId');
    my $fieldname = $tablecolref->{'FieldName'};
    my $units = $tablecolref->{'Units'};
    my $unitsattr = '';
    if ($units ne 'NA' && $units ne 'unitless' && $units ne 'MR') {
      $unitsattr = " units=\"$units\"";
    }
    my $type = $colheader2type{$colheader};
    $measurementgroups .= "      <observation name=\"$colheader\" type=\"$type\"$unitsattr>$rowref->[$colnum]</observation>\n";
  }
  $measurementgroups .= "    </measurementGroup>\n";
}

my $analysisID = '';
my $hierID = '';
if (defined($projectid)) {
  $analysisID .= (length($analysisID) ? ' ' : '') . $projectid;
  $hierID .= (length($hierID) ? ' ' : '') . "projectID=\"${projectid}\"";
}
if (defined($subjectid)) {
  $analysisID .= (length($analysisID) ? ' ' : '') . $subjectid;
  $hierID .= (length($hierID) ? ' ' : '') . "subjectID=\"${subjectid}\"";
} else {
  $analysisID .= (length($analysisID) ? ' ' : '') . $metafields{'subjectname'};
  $hierID .= (length($hierID) ? ' ' : '') . "subjectID=\"$metafields{'subjectname'}\"";
}
if (defined($visitid)) {
  $analysisID .= (length($analysisID) ? ' ' : '') . $visitid;
  $hierID .= (length($hierID) ? ' ' : '') . "visitID=\"${visitid}\"";
}
if (defined($studyid)) {
  $analysisID .= (length($analysisID) ? ' ' : '') . $studyid;
  $hierID .= (length($hierID) ? ' ' : '') . "visitID=\"${visitid}\"";
}
if (defined($episodeid)) {
  $analysisID .= (length($analysisID) ? ' ' : '') . $episodeid;
  $hierID .= (length($hierID) ? ' ' : '') . "episodeID=\"${episodeid}\"";
}
if (defined($acquisitionid)) {
  $analysisID .= (length($analysisID) ? ' ' : '') . $acquisitionid;
  $hierID .= (length($hierID) ? ' ' : '') . "acquisitionID=\"${acquisitionid}\"";
}
$analysisID .= (length($analysisID)? ' ' : '') . "FreeSurfer ${STATSfilename} (XML)";

print <<EOM;
<?xml version="1.0" encoding="UTF-8"?>
<XCEDE xmlns="http://www.xcede.org/xcede-2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
  <analysis ID="${analysisID}" type="$analysistype" $hierID>
$provenance
$measurementgroups
  </analysis>
</XCEDE>
EOM


sub get_struct_props {
  return
    {
     'Unknown' => [ undef, undef, undef, undef ],
     'Left-Cerebral-Exterior' => [ 'left', undef, undef, undef ],
     'Left-Cerebral-White-Matter' => [ 'left', 'white', 'C0152295', 'Cerebral white matter structure' ],
     'Left-Cerebral-Cortex' => [ 'left', 'gray', 'C0007776', 'Cerebral cortex' ],
     'Left-Lateral-Ventricle' => [ 'left', undef, 'C0152279', 'Lateral ventricle structure' ],
     'Left-Inf-Lat-Vent' => [ 'left', undef, 'C0152283', 'Structure of inferior horn of lateral ventricle (body structure)' ],
     'Left-Cerebellum-Exterior' => [ 'left', undef, 'C0007765', 'Cerebellum' ],
     'Left-Cerebellum-White-Matter' => [ 'left', 'white', 'C0152381', 'Cerebellar white matter structure (body structure)' ],
     'Left-Cerebellum-Cortex' => [ 'left', 'gray', undef, undef ],
     'Left-Thalamus' => [ 'left', undef, 'C0039729', 'Thalamic structure' ],
     'Left-Thalamus-Proper' => [ 'left', undef, 'C0039729', 'Thalamic structure' ],
     'Left-Caudate' => [ 'left', undef, 'C0007461', 'Caudate nucleus structure' ],
     'Left-Putamen' => [ 'left', undef, undef, undef ],
     'Left-Pallidum' => [ 'left', undef, 'C0017651', 'Globus Pallidus' ],
     '3rd-Ventricle' => [ undef, undef, 'C0149555', 'Third ventricle structure' ],
     '4th-Ventricle' => [ undef, undef, undef, undef ],
     'Brain-Stem' => [ undef, undef, 'C0006121', 'Brain Stem' ],
     'Left-Hippocampus' => [ 'left', undef, 'C0175202', 'Hippocampal Formation' ],
     'Left-Amygdala' => [ 'left', undef, 'C0002708', 'Amygdaloid structure' ],
     'Left-Insula' => [ 'left', undef, 'C0021640', 'Insula of Reil' ],
     'Left-Operculum' => [ 'left', undef, 'C0262296', 'opercular part of inferior frontal gyrus (human only)' ],
     'Line-1' => [ undef, undef, undef, undef ],
     'Line-2' => [ undef, undef, undef, undef ],
     'Line-3' => [ undef, undef, undef, undef ],
     'CSF' => [ undef, undef, undef, undef ],
     'Left-Lesion' => [ 'left', undef, undef, undef ],
     'Left-Accumbens-area' => [ 'left', undef, undef, undef ],
     'Left-Substancia-Nigra' => [ 'left', undef, 'C0038590', 'Substantia nigra structure' ],
     'Left-VentralDC' => [ 'left', undef, undef, undef ],
     'Left-undetermined' => [ 'left', undef, undef, undef ],
     'Left-vessel' => [ 'left', undef, undef, undef ],
     'Left-choroid-plexus' => [ 'left', undef, undef, undef ],
     'Left-F3orb' => [ 'left', undef, 'C0262300', 'orbital part of inferior frontal gyrus (human only)' ],
     'Left-lOg' => [ 'left', undef, 'C0262268', 'Lateral orbital gyrus (body structure)' ],
     'Left-aOg' => [ 'left', undef, 'C0152301', 'Orbital gyrus (body structure)' ],
     'Left-mOg' => [ 'left', undef, 'C0175179', 'Medial orbital gyrus (body structure)' ],
     'Left-pOg' => [ 'left', undef, 'C0458323', 'Posterior orbital gyrus (body structure)' ],
     'Left-Stellate' => [ 'left', undef, undef, undef ],
     'Left-Porg' => [ 'left', undef, 'C0458323', 'Posterior orbital gyrus (body structure)' ],
     'Left-Aorg' => [ 'left', undef, 'C0152301', 'Orbital gyrus (body structure)' ],
     'Right-Cerebral-Exterior' => [ 'right', undef, undef, undef ],
     'Right-Cerebral-White-Matter' => [ 'right', 'white', 'C0152295', 'Cerebral white matter structure' ],
     'Right-Cerebral-Cortex' => [ 'right', 'gray', 'C0007776', 'Cerebral cortex' ],
     'Right-Lateral-Ventricle' => [ 'right', undef, 'C0152279', 'Lateral ventricle structure' ],
     'Right-Inf-Lat-Vent' => [ 'right', undef, 'C0152283', 'Structure of inferior horn of lateral ventricle (body structure)' ],
     'Right-Cerebellum-Exterior' => [ 'right', undef, 'C0007765', 'Cerebellum' ],
     'Right-Cerebellum-White-Matter' => [ 'right', 'white', 'C0152381', 'Cerebellar white matter structure (body structure)' ],
     'Right-Cerebellum-Cortex' => [ 'right', 'gray', undef, undef ],
     'Right-Thalamus' => [ 'right', undef, 'C0039729', 'Thalamic structure' ],
     'Right-Thalamus-Proper' => [ 'right', undef, 'C0039729', 'Thalamic structure' ],
     'Right-Caudate' => [ 'right', undef, 'C0007461', 'Caudate nucleus structure' ],
     'Right-Putamen' => [ 'right', undef, undef, undef ],
     'Right-Pallidum' => [ 'right', undef, 'C0017651', 'Globus Pallidus' ],
     'Right-Hippocampus' => [ 'right', undef, 'C0175202', 'Hippocampal Formation' ],
     'Right-Amygdala' => [ 'right', undef, 'C0002708', 'Amygdaloid structure' ],
     'Right-Insula' => [ 'right', undef, 'C0021640', 'Insula of Reil' ],
     'Right-Operculum' => [ 'right', undef, 'C0262296', 'opercular part of inferior frontal gyrus (human only)' ],
     'Right-Lesion' => [ 'right', undef, undef, undef ],
     'Right-Accumbens-area' => [ 'right', undef, undef, undef ],
     'Right-Substancia-Nigra' => [ 'right', undef, 'C0038590', 'Substantia nigra structure' ],
     'Right-VentralDC' => [ 'right', undef, undef, undef ],
     'Right-undetermined' => [ 'right', undef, undef, undef ],
     'Right-vessel' => [ 'right', undef, undef, undef ],
     'Right-choroid-plexus' => [ 'right', undef, undef, undef ],
     'Right-F3orb' => [ 'right', undef, 'C0262300', 'orbital part of inferior frontal gyrus (human only)' ],
     'Right-lOg' => [ 'right', undef, 'C0262268', 'Lateral orbital gyrus (body structure)' ],
     'Right-aOg' => [ 'right', undef, 'C0152301', 'Orbital gyrus (body structure)' ],
     'Right-mOg' => [ 'right', undef, 'C0175179', 'Medial orbital gyrus (body structure)' ],
     'Right-pOg' => [ 'right', undef, 'C0458323', 'Posterior orbital gyrus (body structure)' ],
     'Right-Stellate' => [ 'right', undef, undef, undef ],
     'Right-Porg' => [ 'right', undef, 'C0458323', 'Posterior orbital gyrus (body structure)' ],
     'Right-Aorg' => [ 'right', undef, 'C0152301', 'Orbital gyrus (body structure)' ],
     '5th-Ventricle' => [ undef, undef, 'C0036700', 'Septum Pellucidum' ],
     'Left-Interior' => [ 'left', undef, undef, undef ],
     'Right-Interior' => [ 'right', undef, undef, undef ],
     'Left-Lateral-Ventricles' => [ 'left', undef, 'C0152279', 'Lateral ventricle structure' ],
     'Right-Lateral-Ventricles' => [ 'right', undef, 'C0152279', 'Lateral ventricle structure' ],
     'WM-hypointensities' => [ undef, undef, undef, undef ],
     'Left-WM-hypointensities' => [ 'left', undef, undef, undef ],
     'Right-WM-hypointensities' => [ 'right', undef, undef, undef ],
     'non-WM-hypointensities' => [ undef, undef, undef, undef ],
     'Left-non-WM-hypointensities' => [ 'left', undef, undef, undef ],
     'Right-non-WM-hypointensities' => [ 'right', undef, undef, undef ],
     'Left-F1' => [ 'left', undef, 'C0152296', 'Structure of superior frontal gyrus' ],
     'Right-F1' => [ 'right', undef, 'C0152296', 'Structure of superior frontal gyrus' ],
     'Optic-Chiasm' => [ undef, undef, 'C0029126', 'Optic Chiasm' ],
     'Corpus_Callosum' => [ undef, undef, 'C0010090', 'Corpus Callosum' ],
     'Left-Amygdala-Anterior' => [ 'left', undef, 'C0002708', 'Amygdaloid structure' ],
     'Right-Amygdala-Anterior' => [ 'right', undef, 'C0002708', 'Amygdaloid structure' ],
     'Dura' => [ undef, undef, undef, undef ],
     'Left-wm-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Left-caudate-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Left-putamen-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Left-accumbens-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Left-pallidum-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Left-amygdala-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Left-hippocampus-intensity-abnormali' => [ 'left', undef, undef, undef ],
     'Left-thalamus-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Left-VDC-intensity-abnormality' => [ 'left', undef, undef, undef ],
     'Right-wm-intensity-abnormality' => [ 'right', undef, undef, undef ],
     'Right-caudate-intensity-abnormality' => [ 'right', undef, undef, undef ],
     'Right-putamen-intensity-abnormality' => [ 'right', undef, undef, undef ],
     'Right-accumbens-intensity-abnormalit' => [ 'right', undef, undef, undef ],
     'Right-pallidum-intensity-abnormality' => [ 'right', undef, undef, undef ],
     'Right-amygdala-intensity-abnormality' => [ 'right', undef, undef, undef ],
     'Right-hippocampus-intensity-abnormal' => [ 'right', undef, undef, undef ],
     'Right-thalamus-intensity-abnormality' => [ 'right', undef, undef, undef ],
     'Right-VDC-intensity-abnormality' => [ 'right', undef, undef, undef ],
     'Epidermis' => [ undef, undef, undef, undef ],
     'Conn-Tissue' => [ undef, undef, undef, undef ],
     'SC-Fat/Muscle' => [ undef, undef, undef, undef ],
     'Cranium' => [ undef, undef, undef, undef ],
     'CSF-SA' => [ undef, undef, undef, undef ],
     'Muscle' => [ undef, undef, undef, undef ],
     'Ear' => [ undef, undef, undef, undef ],
     'Adipose' => [ undef, undef, undef, undef ],
     'Spinal-Cord' => [ undef, undef, undef, undef ],
     'Soft-Tissue' => [ undef, undef, undef, undef ],
     'Nerve' => [ undef, undef, undef, undef ],
     'Bone' => [ undef, undef, undef, undef ],
     'Air' => [ undef, undef, undef, undef ],
     'Orbital-Fat' => [ undef, undef, undef, undef ],
     'Tongue' => [ undef, undef, undef, undef ],
     'Nasal-Structures' => [ undef, undef, undef, undef ],
     'Globe' => [ undef, undef, undef, undef ],
     'Teeth' => [ undef, undef, undef, undef ],
     'Left-Caudate/Putamen' => [ 'left', undef, 'C0162512', 'Neostriatum' ],
     'Right-Caudate/Putamen' => [ 'right', undef, 'C0162512', 'Neostriatum' ],
     'Left-Claustrum' => [ 'left', undef, 'C0008910', 'Claustral structure' ],
     'Right-Claustrum' => [ 'right', undef, 'C0008910', 'Claustral structure' ],
     'Cornea' => [ undef, undef, undef, undef ],
     'Diploe' => [ undef, undef, undef, undef ],
     'Vitreous-Humor' => [ undef, undef, undef, undef ],
     'Lens' => [ undef, undef, undef, undef ],
     'Aqueous-Humor' => [ undef, undef, undef, undef ],
     'Outer-Table' => [ undef, undef, undef, undef ],
     'Inner-Table' => [ undef, undef, undef, undef ],
     'Periosteum' => [ undef, undef, undef, undef ],
     'Endosteum' => [ undef, undef, undef, undef ],
     'R/C/S' => [ undef, undef, undef, undef ],
     'Iris' => [ undef, undef, undef, undef ],
     'SC-Adipose/Muscle' => [ undef, undef, undef, undef ],
     'SC-Tissue' => [ undef, undef, undef, undef ],
     'Orbital-Adipose' => [ undef, undef, undef, undef ],
     'Left-hippocampal_fissure' => [ 'left', undef, undef, undef ],
     'Left-CADG-head' => [ 'left', undef, 'C0175202', 'Hippocampal Formation' ],
     'Left-subiculum' => [ 'left', undef, undef, undef ],
     'Left-fimbria' => [ 'left', undef, 'C0152315', 'Fimbria of hippocampus' ],
     'Right-hippocampal_fissure' => [ 'right', undef, undef, undef ],
     'Right-CADG-head' => [ 'right', undef, 'C0175202', 'Hippocampal Formation' ],
     'Right-subiculum' => [ 'right', undef, undef, undef ],
     'Right-fimbria' => [ 'right', undef, 'C0152315', 'Fimbria of hippocampus' ],
     'alveus' => [ undef, undef, 'C0228247', 'Structure of alveus of hippocampus' ],
     'perforant_pathway' => [ undef, undef, undef, undef ],
     'parasubiculum' => [ undef, undef, undef, undef ],
     'presubiculum' => [ undef, undef, 'C0175194', 'presubiculum' ],
     'subiculum' => [ undef, undef, undef, undef ],
     'CA1' => [ undef, undef, 'C0694598', 'CA1 field' ],
     'CA2' => [ undef, undef, 'C0694599', 'CA2 field' ],
     'CA3' => [ undef, undef, 'C0694600', 'CA3 field' ],
     'CA4' => [ undef, undef, 'C1134421', 'hilus of dentate gyrus' ],
     'GC-DG' => [ undef, undef, undef, undef ],
     'HATA' => [ undef, undef, undef, undef ],
     'fimbria' => [ undef, undef, 'C0152315', 'Fimbria of hippocampus' ],
     'lateral_ventricle' => [ undef, undef, 'C0152279', 'Lateral ventricle structure' ],
     'molecular_layer_HP' => [ undef, undef, undef, undef ],
     'hippocampal_fissure' => [ undef, undef, undef, undef ],
     'entorhinal_cortex' => [ undef, undef, 'C0175196', 'Structure of entorhinal cortex' ],
     'molecular_layer_subiculum' => [ undef, undef, undef, undef ],
     'Amygdala' => [ undef, undef, 'C0002708', 'Amygdaloid structure' ],
     'Cerebral_White_Matter' => [ undef, 'white', 'C0152295', 'Cerebral white matter structure' ],
     'Cerebral_Cortex' => [ undef, 'gray', 'C0007776', 'Cerebral cortex' ],
     'Inf_Lat_Vent' => [ undef, undef, 'C0152283', 'Structure of inferior horn of lateral ventricle (body structure)' ],
     'Ectorhinal' => [ undef, undef, 'C0152313', 'Fusiform gyrus' ],
     'Perirhinal' => [ undef, undef, 'C0228249', 'Parahippocampal Gyrus' ],
     'Cerebral_White_Matter_Edge' => [ undef, 'white', undef, undef ],
     'fMRI_Background' => [ undef, undef, undef, undef ],
     'Aorta' => [ undef, undef, undef, undef ],
     'Left-Common-IliacA' => [ 'left', undef, undef, undef ],
     'Right-Common-IliacA' => [ 'right', undef, undef, undef ],
     'Left-External-IliacA' => [ 'left', undef, undef, undef ],
     'Right-External-IliacA' => [ 'right', undef, undef, undef ],
     'Left-Internal-IliacA' => [ 'left', undef, undef, undef ],
     'Right-Internal-IliacA' => [ 'right', undef, undef, undef ],
     'Left-Lateral-SacralA' => [ 'left', undef, undef, undef ],
     'Right-Lateral-SacralA' => [ 'right', undef, undef, undef ],
     'Left-ObturatorA' => [ 'left', undef, undef, undef ],
     'Right-ObturatorA' => [ 'right', undef, undef, undef ],
     'Left-Internal-PudendalA' => [ 'left', undef, undef, undef ],
     'Right-Internal-PudendalA' => [ 'right', undef, undef, undef ],
     'Left-UmbilicalA' => [ 'left', undef, undef, undef ],
     'Right-UmbilicalA' => [ 'right', undef, undef, undef ],
     'Left-Inf-RectalA' => [ 'left', undef, undef, undef ],
     'Right-Inf-RectalA' => [ 'right', undef, undef, undef ],
     'Left-Common-IliacV' => [ 'left', undef, undef, undef ],
     'Right-Common-IliacV' => [ 'right', undef, undef, undef ],
     'Left-External-IliacV' => [ 'left', undef, undef, undef ],
     'Right-External-IliacV' => [ 'right', undef, undef, undef ],
     'Left-Internal-IliacV' => [ 'left', undef, undef, undef ],
     'Right-Internal-IliacV' => [ 'right', undef, undef, undef ],
     'Left-ObturatorV' => [ 'left', undef, undef, undef ],
     'Right-ObturatorV' => [ 'right', undef, undef, undef ],
     'Left-Internal-PudendalV' => [ 'left', undef, undef, undef ],
     'Right-Internal-PudendalV' => [ 'right', undef, undef, undef ],
     'Pos-Lymph' => [ undef, undef, undef, undef ],
     'Neg-Lymph' => [ undef, undef, undef, undef ],
     'V1' => [ undef, undef, undef, undef ],
     'V2' => [ undef, undef, 'C1110642', 'Occipital gyrus (Macaque only)' ],
     'BA44' => [ undef, undef, 'C0149547', 'Frontal operculum structure (body structure)' ],
     'BA45' => [ undef, undef, 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'BA4a' => [ undef, undef, 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'BA4p' => [ undef, undef, 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'BA6' => [ undef, undef, 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'BA2' => [ undef, undef, 'C0152302', 'Structure of postcentral gyrus' ],
     'BAun1' => [ undef, undef, 'C0152302', 'Structure of postcentral gyrus' ],
     'BAun2' => [ undef, undef, 'C0152302', 'Structure of postcentral gyrus' ],
     'ctx-lh-unknown' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-bankssts' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-caudalanteriorcingulate' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-caudalmiddlefrontal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-corpuscallosum' => [ 'left', 'gray', 'C0010090', 'Corpus Callosum' ],
     'ctx-lh-cuneus' => [ 'left', 'gray', 'C0152307', 'Structure of cuneus' ],
     'ctx-lh-entorhinal' => [ 'left', 'gray', 'C0175196', 'Structure of entorhinal cortex' ],
     'ctx-lh-fusiform' => [ 'left', 'gray', 'C0152313', 'Fusiform gyrus' ],
     'ctx-lh-inferiorparietal' => [ 'left', 'gray', 'C0152304', 'Inferior parietal lobule structure (body structure)' ],
     'ctx-lh-inferiortemporal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-isthmuscingulate' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-lateraloccipital' => [ 'left', 'gray', 'C0228228', 'lateral occipital gyrus (human only)' ],
     'ctx-lh-lateralorbitofrontal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-lingual' => [ 'left', 'gray', 'C0152308', 'Lingual gyrus' ],
     'ctx-lh-medialorbitofrontal' => [ 'left', 'gray', 'C0016733', 'frontal lobe' ],
     'ctx-lh-middletemporal' => [ 'left', 'gray', 'C0152310', 'Structure of middle temporal gyrus' ],
     'ctx-lh-parahippocampal' => [ 'left', 'gray', 'C0228249', 'Parahippocampal Gyrus' ],
     'ctx-lh-paracentral' => [ 'left', 'gray', 'C0228204', 'paracentral sulcus (human only)' ],
     'ctx-lh-parsopercularis' => [ 'left', 'gray', 'C0149547', 'Frontal operculum structure (body structure)' ],
     'ctx-lh-parsorbitalis' => [ 'left', 'gray', 'C0694580', 'orbital operculum' ],
     'ctx-lh-parstriangularis' => [ 'left', 'gray', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'ctx-lh-pericalcarine' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-postcentral' => [ 'left', 'gray', 'C0152302', 'Structure of postcentral gyrus' ],
     'ctx-lh-posteriorcingulate' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-precentral' => [ 'left', 'gray', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'ctx-lh-precuneus' => [ 'left', 'gray', 'C0152306', 'Structure of precuneus' ],
     'ctx-lh-rostralanteriorcingulate' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-rostralmiddlefrontal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-superiorfrontal' => [ 'left', 'gray', 'C0152296', 'Structure of superior frontal gyrus' ],
     'ctx-lh-superiorparietal' => [ 'left', 'gray', 'C0152303', 'Structure of superior parietal lobule' ],
     'ctx-lh-superiortemporal' => [ 'left', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-lh-supramarginal' => [ 'left', 'gray', 'C0228214', 'Structure of supramarginal gyrus' ],
     'ctx-lh-frontalpole' => [ 'left', 'gray', 'C0149546', 'Structure of frontal pole' ],
     'ctx-lh-temporalpole' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-transversetemporal' => [ 'left', 'gray', undef, undef ],
     'ctx-rh-unknown' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-bankssts' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-caudalanteriorcingulate' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-caudalmiddlefrontal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-corpuscallosum' => [ 'right', 'gray', 'C0010090', 'Corpus Callosum' ],
     'ctx-rh-cuneus' => [ 'right', 'gray', 'C0152307', 'Structure of cuneus' ],
     'ctx-rh-entorhinal' => [ 'right', 'gray', 'C0175196', 'Structure of entorhinal cortex' ],
     'ctx-rh-fusiform' => [ 'right', 'gray', 'C0152313', 'Fusiform gyrus' ],
     'ctx-rh-inferiorparietal' => [ 'right', 'gray', 'C0152304', 'Inferior parietal lobule structure (body structure)' ],
     'ctx-rh-inferiortemporal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-isthmuscingulate' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-lateraloccipital' => [ 'right', 'gray', 'C0228228', 'lateral occipital gyrus (human only)' ],
     'ctx-rh-lateralorbitofrontal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-lingual' => [ 'right', 'gray', 'C0152308', 'Lingual gyrus' ],
     'ctx-rh-medialorbitofrontal' => [ 'right', 'gray', 'C0016733', 'frontal lobe' ],
     'ctx-rh-middletemporal' => [ 'right', 'gray', 'C0152310', 'Structure of middle temporal gyrus' ],
     'ctx-rh-parahippocampal' => [ 'right', 'gray', 'C0228249', 'Parahippocampal Gyrus' ],
     'ctx-rh-paracentral' => [ 'right', 'gray', 'C0228204', 'paracentral sulcus (human only)' ],
     'ctx-rh-parsopercularis' => [ 'right', 'gray', 'C0149547', 'Frontal operculum structure (body structure)' ],
     'ctx-rh-parsorbitalis' => [ 'right', 'gray', 'C0694580', 'orbital operculum' ],
     'ctx-rh-parstriangularis' => [ 'right', 'gray', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'ctx-rh-pericalcarine' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-postcentral' => [ 'right', 'gray', 'C0152302', 'Structure of postcentral gyrus' ],
     'ctx-rh-posteriorcingulate' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-precentral' => [ 'right', 'gray', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'ctx-rh-precuneus' => [ 'right', 'gray', 'C0152306', 'Structure of precuneus' ],
     'ctx-rh-rostralanteriorcingulate' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-rostralmiddlefrontal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-superiorfrontal' => [ 'right', 'gray', 'C0152296', 'Structure of superior frontal gyrus' ],
     'ctx-rh-superiorparietal' => [ 'right', 'gray', 'C0152303', 'Structure of superior parietal lobule' ],
     'ctx-rh-superiortemporal' => [ 'right', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-rh-supramarginal' => [ 'right', 'gray', 'C0228214', 'Structure of supramarginal gyrus' ],
     'ctx-rh-frontalpole' => [ 'right', 'gray', 'C0149546', 'Structure of frontal pole' ],
     'ctx-rh-temporalpole' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-transversetemporal' => [ 'right', 'gray', undef, undef ],
     'wm-lh-unknown' => [ 'left', 'white', undef, undef ],
     'wm-lh-bankssts' => [ 'left', 'white', undef, undef ],
     'wm-lh-caudalanteriorcingulate' => [ 'left', 'white', undef, undef ],
     'wm-lh-caudalmiddlefrontal' => [ 'left', 'white', undef, undef ],
     'wm-lh-corpuscallosum' => [ 'left', 'white', 'C0010090', 'Corpus Callosum' ],
     'wm-lh-cuneus' => [ 'left', 'white', 'C0152307', 'Structure of cuneus' ],
     'wm-lh-entorhinal' => [ 'left', 'white', 'C0175196', 'Structure of entorhinal cortex' ],
     'wm-lh-fusiform' => [ 'left', 'white', 'C0152313', 'Fusiform gyrus' ],
     'wm-lh-inferiorparietal' => [ 'left', 'white', 'C0152304', 'Inferior parietal lobule structure (body structure)' ],
     'wm-lh-inferiortemporal' => [ 'left', 'white', undef, undef ],
     'wm-lh-isthmuscingulate' => [ 'left', 'white', undef, undef ],
     'wm-lh-lateraloccipital' => [ 'left', 'white', 'C0228228', 'lateral occipital gyrus (human only)' ],
     'wm-lh-lateralorbitofrontal' => [ 'left', 'white', undef, undef ],
     'wm-lh-lingual' => [ 'left', 'white', 'C0152308', 'Lingual gyrus' ],
     'wm-lh-medialorbitofrontal' => [ 'left', 'white', 'C0016733', 'frontal lobe' ],
     'wm-lh-middletemporal' => [ 'left', 'white', 'C0152310', 'Structure of middle temporal gyrus' ],
     'wm-lh-parahippocampal' => [ 'left', 'white', 'C0228249', 'Parahippocampal Gyrus' ],
     'wm-lh-paracentral' => [ 'left', 'white', 'C0228204', 'paracentral sulcus (human only)' ],
     'wm-lh-parsopercularis' => [ 'left', 'white', 'C0149547', 'Frontal operculum structure (body structure)' ],
     'wm-lh-parsorbitalis' => [ 'left', 'white', 'C0694580', 'orbital operculum' ],
     'wm-lh-parstriangularis' => [ 'left', 'white', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'wm-lh-pericalcarine' => [ 'left', 'white', undef, undef ],
     'wm-lh-postcentral' => [ 'left', 'white', 'C0152302', 'Structure of postcentral gyrus' ],
     'wm-lh-posteriorcingulate' => [ 'left', 'white', undef, undef ],
     'wm-lh-precentral' => [ 'left', 'white', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'wm-lh-precuneus' => [ 'left', 'white', 'C0152306', 'Structure of precuneus' ],
     'wm-lh-rostralanteriorcingulate' => [ 'left', 'white', undef, undef ],
     'wm-lh-rostralmiddlefrontal' => [ 'left', 'white', undef, undef ],
     'wm-lh-superiorfrontal' => [ 'left', 'white', 'C0152296', 'Structure of superior frontal gyrus' ],
     'wm-lh-superiorparietal' => [ 'left', 'white', 'C0152303', 'Structure of superior parietal lobule' ],
     'wm-lh-superiortemporal' => [ 'left', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-lh-supramarginal' => [ 'left', 'white', 'C0228214', 'Structure of supramarginal gyrus' ],
     'wm-lh-frontalpole' => [ 'left', 'white', 'C0149546', 'Structure of frontal pole' ],
     'wm-lh-temporalpole' => [ 'left', 'white', undef, undef ],
     'wm-lh-transversetemporal' => [ 'left', 'white', undef, undef ],
     'wm-rh-unknown' => [ 'right', 'white', undef, undef ],
     'wm-rh-bankssts' => [ 'right', 'white', undef, undef ],
     'wm-rh-caudalanteriorcingulate' => [ 'right', 'white', undef, undef ],
     'wm-rh-caudalmiddlefrontal' => [ 'right', 'white', undef, undef ],
     'wm-rh-corpuscallosum' => [ 'right', 'white', 'C0010090', 'Corpus Callosum' ],
     'wm-rh-cuneus' => [ 'right', 'white', 'C0152307', 'Structure of cuneus' ],
     'wm-rh-entorhinal' => [ 'right', 'white', 'C0175196', 'Structure of entorhinal cortex' ],
     'wm-rh-fusiform' => [ 'right', 'white', 'C0152313', 'Fusiform gyrus' ],
     'wm-rh-inferiorparietal' => [ 'right', 'white', 'C0152304', 'Inferior parietal lobule structure (body structure)' ],
     'wm-rh-inferiortemporal' => [ 'right', 'white', undef, undef ],
     'wm-rh-isthmuscingulate' => [ 'right', 'white', undef, undef ],
     'wm-rh-lateraloccipital' => [ 'right', 'white', 'C0228228', 'lateral occipital gyrus (human only)' ],
     'wm-rh-lateralorbitofrontal' => [ 'right', 'white', undef, undef ],
     'wm-rh-lingual' => [ 'right', 'white', 'C0152308', 'Lingual gyrus' ],
     'wm-rh-medialorbitofrontal' => [ 'right', 'white', 'C0016733', 'frontal lobe' ],
     'wm-rh-middletemporal' => [ 'right', 'white', 'C0152310', 'Structure of middle temporal gyrus' ],
     'wm-rh-parahippocampal' => [ 'right', 'white', 'C0228249', 'Parahippocampal Gyrus' ],
     'wm-rh-paracentral' => [ 'right', 'white', 'C0228204', 'paracentral sulcus (human only)' ],
     'wm-rh-parsopercularis' => [ 'right', 'white', 'C0149547', 'Frontal operculum structure (body structure)' ],
     'wm-rh-parsorbitalis' => [ 'right', 'white', 'C0694580', 'orbital operculum' ],
     'wm-rh-parstriangularis' => [ 'right', 'white', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'wm-rh-pericalcarine' => [ 'right', 'white', undef, undef ],
     'wm-rh-postcentral' => [ 'right', 'white', 'C0152302', 'Structure of postcentral gyrus' ],
     'wm-rh-posteriorcingulate' => [ 'right', 'white', undef, undef ],
     'wm-rh-precentral' => [ 'right', 'white', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'wm-rh-precuneus' => [ 'right', 'white', 'C0152306', 'Structure of precuneus' ],
     'wm-rh-rostralanteriorcingulate' => [ 'right', 'white', undef, undef ],
     'wm-rh-rostralmiddlefrontal' => [ 'right', 'white', undef, undef ],
     'wm-rh-superiorfrontal' => [ 'right', 'white', 'C0152296', 'Structure of superior frontal gyrus' ],
     'wm-rh-superiorparietal' => [ 'right', 'white', 'C0152303', 'Structure of superior parietal lobule' ],
     'wm-rh-superiortemporal' => [ 'right', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-rh-supramarginal' => [ 'right', 'white', 'C0228214', 'Structure of supramarginal gyrus' ],
     'wm-rh-frontalpole' => [ 'right', 'white', 'C0149546', 'Structure of frontal pole' ],
     'wm-rh-temporalpole' => [ 'right', 'white', undef, undef ],
     'wm-rh-transversetemporal' => [ 'right', 'white', undef, undef ],
     'wm-lh-centrum-semiovale' => [ 'left', 'white', undef, undef ],
     'wm-rh-centrum-semiovale' => [ 'right', 'white', undef, undef ],
     'ctx-lh-Unknown' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-Corpus_callosum' => [ 'left', 'gray', 'C0010090', 'Corpus Callosum' ],
     'ctx-lh-G_and_S_Insula_ONLY_AVERAGE' => [ 'left', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-lh-G_cingulate-Isthmus' => [ 'left', 'gray', 'C0175192', 'isthmus of cingulate gyrus' ],
     'ctx-lh-G_cingulate-Main_part' => [ 'left', 'gray', 'C0018427', 'Structure of cingulate gyrus' ],
     'ctx-lh-G_cuneus' => [ 'left', 'gray', 'C0152307', 'Structure of cuneus' ],
     'ctx-lh-G_frontal_inf-Opercular_part' => [ 'left', 'gray', 'C0262296', 'opercular part of inferior frontal gyrus (human only)' ],
     'ctx-lh-G_frontal_inf-Orbital_part' => [ 'left', 'gray', 'C0262300', 'orbital part of inferior frontal gyrus (human only)' ],
     'ctx-lh-G_frontal_inf-Triangular_part' => [ 'left', 'gray', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'ctx-lh-G_frontal_middle' => [ 'left', 'gray', 'C0152297', 'Middle frontal gyrus structure (body structure)' ],
     'ctx-lh-G_frontal_superior' => [ 'left', 'gray', 'C0152296', 'Structure of superior frontal gyrus' ],
     'ctx-lh-G_frontomarginal' => [ 'left', 'gray', 'C0262268', 'Lateral orbital gyrus (body structure)' ],
     'ctx-lh-G_insular_long' => [ 'left', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-lh-G_insular_short' => [ 'left', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-lh-G_and_S_occipital_inferior' => [ 'left', 'gray', 'C1110643', 'Inferior occipital gyrus (Macaque only)' ],
     'ctx-lh-G_occipital_middle' => [ 'left', 'gray', 'C1110642', 'Occipital gyrus (Macaque only)' ],
     'ctx-lh-G_occipital_superior' => [ 'left', 'gray', 'C0228230', 'superior occipital gyrus (human only)' ],
     'ctx-lh-G_occipit-temp_lat-Or_fusiform' => [ 'left', 'gray', 'C0152313', 'Fusiform gyrus' ],
     'ctx-lh-G_occipit-temp_med-Lingual_part' => [ 'left', 'gray', 'C0152308', 'Lingual gyrus' ],
     'ctx-lh-G_occipit-temp_med-Parahippocampal_part' => [ 'left', 'gray', 'C0228249', 'Parahippocampal Gyrus' ],
     'ctx-lh-G_orbital' => [ 'left', 'gray', 'C0152301', 'Orbital gyrus (body structure)' ],
     'ctx-lh-G_paracentral' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-G_parietal_inferior-Angular_part' => [ 'left', 'gray', 'C0152305', 'Structure of angular gyrus' ],
     'ctx-lh-G_parietal_inferior-Supramarginal_part' => [ 'left', 'gray', 'C0228214', 'Structure of supramarginal gyrus' ],
     'ctx-lh-G_parietal_superior' => [ 'left', 'gray', 'C0152303', 'Structure of superior parietal lobule' ],
     'ctx-lh-G_postcentral' => [ 'left', 'gray', 'C0152302', 'Structure of postcentral gyrus' ],
     'ctx-lh-G_precentral' => [ 'left', 'gray', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'ctx-lh-G_precuneus' => [ 'left', 'gray', 'C0152306', 'Structure of precuneus' ],
     'ctx-lh-G_rectus' => [ 'left', 'gray', 'C0152300', 'Structure of gyrus rectus' ],
     'ctx-lh-G_subcallosal' => [ 'left', 'gray', 'C0228282', 'Parolfactory area structure (body structure)' ],
     'ctx-lh-G_subcentral' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-G_temporal_inferior' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-G_temporal_middle' => [ 'left', 'gray', 'C0152310', 'Structure of middle temporal gyrus' ],
     'ctx-lh-G_temp_sup-G_temp_transv_and_interm_S' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-G_temp_sup-Lateral_aspect' => [ 'left', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-lh-G_temp_sup-Planum_polare' => [ 'left', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-lh-G_temp_sup-Planum_tempolare' => [ 'left', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-lh-G_and_S_transverse_frontopolar' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-Lat_Fissure-ant_sgt-ramus_horizontal' => [ 'left', 'gray', 'C0262190', 'anterior horizontal limb of lateral sulcus (human only)' ],
     'ctx-lh-Lat_Fissure-ant_sgt-ramus_vertical' => [ 'left', 'gray', 'C0262186', 'anterior ascending limb of lateral sulcus (human only)' ],
     'ctx-lh-Lat_Fissure-post_sgt' => [ 'left', 'gray', 'C0228187', 'Structure of fissure of Sylvius' ],
     'ctx-lh-Medial_wall' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-Pole_occipital' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-Pole_temporal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_calcarine' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_central' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_central_insula' => [ 'left', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-lh-S_cingulate-Main_part_and_Intracingulate' => [ 'left', 'gray', 'C0228189', 'Structure of cingulate sulcus' ],
     'ctx-lh-S_cingulate-Marginalis_part' => [ 'left', 'gray', 'C0228189', 'Structure of cingulate sulcus' ],
     'ctx-lh-S_circular_insula_anterior' => [ 'left', 'gray', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'ctx-lh-S_circular_insula_inferior' => [ 'left', 'gray', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'ctx-lh-S_circular_insula_superior' => [ 'left', 'gray', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'ctx-lh-S_collateral_transverse_ant' => [ 'left', 'gray', 'C0228226', 'Structure of collateral sulcus' ],
     'ctx-lh-S_collateral_transverse_post' => [ 'left', 'gray', 'C0228226', 'Structure of collateral sulcus' ],
     'ctx-lh-S_frontal_inferior' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_frontal_middle' => [ 'left', 'gray', 'C0228199', 'middle frontal sulcus (human only)' ],
     'ctx-lh-S_frontal_superior' => [ 'left', 'gray', 'C0228198', 'superior frontal sulcus (human only)' ],
     'ctx-lh-S_frontomarginal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_intermedius_primus-Jensen' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_intraparietal-and_Parietal_transverse' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_occipital_anterior' => [ 'left', 'gray', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'ctx-lh-S_occipital_middle_and_Lunatus' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_occipital_superior_and_transversalis' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_occipito-temporal_lateral' => [ 'left', 'gray', 'C0228245', 'Occipitotemporal sulcus' ],
     'ctx-lh-S_occipito-temporal_medial_and_S_Lingual' => [ 'left', 'gray', 'C0228245', 'Occipitotemporal sulcus' ],
     'ctx-lh-S_orbital-H_shapped' => [ 'left', 'gray', 'C0228206', 'orbital sulcus (human only)' ],
     'ctx-lh-S_orbital_lateral' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_orbital_medial-Or_olfactory' => [ 'left', 'gray', 'C0228205', 'Structure of olfactory sulcus' ],
     'ctx-lh-S_paracentral' => [ 'left', 'gray', 'C0228204', 'paracentral sulcus (human only)' ],
     'ctx-lh-S_parieto_occipital' => [ 'left', 'gray', 'C0228191', 'Parietooccipital fissure (body structure)' ],
     'ctx-lh-S_pericallosal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_postcentral' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_precentral-Inferior-part' => [ 'left', 'gray', 'C0262257', 'inferior precentral sulcus (human only)' ],
     'ctx-lh-S_precentral-Superior-part' => [ 'left', 'gray', 'C0262338', 'superior precentral sulcus' ],
     'ctx-lh-S_subcentral_ant' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_subcentral_post' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_suborbital' => [ 'left', 'gray', 'C0694583', 'superior rostral sulcus (human only)' ],
     'ctx-lh-S_subparietal' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_supracingulate' => [ 'left', 'gray', undef, undef ],
     'ctx-lh-S_temporal_inferior' => [ 'left', 'gray', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'ctx-lh-S_temporal_superior' => [ 'left', 'gray', 'C0228237', 'Structure of superior temporal sulcus' ],
     'ctx-lh-S_temporal_transverse' => [ 'left', 'gray', 'C0228239', 'transverse temporal sulcus (human only)' ],
     'ctx-rh-Unknown' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-Corpus_callosum' => [ 'right', 'gray', 'C0010090', 'Corpus Callosum' ],
     'ctx-rh-G_and_S_Insula_ONLY_AVERAGE' => [ 'right', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-rh-G_cingulate-Isthmus' => [ 'right', 'gray', 'C0175192', 'isthmus of cingulate gyrus' ],
     'ctx-rh-G_cingulate-Main_part' => [ 'right', 'gray', 'C0018427', 'Structure of cingulate gyrus' ],
     'ctx-rh-G_cuneus' => [ 'right', 'gray', 'C0152307', 'Structure of cuneus' ],
     'ctx-rh-G_frontal_inf-Opercular_part' => [ 'right', 'gray', 'C0262296', 'opercular part of inferior frontal gyrus (human only)' ],
     'ctx-rh-G_frontal_inf-Orbital_part' => [ 'right', 'gray', 'C0262300', 'orbital part of inferior frontal gyrus (human only)' ],
     'ctx-rh-G_frontal_inf-Triangular_part' => [ 'right', 'gray', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'ctx-rh-G_frontal_middle' => [ 'right', 'gray', 'C0152297', 'Middle frontal gyrus structure (body structure)' ],
     'ctx-rh-G_frontal_superior' => [ 'right', 'gray', 'C0152296', 'Structure of superior frontal gyrus' ],
     'ctx-rh-G_frontomarginal' => [ 'right', 'gray', 'C0262268', 'Lateral orbital gyrus (body structure)' ],
     'ctx-rh-G_insular_long' => [ 'right', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-rh-G_insular_short' => [ 'right', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-rh-G_and_S_occipital_inferior' => [ 'right', 'gray', 'C1110643', 'Inferior occipital gyrus (Macaque only)' ],
     'ctx-rh-G_occipital_middle' => [ 'right', 'gray', 'C1110642', 'Occipital gyrus (Macaque only)' ],
     'ctx-rh-G_occipital_superior' => [ 'right', 'gray', 'C0228230', 'superior occipital gyrus (human only)' ],
     'ctx-rh-G_occipit-temp_lat-Or_fusiform' => [ 'right', 'gray', 'C0152313', 'Fusiform gyrus' ],
     'ctx-rh-G_occipit-temp_med-Lingual_part' => [ 'right', 'gray', 'C0152308', 'Lingual gyrus' ],
     'ctx-rh-G_occipit-temp_med-Parahippocampal_part' => [ 'right', 'gray', 'C0228249', 'Parahippocampal Gyrus' ],
     'ctx-rh-G_orbital' => [ 'right', 'gray', 'C0152301', 'Orbital gyrus (body structure)' ],
     'ctx-rh-G_paracentral' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-G_parietal_inferior-Angular_part' => [ 'right', 'gray', 'C0152305', 'Structure of angular gyrus' ],
     'ctx-rh-G_parietal_inferior-Supramarginal_part' => [ 'right', 'gray', 'C0228214', 'Structure of supramarginal gyrus' ],
     'ctx-rh-G_parietal_superior' => [ 'right', 'gray', 'C0152303', 'Structure of superior parietal lobule' ],
     'ctx-rh-G_postcentral' => [ 'right', 'gray', 'C0152302', 'Structure of postcentral gyrus' ],
     'ctx-rh-G_precentral' => [ 'right', 'gray', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'ctx-rh-G_precuneus' => [ 'right', 'gray', 'C0152306', 'Structure of precuneus' ],
     'ctx-rh-G_rectus' => [ 'right', 'gray', 'C0152300', 'Structure of gyrus rectus' ],
     'ctx-rh-G_subcallosal' => [ 'right', 'gray', 'C0228282', 'Parolfactory area structure (body structure)' ],
     'ctx-rh-G_subcentral' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-G_temporal_inferior' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-G_temporal_middle' => [ 'right', 'gray', 'C0152310', 'Structure of middle temporal gyrus' ],
     'ctx-rh-G_temp_sup-G_temp_transv_and_interm_S' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-G_temp_sup-Lateral_aspect' => [ 'right', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-rh-G_temp_sup-Planum_polare' => [ 'right', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-rh-G_temp_sup-Planum_tempolare' => [ 'right', 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'ctx-rh-G_and_S_transverse_frontopolar' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-Lat_Fissure-ant_sgt-ramus_horizontal' => [ 'right', 'gray', 'C0262190', 'anterior horizontal limb of lateral sulcus (human only)' ],
     'ctx-rh-Lat_Fissure-ant_sgt-ramus_vertical' => [ 'right', 'gray', 'C0262186', 'anterior ascending limb of lateral sulcus (human only)' ],
     'ctx-rh-Lat_Fissure-post_sgt' => [ 'right', 'gray', 'C0228187', 'Structure of fissure of Sylvius' ],
     'ctx-rh-Medial_wall' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-Pole_occipital' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-Pole_temporal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_calcarine' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_central' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_central_insula' => [ 'right', 'gray', 'C0021640', 'Insula of Reil' ],
     'ctx-rh-S_cingulate-Main_part_and_Intracingulate' => [ 'right', 'gray', 'C0228189', 'Structure of cingulate sulcus' ],
     'ctx-rh-S_cingulate-Marginalis_part' => [ 'right', 'gray', 'C0228189', 'Structure of cingulate sulcus' ],
     'ctx-rh-S_circular_insula_anterior' => [ 'right', 'gray', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'ctx-rh-S_circular_insula_inferior' => [ 'right', 'gray', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'ctx-rh-S_circular_insula_superior' => [ 'right', 'gray', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'ctx-rh-S_collateral_transverse_ant' => [ 'right', 'gray', 'C0228226', 'Structure of collateral sulcus' ],
     'ctx-rh-S_collateral_transverse_post' => [ 'right', 'gray', 'C0228226', 'Structure of collateral sulcus' ],
     'ctx-rh-S_frontal_inferior' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_frontal_middle' => [ 'right', 'gray', 'C0228199', 'middle frontal sulcus (human only)' ],
     'ctx-rh-S_frontal_superior' => [ 'right', 'gray', 'C0228198', 'superior frontal sulcus (human only)' ],
     'ctx-rh-S_frontomarginal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_intermedius_primus-Jensen' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_intraparietal-and_Parietal_transverse' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_occipital_anterior' => [ 'right', 'gray', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'ctx-rh-S_occipital_middle_and_Lunatus' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_occipital_superior_and_transversalis' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_occipito-temporal_lateral' => [ 'right', 'gray', 'C0228245', 'Occipitotemporal sulcus' ],
     'ctx-rh-S_occipito-temporal_medial_and_S_Lingual' => [ 'right', 'gray', 'C0228245', 'Occipitotemporal sulcus' ],
     'ctx-rh-S_orbital-H_shapped' => [ 'right', 'gray', 'C0228206', 'orbital sulcus (human only)' ],
     'ctx-rh-S_orbital_lateral' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_orbital_medial-Or_olfactory' => [ 'right', 'gray', 'C0228205', 'Structure of olfactory sulcus' ],
     'ctx-rh-S_paracentral' => [ 'right', 'gray', 'C0228204', 'paracentral sulcus (human only)' ],
     'ctx-rh-S_parieto_occipital' => [ 'right', 'gray', 'C0228191', 'Parietooccipital fissure (body structure)' ],
     'ctx-rh-S_pericallosal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_postcentral' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_precentral-Inferior-part' => [ 'right', 'gray', 'C0262257', 'inferior precentral sulcus (human only)' ],
     'ctx-rh-S_precentral-Superior-part' => [ 'right', 'gray', 'C0262338', 'superior precentral sulcus' ],
     'ctx-rh-S_subcentral_ant' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_subcentral_post' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_suborbital' => [ 'right', 'gray', 'C0694583', 'superior rostral sulcus (human only)' ],
     'ctx-rh-S_subparietal' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_supracingulate' => [ 'right', 'gray', undef, undef ],
     'ctx-rh-S_temporal_inferior' => [ 'right', 'gray', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'ctx-rh-S_temporal_superior' => [ 'right', 'gray', 'C0228237', 'Structure of superior temporal sulcus' ],
     'ctx-rh-S_temporal_transverse' => [ 'right', 'gray', 'C0228239', 'transverse temporal sulcus (human only)' ],
     'wm-lh-Unknown' => [ 'left', 'white', undef, undef ],
     'wm-lh-Corpus_callosum' => [ 'left', 'white', 'C0010090', 'Corpus Callosum' ],
     'wm-lh-G_and_S_Insula_ONLY_AVERAGE' => [ 'left', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-lh-G_cingulate-Isthmus' => [ 'left', 'white', 'C0175192', 'isthmus of cingulate gyrus' ],
     'wm-lh-G_cingulate-Main_part' => [ 'left', 'white', 'C0018427', 'Structure of cingulate gyrus' ],
     'wm-lh-G_cuneus' => [ 'left', 'white', 'C0152307', 'Structure of cuneus' ],
     'wm-lh-G_frontal_inf-Opercular_part' => [ 'left', 'white', 'C0262296', 'opercular part of inferior frontal gyrus (human only)' ],
     'wm-lh-G_frontal_inf-Orbital_part' => [ 'left', 'white', 'C0262300', 'orbital part of inferior frontal gyrus (human only)' ],
     'wm-lh-G_frontal_inf-Triangular_part' => [ 'left', 'white', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'wm-lh-G_frontal_middle' => [ 'left', 'white', 'C0152297', 'Middle frontal gyrus structure (body structure)' ],
     'wm-lh-G_frontal_superior' => [ 'left', 'white', 'C0152296', 'Structure of superior frontal gyrus' ],
     'wm-lh-G_frontomarginal' => [ 'left', 'white', 'C0262268', 'Lateral orbital gyrus (body structure)' ],
     'wm-lh-G_insular_long' => [ 'left', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-lh-G_insular_short' => [ 'left', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-lh-G_and_S_occipital_inferior' => [ 'left', 'white', 'C1110643', 'Inferior occipital gyrus (Macaque only)' ],
     'wm-lh-G_occipital_middle' => [ 'left', 'white', 'C1110642', 'Occipital gyrus (Macaque only)' ],
     'wm-lh-G_occipital_superior' => [ 'left', 'white', 'C0228230', 'superior occipital gyrus (human only)' ],
     'wm-lh-G_occipit-temp_lat-Or_fusiform' => [ 'left', 'white', 'C0152313', 'Fusiform gyrus' ],
     'wm-lh-G_occipit-temp_med-Lingual_part' => [ 'left', 'white', 'C0152308', 'Lingual gyrus' ],
     'wm-lh-G_occipit-temp_med-Parahippocampal_part' => [ 'left', 'white', 'C0228249', 'Parahippocampal Gyrus' ],
     'wm-lh-G_orbital' => [ 'left', 'white', 'C0152301', 'Orbital gyrus (body structure)' ],
     'wm-lh-G_paracentral' => [ 'left', 'white', undef, undef ],
     'wm-lh-G_parietal_inferior-Angular_part' => [ 'left', 'white', 'C0152305', 'Structure of angular gyrus' ],
     'wm-lh-G_parietal_inferior-Supramarginal_part' => [ 'left', 'white', 'C0228214', 'Structure of supramarginal gyrus' ],
     'wm-lh-G_parietal_superior' => [ 'left', 'white', 'C0152303', 'Structure of superior parietal lobule' ],
     'wm-lh-G_postcentral' => [ 'left', 'white', 'C0152302', 'Structure of postcentral gyrus' ],
     'wm-lh-G_precentral' => [ 'left', 'white', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'wm-lh-G_precuneus' => [ 'left', 'white', 'C0152306', 'Structure of precuneus' ],
     'wm-lh-G_rectus' => [ 'left', 'white', 'C0152300', 'Structure of gyrus rectus' ],
     'wm-lh-G_subcallosal' => [ 'left', 'white', 'C0228282', 'Parolfactory area structure (body structure)' ],
     'wm-lh-G_subcentral' => [ 'left', 'white', undef, undef ],
     'wm-lh-G_temporal_inferior' => [ 'left', 'white', undef, undef ],
     'wm-lh-G_temporal_middle' => [ 'left', 'white', 'C0152310', 'Structure of middle temporal gyrus' ],
     'wm-lh-G_temp_sup-G_temp_transv_and_interm_S' => [ 'left', 'white', undef, undef ],
     'wm-lh-G_temp_sup-Lateral_aspect' => [ 'left', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-lh-G_temp_sup-Planum_polare' => [ 'left', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-lh-G_temp_sup-Planum_tempolare' => [ 'left', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-lh-G_and_S_transverse_frontopolar' => [ 'left', 'white', undef, undef ],
     'wm-lh-Lat_Fissure-ant_sgt-ramus_horizontal' => [ 'left', 'white', 'C0262190', 'anterior horizontal limb of lateral sulcus (human only)' ],
     'wm-lh-Lat_Fissure-ant_sgt-ramus_vertical' => [ 'left', 'white', 'C0262186', 'anterior ascending limb of lateral sulcus (human only)' ],
     'wm-lh-Lat_Fissure-post_sgt' => [ 'left', 'white', 'C0228187', 'Structure of fissure of Sylvius' ],
     'wm-lh-Medial_wall' => [ 'left', 'white', undef, undef ],
     'wm-lh-Pole_occipital' => [ 'left', 'white', undef, undef ],
     'wm-lh-Pole_temporal' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_calcarine' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_central' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_central_insula' => [ 'left', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-lh-S_cingulate-Main_part_and_Intracingulate' => [ 'left', 'white', 'C0228189', 'Structure of cingulate sulcus' ],
     'wm-lh-S_cingulate-Marginalis_part' => [ 'left', 'white', 'C0228189', 'Structure of cingulate sulcus' ],
     'wm-lh-S_circular_insula_anterior' => [ 'left', 'white', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'wm-lh-S_circular_insula_inferior' => [ 'left', 'white', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'wm-lh-S_circular_insula_superior' => [ 'left', 'white', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'wm-lh-S_collateral_transverse_ant' => [ 'left', 'white', 'C0228226', 'Structure of collateral sulcus' ],
     'wm-lh-S_collateral_transverse_post' => [ 'left', 'white', 'C0228226', 'Structure of collateral sulcus' ],
     'wm-lh-S_frontal_inferior' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_frontal_middle' => [ 'left', 'white', 'C0228199', 'middle frontal sulcus (human only)' ],
     'wm-lh-S_frontal_superior' => [ 'left', 'white', 'C0228198', 'superior frontal sulcus (human only)' ],
     'wm-lh-S_frontomarginal' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_intermedius_primus-Jensen' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_intraparietal-and_Parietal_transverse' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_occipital_anterior' => [ 'left', 'white', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'wm-lh-S_occipital_middle_and_Lunatus' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_occipital_superior_and_transversalis' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_occipito-temporal_lateral' => [ 'left', 'white', 'C0228245', 'Occipitotemporal sulcus' ],
     'wm-lh-S_occipito-temporal_medial_and_S_Lingual' => [ 'left', 'white', 'C0228245', 'Occipitotemporal sulcus' ],
     'wm-lh-S_orbital-H_shapped' => [ 'left', 'white', 'C0228206', 'orbital sulcus (human only)' ],
     'wm-lh-S_orbital_lateral' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_orbital_medial-Or_olfactory' => [ 'left', 'white', 'C0228205', 'Structure of olfactory sulcus' ],
     'wm-lh-S_paracentral' => [ 'left', 'white', 'C0228204', 'paracentral sulcus (human only)' ],
     'wm-lh-S_parieto_occipital' => [ 'left', 'white', 'C0228191', 'Parietooccipital fissure (body structure)' ],
     'wm-lh-S_pericallosal' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_postcentral' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_precentral-Inferior-part' => [ 'left', 'white', 'C0262257', 'inferior precentral sulcus (human only)' ],
     'wm-lh-S_precentral-Superior-part' => [ 'left', 'white', 'C0262338', 'superior precentral sulcus' ],
     'wm-lh-S_subcentral_ant' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_subcentral_post' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_suborbital' => [ 'left', 'white', 'C0694583', 'superior rostral sulcus (human only)' ],
     'wm-lh-S_subparietal' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_supracingulate' => [ 'left', 'white', undef, undef ],
     'wm-lh-S_temporal_inferior' => [ 'left', 'white', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'wm-lh-S_temporal_superior' => [ 'left', 'white', 'C0228237', 'Structure of superior temporal sulcus' ],
     'wm-lh-S_temporal_transverse' => [ 'left', 'white', 'C0228239', 'transverse temporal sulcus (human only)' ],
     'wm-rh-Unknown' => [ 'right', 'white', undef, undef ],
     'wm-rh-Corpus_callosum' => [ 'right', 'white', 'C0010090', 'Corpus Callosum' ],
     'wm-rh-G_and_S_Insula_ONLY_AVERAGE' => [ 'right', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-rh-G_cingulate-Isthmus' => [ 'right', 'white', 'C0175192', 'isthmus of cingulate gyrus' ],
     'wm-rh-G_cingulate-Main_part' => [ 'right', 'white', 'C0018427', 'Structure of cingulate gyrus' ],
     'wm-rh-G_cuneus' => [ 'right', 'white', 'C0152307', 'Structure of cuneus' ],
     'wm-rh-G_frontal_inf-Opercular_part' => [ 'right', 'white', 'C0262296', 'opercular part of inferior frontal gyrus (human only)' ],
     'wm-rh-G_frontal_inf-Orbital_part' => [ 'right', 'white', 'C0262300', 'orbital part of inferior frontal gyrus (human only)' ],
     'wm-rh-G_frontal_inf-Triangular_part' => [ 'right', 'white', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'wm-rh-G_frontal_middle' => [ 'right', 'white', 'C0152297', 'Middle frontal gyrus structure (body structure)' ],
     'wm-rh-G_frontal_superior' => [ 'right', 'white', 'C0152296', 'Structure of superior frontal gyrus' ],
     'wm-rh-G_frontomarginal' => [ 'right', 'white', 'C0262268', 'Lateral orbital gyrus (body structure)' ],
     'wm-rh-G_insular_long' => [ 'right', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-rh-G_insular_short' => [ 'right', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-rh-G_and_S_occipital_inferior' => [ 'right', 'white', 'C1110643', 'Inferior occipital gyrus (Macaque only)' ],
     'wm-rh-G_occipital_middle' => [ 'right', 'white', 'C1110642', 'Occipital gyrus (Macaque only)' ],
     'wm-rh-G_occipital_superior' => [ 'right', 'white', 'C0228230', 'superior occipital gyrus (human only)' ],
     'wm-rh-G_occipit-temp_lat-Or_fusiform' => [ 'right', 'white', 'C0152313', 'Fusiform gyrus' ],
     'wm-rh-G_occipit-temp_med-Lingual_part' => [ 'right', 'white', 'C0152308', 'Lingual gyrus' ],
     'wm-rh-G_occipit-temp_med-Parahippocampal_part' => [ 'right', 'white', 'C0228249', 'Parahippocampal Gyrus' ],
     'wm-rh-G_orbital' => [ 'right', 'white', 'C0152301', 'Orbital gyrus (body structure)' ],
     'wm-rh-G_paracentral' => [ 'right', 'white', undef, undef ],
     'wm-rh-G_parietal_inferior-Angular_part' => [ 'right', 'white', 'C0152305', 'Structure of angular gyrus' ],
     'wm-rh-G_parietal_inferior-Supramarginal_part' => [ 'right', 'white', 'C0228214', 'Structure of supramarginal gyrus' ],
     'wm-rh-G_parietal_superior' => [ 'right', 'white', 'C0152303', 'Structure of superior parietal lobule' ],
     'wm-rh-G_postcentral' => [ 'right', 'white', 'C0152302', 'Structure of postcentral gyrus' ],
     'wm-rh-G_precentral' => [ 'right', 'white', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'wm-rh-G_precuneus' => [ 'right', 'white', 'C0152306', 'Structure of precuneus' ],
     'wm-rh-G_rectus' => [ 'right', 'white', 'C0152300', 'Structure of gyrus rectus' ],
     'wm-rh-G_subcallosal' => [ 'right', 'white', 'C0228282', 'Parolfactory area structure (body structure)' ],
     'wm-rh-G_subcentral' => [ 'right', 'white', undef, undef ],
     'wm-rh-G_temporal_inferior' => [ 'right', 'white', undef, undef ],
     'wm-rh-G_temporal_middle' => [ 'right', 'white', 'C0152310', 'Structure of middle temporal gyrus' ],
     'wm-rh-G_temp_sup-G_temp_transv_and_interm_S' => [ 'right', 'white', undef, undef ],
     'wm-rh-G_temp_sup-Lateral_aspect' => [ 'right', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-rh-G_temp_sup-Planum_polare' => [ 'right', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-rh-G_temp_sup-Planum_tempolare' => [ 'right', 'white', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'wm-rh-G_and_S_transverse_frontopolar' => [ 'right', 'white', undef, undef ],
     'wm-rh-Lat_Fissure-ant_sgt-ramus_horizontal' => [ 'right', 'white', 'C0262190', 'anterior horizontal limb of lateral sulcus (human only)' ],
     'wm-rh-Lat_Fissure-ant_sgt-ramus_vertical' => [ 'right', 'white', 'C0262186', 'anterior ascending limb of lateral sulcus (human only)' ],
     'wm-rh-Lat_Fissure-post_sgt' => [ 'right', 'white', 'C0228187', 'Structure of fissure of Sylvius' ],
     'wm-rh-Medial_wall' => [ 'right', 'white', undef, undef ],
     'wm-rh-Pole_occipital' => [ 'right', 'white', undef, undef ],
     'wm-rh-Pole_temporal' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_calcarine' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_central' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_central_insula' => [ 'right', 'white', 'C0021640', 'Insula of Reil' ],
     'wm-rh-S_cingulate-Main_part_and_Intracingulate' => [ 'right', 'white', 'C0228189', 'Structure of cingulate sulcus' ],
     'wm-rh-S_cingulate-Marginalis_part' => [ 'right', 'white', 'C0228189', 'Structure of cingulate sulcus' ],
     'wm-rh-S_circular_insula_anterior' => [ 'right', 'white', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'wm-rh-S_circular_insula_inferior' => [ 'right', 'white', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'wm-rh-S_circular_insula_superior' => [ 'right', 'white', 'C0228258', 'Structure of Reil\'s limiting sulcus' ],
     'wm-rh-S_collateral_transverse_ant' => [ 'right', 'white', 'C0228226', 'Structure of collateral sulcus' ],
     'wm-rh-S_collateral_transverse_post' => [ 'right', 'white', 'C0228226', 'Structure of collateral sulcus' ],
     'wm-rh-S_frontal_inferior' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_frontal_middle' => [ 'right', 'white', 'C0228199', 'middle frontal sulcus (human only)' ],
     'wm-rh-S_frontal_superior' => [ 'right', 'white', 'C0228198', 'superior frontal sulcus (human only)' ],
     'wm-rh-S_frontomarginal' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_intermedius_primus-Jensen' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_intraparietal-and_Parietal_transverse' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_occipital_anterior' => [ 'right', 'white', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'wm-rh-S_occipital_middle_and_Lunatus' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_occipital_superior_and_transversalis' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_occipito-temporal_lateral' => [ 'right', 'white', 'C0228245', 'Occipitotemporal sulcus' ],
     'wm-rh-S_occipito-temporal_medial_and_S_Lingual' => [ 'right', 'white', 'C0228245', 'Occipitotemporal sulcus' ],
     'wm-rh-S_orbital-H_shapped' => [ 'right', 'white', 'C0228206', 'orbital sulcus (human only)' ],
     'wm-rh-S_orbital_lateral' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_orbital_medial-Or_olfactory' => [ 'right', 'white', 'C0228205', 'Structure of olfactory sulcus' ],
     'wm-rh-S_paracentral' => [ 'right', 'white', 'C0228204', 'paracentral sulcus (human only)' ],
     'wm-rh-S_parieto_occipital' => [ 'right', 'white', 'C0228191', 'Parietooccipital fissure (body structure)' ],
     'wm-rh-S_pericallosal' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_postcentral' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_precentral-Inferior-part' => [ 'right', 'white', 'C0262257', 'inferior precentral sulcus (human only)' ],
     'wm-rh-S_precentral-Superior-part' => [ 'right', 'white', 'C0262338', 'superior precentral sulcus' ],
     'wm-rh-S_subcentral_ant' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_subcentral_post' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_suborbital' => [ 'right', 'white', 'C0694583', 'superior rostral sulcus (human only)' ],
     'wm-rh-S_subparietal' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_supracingulate' => [ 'right', 'white', undef, undef ],
     'wm-rh-S_temporal_inferior' => [ 'right', 'white', 'C0228242', 'inferior temporal sulcus (human only)' ],
     'wm-rh-S_temporal_superior' => [ 'right', 'white', 'C0228237', 'Structure of superior temporal sulcus' ],
     'wm-rh-S_temporal_transverse' => [ 'right', 'white', 'C0228239', 'transverse temporal sulcus (human only)' ],
     'caudalanteriorcingulate' => [ undef, 'gray', 'C0021640', 'Insula of Reil' ],
     'caudalmiddlefrontal' => [ undef, 'gray', undef, undef ],
     'corpuscallosum' => [ undef, 'gray', 'C0010090', 'Corpus Callosum' ],
     'cuneus' => [ undef, 'gray', 'C0152307', 'Structure of cuneus' ],
     'entorhinal' => [ undef, 'gray', 'C0175196', 'Structure of entorhinal cortex' ],
     'fusiform' => [ undef, 'gray', 'C0152313', 'Fusiform gyrus' ],
     'inferiorparietal' => [ undef, 'gray', 'C0152304', 'Inferior parietal lobule structure (body structure)' ],
     'inferiortemporal' => [ undef, 'gray', undef, undef ],
     'isthmuscingulate' => [ undef, 'gray', undef, undef ],
     'lateraloccipital' => [ undef, 'gray', 'C0228228', 'lateral occipital gyrus (human only)' ],
     'lateralorbitofrontal' => [ undef, 'gray', undef, undef ],
     'lingual' => [ undef, 'gray', 'C0152308', 'Lingual gyrus' ],
     'medialorbitofrontal' => [ undef, 'gray', 'C0016733', 'frontal lobe' ],
     'middletemporal' => [ undef, 'gray', 'C0152310', 'Structure of middle temporal gyrus' ],
     'parahippocampal' => [ undef, 'gray', 'C0228249', 'Parahippocampal Gyrus' ],
     'paracentral' => [ undef, 'gray', 'C0228204', 'paracentral sulcus (human only)' ],
     'parsopercularis' => [ undef, 'gray', 'C0149547', 'Frontal operculum structure (body structure)' ],
     'parsorbitalis' => [ undef, 'gray', 'C0694580', 'orbital operculum' ],
     'parstriangularis' => [ undef, 'gray', 'C0262350', 'triangular part of inferior frontal gyrus (human only)' ],
     'pericalcarine' => [ undef, 'gray', undef, undef ],
     'postcentral' => [ undef, 'gray', 'C0152302', 'Structure of postcentral gyrus' ],
     'posteriorcingulate' => [ undef, 'gray', undef, undef ],
     'precentral' => [ undef, 'gray', 'C0152299', 'Ascending frontal gyrus structure (body structure)' ],
     'precuneus' => [ undef, 'gray', 'C0152306', 'Structure of precuneus' ],
     'rostralanteriorcingulate' => [ undef, 'gray', undef, undef ],
     'rostralmiddlefrontal' => [ undef, 'gray', undef, undef ],
     'superiorfrontal' => [ undef, 'gray', 'C0152296', 'Structure of superior frontal gyrus' ],
     'superiorparietal' => [ undef, 'gray', 'C0152303', 'Structure of superior parietal lobule' ],
     'superiortemporal' => [ undef, 'gray', 'C0152309', 'Superior temporal gyrus structure (body structure)' ],
     'supramarginal' => [ undef, 'gray', 'C0228214', 'Structure of supramarginal gyrus' ],
     'frontalpole' => [ undef, 'gray', 'C0149546', 'Structure of frontal pole' ],
     'temporalpole' => [ undef, 'gray', undef, undef ],
     'transversetemporal' => [ undef, 'gray', undef, undef ],
    };
}


# $Log: not supported by cvs2svn $
