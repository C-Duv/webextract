#!/usr/bin/perl

open($fhLabels,$ARGV[0]);
open($fhFeatures,$ARGV[1]);

while(my $l = <$fhLabels>) {
  chomp($l);
  my $f = <$fhFeatures>;
  $f =~ s/^other/$l/;
  print $f;
}

close($fhLabels);
close($fhFeatures);