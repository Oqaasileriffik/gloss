# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
package Shared;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw( trim create file_get_contents file_put_contents find_newest_bin find_newest_etc find_newest_lex handle_cmdline_opts pipe_helper );

use warnings;
use warnings 'untie';
use utf8;
use strict;

BEGIN {
	$| = 1;
	binmode(STDIN, ':encoding(UTF-8)');
	binmode(STDOUT, ':encoding(UTF-8)');
}
use open qw( :encoding(UTF-8) :std );
use feature 'unicode_strings';

sub trim {
   my ($s) = @_;
   $s =~ s/^\s+//g;
   $s =~ s/\s+$//g;
   return $s;
}

sub create {
   my ($fname) = @_;
   open FILE, '>', $fname or die "Could not create ${fname}: $!\n";
   close FILE;
}

sub file_get_contents {
   my ($fname) = @_;
   local $/ = undef;
   open FILE, '<:encoding(UTF-8)', $fname or die "Could not open ${fname}: $!\n";
   my $data = <FILE>;
   close FILE;
   return $data;
}

sub file_put_contents {
   my ($fname,$data) = @_;
   open FILE, '>:encoding(UTF-8)', $fname or die "Could not open ${fname}: $!\n";
   print FILE $data;
   close FILE;
}

sub return_newest {
   use Cwd qw(realpath);

   my ($files, $paths) = @_;
   my $file;
   my $mtime;

   foreach my $f (@$files) {
      foreach my $p (@$paths) {
         my $np = $p;
         my $nf = "$np/$f";
         if (-s $nf) {
            if (defined $ENV{OVERRIDE_PATH} && $nf !~ m@\.\./@ && $nf =~ m@^\Q$ENV{OVERRIDE_PATH}\E@) {
               $file = $nf;
               $mtime = -M $nf;
               last;
            }
            if (!$file || -M $nf < $mtime) {
               if (defined $ENV{DEBUG_NEWER}) {
                  print STDERR "NEWER: $nf\n";
               }
               $file = $nf;
               $mtime = -M $nf;
            }
         }
         while ($np =~ m@/\.\./\.\./@) {
            $np =~ s@/\.\./\.\./@/../@;
            my $nf = "$np/$f";
            if (-s $nf) {
               if (defined $ENV{OVERRIDE_PATH} && $nf !~ m@\.\./@ && $nf =~ m@^\Q$ENV{OVERRIDE_PATH}\E@) {
                  $file = $nf;
                  $mtime = -M $nf;
                  last;
               }
               if (!$file || -M $nf < $mtime) {
                  if (defined $ENV{DEBUG_NEWER}) {
                     print STDERR "NEWER: $nf\n";
                  }
                  $file = $nf;
                  $mtime = -M $nf;
               }
            }
         }
      }
   }

   if (!$file) {
      die "Could not find @$files in @$paths!\n";
   }
   $file = realpath($file);

   if (defined $ENV{DEBUG_NEWEST}) {
      print STDERR "NEWEST: $file\n";
   }
   return $file;
}

sub find_newest_bin {
   my @files = @_;
   use FindBin qw($Bin);
   use File::HomeDir;
   my $home = File::HomeDir->my_home;
   my @paths = ('', $Bin, "$Bin/bin", "$Bin/../bin",
      "$Bin/../../shared/bin",
      "$Bin/../../kal2dan/bin",
      "$Bin/../../kal2eng/bin",
      "$home/langtech/kal/tools/shellscripts",
      '/usr/bin', '/usr/local/bin');

   return return_newest(\@files, \@paths);
}

sub find_newest_etc {
   my @files = @_;
   use FindBin qw($Bin);
   use File::HomeDir;
   my $home = File::HomeDir->my_home;
   my @paths = ('', $Bin, "$Bin/etc", "$Bin/../etc",
      "$Bin/../../shared/etc",
      "$Bin/../../kal2dan/etc",
      "$Bin/../../kal2eng/etc",
      "$home/langtech/kal/src/cg3",
      "$home/kal/src/cg3", '/usr/share/giella/kal',
      '/usr/local/share/giella/kal');

   return return_newest(\@files, \@paths);
}

sub find_newest_lex {
   my @files = @_;
   use FindBin qw($Bin);
   use File::HomeDir;
   my $home = File::HomeDir->my_home;
   my @paths = ('', $Bin, "$Bin/lex", "$Bin/../lex",
      "$Bin/../../shared/lex",
      "$Bin/../../kal2dan/lex",
      "$Bin/../../kal2eng/lex",
      "$home/langtech/kal/src",
      "$home/langtech/kal/tools/tokenisers",
      "$home/langtech/kal/tools/spellcheckers/3",
      '/usr/share/giella/kal', '/usr/share/voikko/3',
      '/usr/local/share/giella/kal', '/usr/local/share/voikko/3');

   return return_newest(\@files, \@paths);
}

