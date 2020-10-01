#!/usr/bin/env perl
# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
BEGIN { $| = 1; }
use utf8;
use warnings;
use strict;

while (<STDIN>) {
   s~^\t(.+?) <tr-prefix> (<tr:[^>]+>.+?<tr-end>)~\t$2 $1~g; # Swap inline translation+tags and current baseform+tags
   s~<tr:([^>]+)>.+?<tr-end>~"$1"~g; # Turn inline translation into a baseform

   s~  +~ ~g; # Clean up spaces
   print;
}
