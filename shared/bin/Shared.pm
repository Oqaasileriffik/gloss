# -*- mode: cperl; indent-tabs-mode: nil; tab-width: 3; cperl-indent-level: 3; -*-
package Shared;
require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw( explode_utf8 implode_utf8 find_newest_bin find_newest_etc find_newest_lex first_file sqlite_reader sqlite_write_hash sqlite_read_hash );

use warnings;
use utf8;
use strict;

BEGIN {
	$| = 1;
	binmode(STDIN, ':encoding(UTF-8)');
	binmode(STDOUT, ':encoding(UTF-8)');
}
use open qw( :encoding(UTF-8) :std );
use feature 'unicode_strings';

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

sub return_newest {
   use Cwd qw(realpath);

   my ($files, $paths) = @_;
   my $file;
   my $mtime;

   foreach my $f (@$files) {
      foreach my $p (@$paths) {
         my $nf = "$p/$f";
         if (-s $nf) {
            if (!$file || -M $nf < $mtime) {
               if (defined $ENV{DEBUG_NEWEST}) {
                  print STDERR "NEWER: $nf\n";
               }
               $file = $nf;
               $mtime = -M $nf;
            }
         }
         while ($p =~ m@/\.\./\.\./@) {
            $p =~ s@/\.\./\.\./@/../@;
            my $nf = "$p/$f";
            if (-s $nf) {
               if (!$file || -M $nf < $mtime) {
                  if (defined $ENV{DEBUG_NEWEST}) {
                     print STDERR "NEWER: $nf\n";
                  }
                  $file = $nf;
                  $mtime = -M $nf;
               }
            }
         }
      }
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

sub first_file {
   foreach my $f (@_) {
      if (-e $f && -s $f) {
         return $f;
      }
   }
   die("No such file!\n");
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
   if (-s $file) {
      unlink($file);
   }

   my $dbh = sqlite_writer($file);
   $dbh->begin_work();
   $dbh->do('CREATE TABLE data (h_key TEXT NOT NULL, h_value TEXT);');
   my $sth = $dbh->prepare('INSERT INTO data (h_key,h_value) VALUES (?, ?);');

   while (my ($k,$v) = each(%$data)) {
      $sth->execute($k,$v);
   }

   $dbh->do('CREATE UNIQUE INDEX data_key_unique ON data (h_key);');
   $dbh->commit();
   $dbh->disconnect();
}

sub sqlite_read_hash {
   use Tie::Hash::DBD;
   tie my %hash, 'Tie::Hash::DBD', sqlite_reader($_[0]), { 'tbl' => 'data' };
   return \%hash;
}

1;
__END__
