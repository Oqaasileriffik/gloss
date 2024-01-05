#!/usr/bin/env perl
# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
BEGIN { $| = 1; }
use utf8;
use warnings;
use strict;

use FindBin qw($Bin);
use lib ("$Bin/bin", "$Bin/../shared/bin");
use Shared;

if ((($ENV{LANGUAGE} || "").($ENV{LANG} || "").($ENV{LC_ALL} || "")) !~ /UTF-?8/i) {
   die "Locale is not UTF-8 - bailing out!\n";
}
if ($ENV{PERL_UNICODE} !~ /S/ || $ENV{PERL_UNICODE} !~ /D/ || $ENV{PERL_UNICODE} !~ /A/) {
   die "Envvar PERL_UNICODE must contain S and D and A!\n";
}

if ($ENV{REGRESSION_TEST}) {
   $ENV{NUTSERUT_DEV} = 0;
}
if (!defined $ENV{NUTSERUT_DEV}) {
   $ENV{NUTSERUT_DEV} = 1;
}

create("/tmp/nutserut-readings.kal2eng.$$");

my ($opts, $cmdline) = handle_cmdline_opts("$Bin/public.yaml");

if (defined $ENV{DEBUG_CMD}) {
   print STDERR $cmdline."\n";
}
my $pipe = pipe_ignore($cmdline);
while (<$pipe>) {
	print;
}
close $pipe;
