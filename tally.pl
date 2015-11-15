#!/usr/bin/perl
die "usage: perl tally.pl <ref_rotation.sort> <ref.tally>\n" unless @ARGV == 2;

$inputFile = $ARGV[0];
$bdx_ref_name = "$inputFile.ref_name.bdx";
$outputFile = $ARGV[1];
open Rot, $inputFile;
open Ref_name, $bdx_ref_name;
open Out, ">$outputFile";
open Bdx, ">$outputFile.bdx";
$ref_name = <Ref_name>;

$A = 0;
$C = 0;
$G = 0;
$T = 0;
$N = 0;

while($line=<Rot>){
  ($_,$_,$last,$posi) = split(/\t/,$line);
  chomp $posi;
  uc($last);
  if( $last eq 'A' ){
    $A++;
  }elsif( $last eq 'C' ){
    $C++;
  }elsif( $last eq 'G' ){
    $G++;
  }elsif( $last eq 'T' ){
    $T++;
  }elsif( $last eq 'N' ){
    $N++;
  }
  print Out "$last\t$posi\t$A\t$C\t$G\t$T\n";

}

print Bdx "$ref_name\nA\t$A\nC\t$C\nG\t$G\nT\t$T\nN\t$N\n";
system("rm $bdx_ref_name");
system("rm $inputFile");
