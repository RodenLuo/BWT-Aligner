#!/usr/bin/perl
#use diagnostics;
die "usage: perl BWT_Aligner.pl <ref.tally> <reads.fastq> <out.sam>\n" unless @ARGV == 3;

$ref_tally = $ARGV[0];
$ref_bdx = "$ref_tally.bdx";
$fq=$ARGV[1];
$out=$ARGV[2];

open Bdx,$ref_bdx;
$ref=<Bdx>;chomp $ref;
$ref_A_line = <Bdx>; chomp $ref_A_line; ($_,$A_no)=split(/\t/,$ref_A_line);
$ref_C_line = <Bdx>; chomp $ref_C_line; ($_,$C_no)=split(/\t/,$ref_C_line);
$ref_G_line = <Bdx>; chomp $ref_G_line; ($_,$G_no)=split(/\t/,$ref_G_line);
$ref_T_line = <Bdx>; chomp $ref_T_line; ($_,$T_no)=split(/\t/,$ref_T_line);
$ref_N_line = <Bdx>; chomp $ref_N_line; ($_,$N_no)=split(/\t/,$ref_N_line);

  open Tally, $ref_tally;
  @tally = <Tally>;
  $A=$A_no;
  $C=$C_no;
  $G=$G_no;
  $N=$N_no;
  $T=$T_no;
  $ref_len = $A+$C+$G+$N+$T;

=cut
print "$A\n";
print "$C\n";
print "$G\n";
print "$T\n";
print "$N\n";
=cut
  
  $A1=1;
  $A2=$A;
  $C1=$A+1;
  $C2=$A+$C;
  $G1=$C2+1;
  $G2=$G1+$G-1;
  $T1=$G2+$N+1;
  $T2=$T1+$T-1;


open FQ, $fq;
open OUT, ">$out";
print OUT "\@HD\tVN:1.0\tSO:unsorted\n\@SQ\tSN:$ref\tLN:$ref_len\t\n\@PG\tID:myBWT_Aligner\tPN:myBWT_Aligner\tVN:1.0\n";

while ($at = <FQ> and $at =~ /^@/){
  $read = <FQ>;
  $plus = <FQ>;
  $quality = <FQ>;
  chomp $at;chomp $read;chomp $plus;chomp $quality;
  #@posi = `perl map.pl $read`;

#  if ($read =~ /N/){next;}
  @posi = alignment($read,$quality);
  $at = substr($at,1,length($at)-1);
  chomp @posi;
  foreach $posi(@posi){
    $len = length($read);
    if($posi != 0){print OUT "$at\t0\t$ref\t$posi\t42\t${len}M\t*\t0\t0\t$read\t$quality\n";}
  }
}


