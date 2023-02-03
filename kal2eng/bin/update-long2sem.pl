#!/usr/bin/env perl
# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
use strict;
use warnings;
use utf8;

BEGIN { $| =1; }

use FindBin qw($Bin);
use lib ($Bin, "$Bin/../../shared/bin");
use Databases;
use Shared;

print "Downloading latest\n";
`curl -s 'https://tech.oqaasileriffik.gl/katersat/export-long2sem.php?lang=eng' | egrep -v ' (Abs|Ind|Ins)\t' | LC_ALL=C sort | uniq > $Bin/../lex/long2sem.tsv`;

if (-s "$Bin/../lex/long2sem.tsv" < 500000) {
   print "$Bin/../lex/long2sem.tsv too small - bailing out!\n";
   exit(-1);
}

print "Regenerating long2sem database\n";
Load_DB('long2sem', {generate => 1});
