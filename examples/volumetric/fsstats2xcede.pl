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
my $analysistype = "FreeSurfer ${anatomytype} $STATSfilename";
if ($STATSfilename eq 'aseg.stats') {
  $nomenclature = 'FreeSurferColorLUT';
} elsif ($STATSfilename eq 'wmparc.stats') {
  $nomenclature = 'FreeSurferColorLUT';
} elsif ($STATSfilename eq 'lh.aparc.stats') {
  $nomenclature = 'lh.aparc.annot';
  $fileHemi = 'left';
} elsif ($STATSfilename eq 'rh.aparc.stats') {
  $nomenclature = 'rh.aparc.annot';
  $fileHemi = 'right';
} elsif ($STATSfilename eq 'lh.aparc.a2005s.stats') {
  $nomenclature = 'lh.aparc.a2005s.annot';
  $fileHemi = 'left';
} elsif ($STATSfilename eq 'rh.aparc.a2005s.stats') {
  $nomenclature = 'rh.aparc.a2005s.annot';
  $fileHemi = 'right';
}

my $subject = <<EOM;
EOM

my $timestamp = '';
if (exists $metafields{'CreationTime'}) {
  my $timestr = $metafields{'CreationTime'};
  if ($timestr =~ m%^(\d\d\d\d)/(\d\d)/(\d\d)-(\d\d?):(\d\d):(\d\d)-(...)$%) {
    my ($year, $mon, $day, $hour, $min, $sec, $tz) =
      ($1, $2, $3 ,$4, $5, $6, $7);
    $timestr = "${year}-${mon}-${day}T${hour}:${min}:${sec}";
    if ($tz eq 'GMT') {
      $timestr .= 'Z';
    }
    $timestamp = "\n        <timeStamp>$timestr</timeStamp>";
  }
}
my $provenance = <<EOM;
    <provenance>
      <processStep>
        <program>$metafields{'generating_program'}</program>
        <programArguments>$metafields{'cmdline'}</programArguments>$timestamp
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
  my $segid = undef;
  if (defined($colnum_segid)) {
    $segid = $rowref->[$colnum_segid];
  } else {
    $segid = $structname;
  }

  my $laterality = undef;
  my $laterality_attr = '';
  if (defined($fileHemi)) {
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
  if ($structname =~ /^ctx-/) {
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
    if ($colheader eq 'GrayVol') {
      # fix a bug in FreeSurfer labeling (may be labeled as mm
      $units = 'mm^3';
    }
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
  $hierID .= (length($hierID) ? ' ' : '') . "studyID=\"${studyid}\"";
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


# $Log: not supported by cvs2svn $
# Revision 1.4  2008/03/11 18:28:26  gadde
# Fix studyID bug and fix FreeSurfer's units for GrayVol.
#
# Revision 1.3  2008/02/25 21:13:01  gadde
# Use more consistent analysistype
#
# Revision 1.2  2008/02/12 21:33:23  gadde
# Remove UMLS mappings until we get a BIRNLex list.
#
# Revision 1.1  2008/02/12 21:30:38  gadde
# Initial import.
#
