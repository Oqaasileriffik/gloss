#!/usr/bin/env perl
# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
BEGIN { $| = 1; }
use utf8;
use warnings;
use strict;

while (<STDIN>) {
	s~^\t(.+? NIQ Der/vn) (U Der/nv)~\t$2 $1~g; # U ved NIQ må flyttes før øvrige
	s~^3Sg U Der/nv~3Sg "be"~g ;
   s~^\t(.+?) <tr-prefix> (<tr:[^>]+>.+?<tr-end>)~\t$2 $1~g; # Swap inline translation+tags and current baseform+tags
   s~<tr:([^>]+)>.+?<tr-end>~"$1"~g; # Turn inline translation into a baseform

#Simple ledflytninger sent i kaskaden. Kun for de overordnede POS
	s~3SgO~"him/her/it"~g; #simpel substitution af objektstag
	
	s~\sNIQ\s~ "..ing" ~g; #simpel substitution af NIQ

	
   s~^\t(.+?) (TUQ Der/vn N Lok Sg)~\t$2 $1~g; #Lok på verbalnomen
   s~TUQ Der/vn N Lok Sg~"in/on what"~g; 
   
   s~^\t(.+?) (Sem/Geo Prop Lok Sg)~\t$2 $1~g; #Lok på Geo/Prop
   s~Sem/Geo Prop Lok Sg~"in"~g; 
   
 s~^\t(.+?) (Trm)~\t$2 $1~g; #Trm
   s~Trm~"to"~g;  
   
    s~^\t(.+?) (Abl)~\t$2 $1~g; #Abl
   s~Abl~"from"~g;      
   
   s~^\t(.+?) (V (Ind|Par) 3Sg)~\t$2 $1~g; #Subjekt Sg og modus
   s~V (Ind|Par) 3Sg~3Sg~g; 

   s~^\t(.+?) (V (Ind|Par) 3Pl)~\t$2 $1~g; #Subjekt Pl og modus
   s~V (Ind|Par) 3Pl~"they"~g; 
   
   s~^\t(.+?) (3SgPoss)~\t$2 $1~g; #possessorer forrest i strengen
   s~3SgPoss~"his/her/its"~g; 


#   s~ <tr> ~ ~g; # Remove translation marker
   s~  +~ ~g; # Clean up spaces
   print;
}