sub _find_newest_cb {
   my ($dir, $file) = @_;
   if ($dir eq 'BIN') {
      return find_newest_bin($file);
   }
   elsif ($dir eq 'ETC') {
      return find_newest_etc($file);
   }
   return find_newest_lex($file);
}

sub handle_cmdline_opts {
   my ($fname) = @_;

   use YAML::XS qw(LoadFile);
   my $cmds = LoadFile($fname);

   use Getopt::Long;
   Getopt::Long::Configure('bundling');
   Getopt::Long::Configure('no_ignore_case');
   my %opts = ();
   my @popts = ('help|h|?', 'trace|t', 'from|f=s', 'regtest', 'cmd', 'raw', 'xSEPx');
   my $n = 0;
   my $last_opt = '';
   foreach my $cmd (@$cmds) {
      $last_opt = $cmd->{'_opt'} = 'auto-'.(++$n);
      if ($cmd->{'opt'}) {
         ($last_opt) = ($cmd->{'_opt'}) = ($cmd->{'opt'} =~ m/^([^|]+)/);
         push(@popts, $cmd->{'opt'});
      }
      if (! defined $cmd->{'test'}) {
         $cmd->{'test'} = '--trace | REGTEST_CG';
      }
   }
   GetOptions(\%opts, @popts);
   $opts{$last_opt} = 1;

   if (defined $opts{'help'}) {
      print "Possible options are:\n";
      foreach my $po (@popts) {
         if ($po eq 'xSEPx') {
            print "Pipe breakpoints:\n";
            next;
         }
         $po =~ s/[|]/ /g;
         $po =~ s/ (\w)/ -$1/g;
         $po =~ s/ -(\w\w)/ --$1/g;
         $po =~ s/ /, /g;
         $po =~ s/=s/ [breakpoint]/g;
         print "\t--$po\n";
      }
      exit(0);
   }

   if (defined $opts{'regtest'}) {
      %opts = ( regtest => 1, 'raw' => defined $opts{'raw'}, $last_opt => 1, );
   }

   if (defined $opts{'from'}) {
      my $good = 0;
      for my $cmd (@$cmds) {
         if ("|$cmd->{'opt'}|" =~ m@\|$opts{'from'}\|@) {
            $opts{'from'} = $cmd->{'_opt'};
            $good = 1;
            last;
         }
      }
      if (!$good) {
         die($opts{'from'}." is not a valid breakpoint to start from!\n");
      }
   }

   my @cmdline = ();
   foreach my $cmd (@$cmds) {
      if (defined $opts{'from'}) {
         if ($opts{'from'} ne $cmd->{'_opt'}) {
            next;
         }
         $opts{'_from'} = $opts{'from'};
         delete $opts{'from'};
      }
      push (@cmdline, $cmd->{'cmd'});
      if (defined $opts{'regtest'}) {
         $cmdline[-1] .= ' '.$cmd->{'test'}.' '.$cmd->{'_opt'};
      }
      if (defined $opts{$cmd->{'_opt'}}) {
         if (defined $opts{'trace'} && $cmd->{'trace'}) {
            $cmdline[-1] .= ' '.$cmd->{'trace'};
         }
         last;
      }
   }

   if (defined $opts{'_from'}) {
      $opts{'from'} = $opts{'_from'};
      delete $opts{'_from'};
   }

   my $cmdline = join(' | ', @cmdline);
   if (!$opts{'raw'}) {
      $cmdline =~ s@(BIN|ETC|LEX)/(\S+)@_find_newest_cb("$1", "$2")@eg;
      $cmdline =~ s@\bPID\b@$$@g;
   }
   if (defined $opts{'regtest'} || defined $opts{'cmd'} || defined $opts{'raw'}) {
      print $cmdline."\n";
      exit(0);
   }

   return (\%opts, $cmdline);
}

sub pipe_helper {
   my ($cmdline) = @_;

   use File::Spec;
   use Digest::SHA qw(sha1_base64);
   my $cmd = $cmdline;
   utf8::encode($cmd);
   my $hash = sha1_base64($cmd);
   $hash =~ s/[^a-zA-Z0-9]/x/g;
   my $sh = File::Spec->tmpdir()."/cmd-$hash";
   if (! -s $sh) {
      file_put_contents($sh, $cmdline);
      chmod(0755, $sh);
   }

   open my $pipe, "$sh|" or die $!;
   return $pipe;
}

1;
__END__
