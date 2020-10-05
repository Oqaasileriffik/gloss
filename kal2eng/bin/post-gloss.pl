#!/usr/bin/env perl
# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
BEGIN { $| = 1; }
use utf8;
use warnings;
use strict;

while (<STDIN>) {
   s~^\t(.+?) <tr-prefix> (<tr:[^>]+>.+?<tr-end>)~\t$2 $1~g; # Swap inline translation+tags and current baseform+tags
  s~<tr:([^>]+)>.+?<tr-end>~"$1"~g; # Turn inline translation into a baseform

#Simple ledflytninger sent i kaskaden. Kun for de overordnede POS
    s~^\t(.+?) (TUQ Der/vn N Lok Sg)~\t$2 $1~g; #Lok på verbalnomen
    s~TUQ Der/vn N Lok Sg~"in/on what"~g; 

    s~^\t(.+?) (V (Ind|Par) 3Sg)~\t$2 $1~g; #Subjekt og modus
    s~V (Ind|Par) 3Sg~"he/she/it"~g; 
    
   s~ <tr>+~ ~g; # Clean up spaces
   print;
}
