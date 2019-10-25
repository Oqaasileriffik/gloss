# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
package Shared;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw( trim explode_utf8 implode_utf8 file_get_contents file_put_contents find_newest_bin find_newest_etc find_newest_lex first_file random_bytes random_name sqlite_writer sqlite_reader sqlite_write_hash sqlite_read_hash handle_cmdline_opts pipe_ignore );

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

sub explode_utf8 {
   my ($line) = @_;
   while ($line =~ m@([^\x{00}-\x{7E}])@) {
      my $code = $1;
      my $ord = ord($1);
      $line =~ s/\Q$code\E/\\u{$ord}/g;
   }

   return $line;
}

sub implode_utf8 {
   my ($line) = @_;
   while ($line =~ m@\\u\{(\d+)\}@) {
      my $code = $1;
      my $chr = chr($1);
      $line =~ s/\\u\{$code\}/$chr/g;
   }
   return $line;
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

   return return_newest(\@files, \@paths);
}

sub find_newest_etc {
   my @files = @_;
   use FindBin qw($Bin);
   use File::HomeDir;
   my $home = File::HomeDir->my_home;

   return return_newest(\@files, \@paths);
}

sub find_newest_lex {
   my @files = @_;
   use FindBin qw($Bin);
   use File::HomeDir;
   my $home = File::HomeDir->my_home;

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

sub first_file {
   foreach my $f (@_) {
      if (-e $f && -s $f) {
         return $f;
      }
   }
   die("No such file!\n");
}

sub random_bytes {
   no utf8;
   use bytes;

   my ($n) = @_;
   open FILE, '<:raw :bytes', '/dev/urandom' or die "Could not open /dev/urandom: $!\n";
   my $data = '';
   read(FILE, $data, $n);
   close FILE;
   return $data;
}

sub random_name {
   no utf8;
   use bytes;

   my ($s) = @_;
   if (!$s) {
      $s = '';
   }
   $s .= random_bytes(16);

   use Digest::SHA qw(sha1_base64);
   my $hash = sha1_base64($s);
   $hash =~ s/[^a-zA-Z0-9]/x/g;
   return $hash;
}

sub sqlite_writer {
   use DBI;
   my ($f) = @_;
   my $dbh = DBI->connect('dbi:SQLite:dbname='.$f, '', '', { RaiseError => 1, sqlite_unicode => 1 });
   return $dbh;
}

sub sqlite_reader {
   use DBI;
   use DBD::SQLite::Constants qw/:file_open/;
   my ($f) = @_;
   my $dbh = DBI->connect('dbi:SQLite:dbname='.$f, '', '', {
      RaiseError => 1,
      sqlite_unicode => 1,
#      sqlite_open_flags => SQLITE_OPEN_READONLY,
   });
   return $dbh;
}

sub sqlite_write_hash {
   my ($file, $data) = @_;

   use File::Basename;
   my $dir = dirname($file);
   my $tmpnam = 'tmp-'.random_name($file).'.sqlite';

   my $dbh = sqlite_writer("${dir}/${tmpnam}");
   $dbh->begin_work();
   $dbh->do('CREATE TABLE data (h_key TEXT NOT NULL, h_value TEXT);');
   my $sth = $dbh->prepare('INSERT INTO data (h_key,h_value) VALUES (?, ?);');

   while (my ($k,$v) = each(%$data)) {
      $sth->execute($k,$v);
   }

   $dbh->do('CREATE UNIQUE INDEX data_key_unique ON data (h_key);');
   $dbh->commit();
   $dbh->disconnect();

   if (-e $file) {
      unlink($file);
   }
   rename("${dir}/${tmpnam}", $file);
}

sub sqlite_read_hash {
   use Tie::Hash::DBD;
   tie my %hash, 'Tie::Hash::DBD', sqlite_reader($_[0]), { 'tbl' => 'data' };
   return \%hash;
}

sub handle_cmdline_opts {
   my ($fname) = @_;

   use YAML::XS qw(LoadFile);
   my $cmds = LoadFile($fname);

   use Getopt::Long;
   Getopt::Long::Configure('bundling');
   Getopt::Long::Configure('no_ignore_case');
   my %opts = ();
   my @popts = ('help|h|?', 'trace|t', 'regtest', 'cmd', 'raw', 'xSEPx');
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
         $po =~ s/ (\S)/ -$1/g;
         $po =~ s/ -(\S\S)/ --$1/g;
         $po =~ s/ /, /g;
         print "\t--$po\n";
      }
      exit(0);
   }

   if (defined $opts{'regtest'}) {
      %opts = ( regtest => 1, 'raw' => defined $opts{'raw'}, $last_opt => 1, );
   }

   my @cmdline = ();
   foreach my $cmd (@$cmds) {
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

   my $cmdline = join(' | ', @cmdline);
   if (!$opts{'raw'}) {
      $cmdline =~ s@(BIN|ETC|LEX)/(\S+)@_find_newest_cb("$1", "$2")@eg;
   }
   if (defined $opts{'regtest'} || defined $opts{'cmd'} || defined $opts{'raw'}) {
      print $cmdline."\n";
      exit(0);
   }

   return (\%opts, $cmdline);
}

sub pipe_ignore {
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

   open my $pipe, "bash -c '$sh 2> >(egrep --line-buffered -v \"cleanup.*Tie.*Hash.*DBD.*during global destruction\")'|" or die $!;
   return $pipe;
}

1;
__END__
