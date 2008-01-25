#!/usr/bin/perl -w

# This script converts aseg.stats files from FreeSurfer
# into XCEDE 2.

use strict;

use File::Spec;

my $usage = <<EOM;
Usage:
  $0 aseg_stats_file
EOM

if (@ARGV != 1) {
  die "Not enough arguments!\n$usage"
}

my $ASEGfile = shift;

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
  );

my %metafields = ();
my @tablecols = ();
my %colname2num = ();
my @tabledata = ();
open(FH, '<', $ASEGfile) || die "Error opening $ASEGfile: $!\n";
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
my $colnum_segid = $colname2num{'SegId'};
for my $rowref (@tabledata) {
  my $segid = $rowref->[$colnum_segid];
  my $structname = $rowref->[$colnum_structname];
  $measurementgroups .= "    <measurementGroup>\n";
  $measurementgroups .= "      <entity xsi:type=\"anatomicalEntity_t\">\n";
  $measurementgroups .= "        <label nomenclature=\"FreeSurferColorLUT\" termID=\"$segid\">$structname</label>\n";
  $measurementgroups .= "        <!-- a second label referencing a UMLS ID could be inserted here -->\n";
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

print <<EOM;
<?xml version="1.0" encoding="UTF-8"?>
<XCEDE xmlns="http://www.xcede.org/xcede-2"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" >
  <analysis subjectID="$metafields{'subjectname'}">
$provenance
$measurementgroups
  </analysis>
</XCEDE>
EOM
