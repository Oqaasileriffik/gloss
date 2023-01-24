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

my $l2s = Load_DB('long2sem');

while (<STDIN>) {
   if (!/^\t"/ || !/ (?:N|V|Num|Adv|Interj|Pron|Prop)(?: |$)/) {
      print;
      next;
   }

   chomp;
   s@^\t+@@g;
   my $orig = $_;

   s@ (N|V|Num|Adv|Interj|Pron|Prop)( .*)$@ $1@;

   # Strip secondary tags except transitivity and semantics
   s@ Gram/([HIT]V) @ gram/$1 @g;
   s@ (Gram|Dial|Orth|O[lL]ang|Heur)/(\S+)@@g;
   s@ gram/@ Gram/@g;

   my $did = 0;
   while (42) {
      #print "DEBUG: $_\n";

      if (exists $l2s->{$_}) {
         my $p = "($_";
         $p =~ s@ @(?: |(?:(?:Gram|Dial|Orth|O[lL]ang|Heur|Der)/\\S+))* @g;

         if ($p =~ / (N|V|Adv|Interj|Pron|Prop)$/) {
            $p =~ s@ N$@)( (?:\\p{Lu}+ Der/nv|\\p{Lu}+ Der/nn|N))@;
            $p =~ s@ V$@)( (?:\\p{Lu}+ Der/vn|\\p{Lu}+ Der/vv|V))@;
            $p =~ s@ Prop$@)( (?:\\p{Lu}+ Der/nv|\\p{Lu}+ Der/nn|Prop|iProp))@;
            $p =~ s@ Adv$@)( (?:Adv|iAdv))@;
            $p =~ s@ Pron$@)( (?:Pron|iPron))@;
            $p =~ s@ Interj$@)( (?:Interj|iInterj))@;
         }
         else {
            $p = "$p)(.*)";
         }
         #print "DEBUG: $p\n";

         my $s = $l2s->{$_};
         $s =~ s@(^| |;)@$1Sem/@g;
         my @ss = split /;/, $s;
         for my $s (@ss) {
            my $o = $orig;
            #print "DEBUG: $s\n";
            #print "DEBUG: $o\n";
            #print "DEBUG: $p\n";
            $o =~ s@^$p@$1 $s$2@;
            # Mark prior semantics as internal
            while ($o =~ s@ (Sem/\S+.*? \p{Lu}+ (?:.*? |)Sem/\S+)@ i$1@g) {}
            # Mark semantics before derivation as internal
            while ($o =~ s@ (Sem/\S+.*? \p{Lu}+ .*? (?:N|V|Num|Adv|Interj|Pron|Prop)(?: |$))@ i$1@g) {}
            print "\t$o\n";
            $did = 1;
         }
         last;
      }

      if (!($_ =~ s@^(.+?) \p{Lu}+ Der/([vn])[vn](?: Gram/[HIT]V)? (?:N|V|Prop|Num|Adv|Interj|Pron)$@$1 \U$2@)) {
         last;
      }
   }

   if (!$did) {
      print "\t$orig\n";
   }
}