sub alignment{

  ($seq,$qua) = @_;
  @results = ();
  
  
  $count=1;
  $seqlen=length($seq);
  uc($seq);
  $base=substr($seq,$seqlen-$count,1);
  $check1 = ${$base."1"};
  $check2 = ${$base."2"};
  ###
  #print "base$base lines: $check1,$check2\n";
  
  ($lastbase1,$posi,$AF,$CF,$GF,$TF)=split(/\t/,$tally[${$base."1"}]); chomp $TF;
  ($_,$posi,$AL,$CL,$GL,$TL)=split(/\t/,$tally[${$base."2"}]); chomp $TL;
  $base=substr($seq,$seq-$count-1,1);
  ($fline,$lline) = findline($lastbase1,$base,${$base."F"},${$base."L"});
  ###
  #print "base$base lines: $fline,$lline";
  
  $count++;
  
  while($count<$seqlen){
    $base=substr($seq,$seqlen-$count-1,1);
    ($lastbase1,$posi,$AF,$CF,$GF,$TF)=split(/\t/,$tally[$fline]); chomp $TF;
  #  print "$fline";
  ###
    #print "\tlastbase:$lastbase1";
  
    if($fline < $lline){
      ($_,$posi,$AL,$CL,$GL,$TL)=split(/\t/,$tally[$lline]); chomp $TL;
      ($fline,$lline) = findline($lastbase1,$base,${$base."F"},${$base."L"});
      $count++;
  ###
      #print "\nbase$base lines: ";
      #print "$fline,$lline";
  
    }else{
      if($base =~ /$lastbase1/){
        $fline = findone($base,${$base."F"});
        $lline = $fline;
        $count++;
       ###
        #print "\t*\nbase$base lines: $fline,$lline";
  
      }else{
        $fline = 0;
        $lline = 0;
  ###
        #print "\n#$fline,$lline\ncount: $count\n";
  
        last;
      }
    }
  }
  
  if($fline != 0){
    $all = $lline-$fline+1;
    while($fline<=$lline){
      ($_,$posi,$_,$_,$_,$_)=split(/\t/,$tally[$fline]);
      $posi++;
      push @results, $posi;
      $fline++;
    }
    #print "\nAll: $all\n";
  }else{
 
    @quality = split(//,$qua);
    $start_check_point = $seqlen - $count - 1;
    $check_point = $start_check_point;
    #for $point ($start_check_point .. $seqlen-1){
    #  if ($quality[$point] lt $quality[$check_point]){ $check_point = $point;}
    #}
  ###
  #  print "0\tstart:$start_check_point\tcheckP:$check_point\tquality:$quality[$check_point]\n";
  
    $header = substr($seq,0,$check_point);
    $tail = substr($seq,$check_point+1,$seqlen-$check_point-1);
    $mut = substr($seq,$check_point,1);
  
    if ($mut eq "A"){
      $seq1 = $header."C".$tail;
      $seq2 = $header."G".$tail;
      $seq3 = $header."T".$tail;
    }
    elsif ($mut eq "C"){
      $seq1 = $header."A".$tail;
      $seq2 = $header."G".$tail;
      $seq3 = $header."T".$tail;
    }
    elsif ($mut eq "G"){
      $seq1 = $header."A".$tail;
      $seq2 = $header."C".$tail;
      $seq3 = $header."T".$tail;
    }
    elsif ($mut eq "T"){
      $seq1 = $header."A".$tail;
      $seq2 = $header."C".$tail;
      $seq3 = $header."G".$tail;
    }
    elsif ($mut eq "N"){
      $seq1 = $header."A".$tail;
      $seq2 = $header."C".$tail;
      $seq3 = $header."G".$tail;
      $seq4 = $header."T".$tail;
      @result4 = alignOne($seq4);
      push @results, @result4;
    }
  
    @result1 = alignOne($seq1);
    @result2 = alignOne($seq2);
    @result3 = alignOne($seq3);
    
    push @results, @result1;
    push @results, @result2;
    push @results, @result3;

  }
  
  return @results;
}

sub alignOne{
  ($seq) = @_;
  $count=1;
  $seqlen=length($seq);
  uc($seq);
  $base=substr($seq,$seqlen-$count,1);
  ($lastbase1,$posi,$AF,$CF,$GF,$TF)=split(/\t/,$tally[${$base."1"}]); chomp $TF;
  ($_,$posi,$AL,$CL,$GL,$TL)=split(/\t/,$tally[${$base."2"}]); chomp $TL;
  $base=substr($seq,$seq-$count-1,1);
  ($fline,$lline) = findline($lastbase1,$base,${$base."F"},${$base."L"});
  #print "base$base lines: $fline,$lline";
  $count++;

  while($count<$seqlen){
    $base=substr($seq,$seqlen-$count-1,1);
    ($lastbase1,$posi,$AF,$CF,$GF,$TF)=split(/\t/,$tally[$fline]); chomp $TF;
  #  print "$fline";
    #print "\tlastbase:$lastbase1";

    if($fline < $lline){
      ($_,$posi,$AL,$CL,$GL,$TL)=split(/\t/,$tally[$lline]); chomp $TL;
      ($fline,$lline) = findline($lastbase1,$base,${$base."F"},${$base."L"});
      $count++;
      #print "\nbase$base lines: ";
      #print "$fline,$lline";
    }else{
      if($base =~ /$lastbase1/){
        $fline = findone($base,${$base."F"});
        $lline = $fline;
        $count++;
        #print "\t*\nbase$base lines:$fline,$lline";
      }else{
        $fline = 0;
        $lline = 0;
        #print "\n#$fline,$lline\n";
        last;
      }
    }
  }

  @subresults = ();
  if($fline != 0){
    $all = $lline-$fline+1;
    while($fline<=$lline){
      ($_,$posi,$_,$_,$_,$_)=split(/\t/,$tally[$fline]);
      $posi++;
      push @subresults, $posi;
      $fline++;
    }
    #print "\nAll: $all\n";
  }else{
    push @subresults, ('0');
  }
  return @subresults;
}


sub findone{
  ($c, $F) = @_;
  if ($c =~ /A/){
    $fline=$F;
  }elsif($c =~ /C/){
    $fline=$A+$F;
  }elsif($c =~ /G/){
    $fline=$A+$C+$F;
  }elsif($c =~ /T/){
    $fline=$A+$C+$G+$N+$F;
  }
  return $fline;
}
sub findline{

    ($lastbase1, $c, $F, $L) = @_;
    if ($lastbase1 =~ /$c/){$F--;}

  if ($F != $L){
    if ($c =~ /A/){
      $fline=$F+1;
      $lline=$L;
    }elsif($c =~ /C/){
      $fline=$A2+$F+1;
      $lline=$A2+$L;
    }elsif($c =~ /G/){
      $fline=$C2+$F+1;
      $lline=$C2+$L;
    }elsif($c =~ /T/){
      $fline=$G2+$N+$F+1;
      $lline=$G2+$N+$L;
    }
    return ($fline,$lline);
  } else{
    return (0,0);
  }
}


