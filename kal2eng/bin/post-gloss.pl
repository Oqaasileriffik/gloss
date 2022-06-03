#!/usr/bin/env perl
# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
BEGIN { $| = 1; }
use utf8;
use warnings;
use strict;

while (<STDIN>) {
   if (!/^\t"/) {
      print;
      next;
   }

	s~^\t(.+? NIQ Der/vn) (U Der/nv)~\t$2 $1~g; # U ved NIQ må flyttes før øvrige
#	s~^3Sg U Der/nv~3Sg "be"~g ;

   s~^\t(.+?) <tr-prefix> (<tr:[^>]+>.+?<tr-end>)~\t$2 $1~g; # Swap inline translation+tags and current baseform+tags
   s~<tr:([^>]+)>.+?<tr-end>~"$1"~g; # Turn inline translation into a baseform

#Simple ledflytninger sent i kaskaden. Kun for de overordnede POS
	s~3SgO~"him/her/it"~g; #simpel substitution af objektstag

	s~\sNIQ\s~ "..ing" ~g; #simpel substitution af NIQ

	s~^\t(.+?) (3SgPoss)~\t$2 $1~g; #possessorer forrest i strengen, men efter præpositioner
	s~3SgPoss~"his/her/its"~g;

	s~^\t(.+?) (QAR Der/nv)~\t$2 $1~g; #QAR
	s~QAR Der/nv~"have"~g;

	s~^\t(.+?) (TUQ Der/vn SSAQ Der/nn NNGUR Der/nv)~\t$2 $1~g; #TUQ=SSAQ=NNGUR
	s~TUQ Der/vn SSAQ Der/nn NNGUR Der/nv~"be about to"~g;

	s~^\t(.+?) (TUQ Der/vn)~\t$2 $1~g; #TUQ
	s~TUQ Der/vn~"one who/ that which"~g;

	s~^\t(.+?) (RIIR Der/vv)~\t$2 $1~g; #RIIR
	s~RIIR Der/vv~"be done with/ after"~g;

   s~^\t(.+?) (TUQ Der/vn N Lok Sg)~\t$2 $1~g; #Lok på verbalnomen
   s~TUQ Der/vn N Lok Sg~"in/on what"~g;

   s~^\t(.+?) (Sem/Geo Prop Lok Sg)~\t$2 $1~g; #Lok på Geo/Prop
   s~Sem/Geo Prop Lok Sg~"in"~g;

	s~^\t(.+?) (Lok)~\t$2 $1~g; #Lok
   s~Lok~"in"~g;

	s~^\t(.+?) (Trm)~\t$2 $1~g; #Trm
   s~Trm~"to"~g;

    s~^\t(.+?) (Abl)~\t$2 $1~g; #Abl
   s~Abl~"from"~g;


   s~^\t(.+?) (V (Ind|Par) 3Sg)~\t$2 $1~g; #Subjekt Sg og modus
   s~V (Ind|Par) 3Sg~3Sg~g;

   s~^\t(.+?) (V (Ind|Par) 3Pl)~\t$2 $1~g; #Subjekt Pl og modus
   s~V (Ind|Par) 3Pl~"they"~g;

	s~^\t(.+?) U Der/nv ~\t$1 "be" ~g; #simpel substitution af U


     s~^\t(.+?) (LU)~\t$2 $1~g; #LU flyttes allerforrest
   s~LU~"and"~g;


	s~ Der/.. ~ ~g; # Slet tilbageblevne sekundære tags1
	s~ Der/.. ~ ~g; # Slet tilbageblevne sekundære tags1 anden gennemløb
	s~ Gram/.. ~ ~g; # Slet tilbageblevne sekundære tags2
	s~ Hyb/... ~ ~g; # Slet tilbageblevne sekundære tags3
	s~ Sem/....? ~ ~g; # Slet tilbageblevne sekundære tags4
	s~ Orth/....? ~ ~g; # Slet tilbageblevne sekundære tags5
	s~ %ContHypotagme ~ ~g; # Slet tilbageblevne sekundære tags6


   s~ <tr> ~ ~g; # Remove translation marker
   s~ <tr-done> ~ ~g; # Remove translation marker
   s~  +~ ~g; # Clean up spaces

   if (/^\t[^"]/) {
      s/^\t/\t"_" /;
   }

   print;
}
