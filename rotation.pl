#!/usr/bin/perl
die "usage: perl rotation.pl <ref.fa> <ref_rotation>\n" unless @ARGV == 2;

$headlen = 140;

$seq=$ARGV[0];
$out="$ARGV[1].out";
$sort = "$ARGV[1].sort";
$bdx_ref_name = "$ARGV[1].sort.ref_name.bdx";

open Seq, $seq;
open Out, '>'.$out;
open Bdx, '>'.$bdx_ref_name;

$header_line = <Seq>; # get header
($_,$header) = split(/>/, $header_line);
($ref_name,$_) = split(/ /, $header);
print Bdx $ref_name;

$line1 = <Seq>;chomp $line1;  $linelen = length($line1);
$line2 = <Seq>;chomp $line2;
$line3 = <Seq>;chomp $line3;
$line = $line1.$line2.$line3;

$len=length($line);
#print $len."\n";

$count=0;
$posi = 0;
print Out substr($line,$count,$headlen)."\t".substr($line,0,1)."\t\$\t$posi\n";
$count=1;
$posi = 1;
while($count <= $len - $headlen){
  print Out substr($line,$count,$headlen)."\t".substr($line,$count,1)."\t".substr($line,$count-1,1)."\t$posi\n";
  $count++;
  $posi++;
}

while($nextline=<Seq>){
  chomp $nextline;
  $line1=$line2;
  $line2=$line3;
  $line3=$nextline;
  $line=$line1.$line2.$line3;
  $count-=$linelen;

  while($count <= $len - $headlen){
    print Out substr($line,$count,$headlen)."\t".substr($line,$count,1)."\t".substr($line,$count-1,1)."\t$posi\n";
    $count++;
    $posi++;
  }
}
$lastlinelen=length($line);
while($count < $lastlinelen){
  print Out substr($line,$count,$len-$count)."\t".substr($line,$count,1)."\t".substr($line,$count-1,1)."\t$posi\n";
  $count++;
  $posi++;
}
print Out "\$\t\$\t".substr($line,$count-1,1)."\t$posi\n";

system("LC_COLLATE=C sort -k 1 $out > $sort");
system("rm $ARGV[1].out");
