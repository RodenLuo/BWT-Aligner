# BWT-Aligner
Perl implementation of Burrows-Wheeler Transform and the Alignment process, which is the core algorithm for Bowtie2 and BWA.

This is the course project for Bioinformatics(BI3204 2015.03-2015.07) at [SUSTC](http://www.sustc.edu.cn/).

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**

- [Introduction to BWT and the alignment algorithms](#introduction-to-bwt-and-the-alignment-algorithms)
- [BWT-Aligner-in-Perl: For Lambda_virus](#bwt-aligner-in-perl-for-lambda_virus)
  - [Usages](#usages)
  - [View results](#view-results)
- [BWT-Aligner-in-Perl: For Human genome](#bwt-aligner-in-perl-for-human-genome)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

##Introduction to BWT and the alignment algorithms
Use Bowtie2 as example:

![Bowtie2_1](https://github.com/RodenLuo/BWT-Aligner/blob/master/images/Bowtie2_1.jpg)

>Burrows-Wheeler transform. (a) The Burrows-Wheeler matrix and transformation for 'acaacg'. (b) Steps taken by EXACTMATCH to identify the range of rows, and thus the set of reference suffixes, prefixed by 'aac'. (c) UNPERMUTE repeatedly applies the last first (LF) mapping to recover the original text (in red on the top line) from the Burrows-Wheeler transform (in black in the rightmost column).

>Langmead et al. Genome Biology 2009 10:R25   doi:10.1186/gb-2009-10-3-r25

![Bowtie2_2](https://github.com/RodenLuo/BWT-Aligner/blob/master/images/Bowtie2_2.jpg)

>Exact matching versus inexact alignment. Illustration of how EXACTMATCH (top) and Bowtie's aligner (bottom) proceed when there is no exact match for query 'ggta' but there is a one-mismatch alignment when 'a' is replaced by 'g'. Boxed pairs of numbers denote ranges of matrix rows beginning with the suffix observed up to that point. A red X marks where the algorithm encounters an empty range and either aborts (as in EXACTMATCH) or backtracks (as in the inexact algorithm). A green check marks where the algorithm finds a nonempty range delimiting one or more occurrences of a reportable alignment for the query.

>Langmead et al. Genome Biology 2009 10:R25   doi:10.1186/gb-2009-10-3-r25

##BWT-Aligner-in-Perl: For Lambda_virus
#####Usages:
```bash
perl rotation.pl lambda_virus.fa lambda_rot
# Rotate the reference sequence and sort it.
# This will output two files: lambda_rot.sort and lambda_rot.sort.ref_name.bdx. One temporary file called lambda_rot.out will be generated and then deleted.
```
```bash
perl tally.pl lambda_rot.sort lambda.tally
# Build tally index for the rotated_sorted file.
# This will output two files: lambda.tally.bdx and lambda.tally. The files generated in the first step, lambda_rot.sort and lambda_rot.sort.ref_name.bdx, will be deleted in this step.
```
```bash
perl BWT-Aligner.pl lambda.tally reads_1.fq reads_1.sam
# Since the index is built, you can now align the raw reads onto the reference.
# This will output the alignment in SAM format, reads_1.sam.
```
#####View results
```bash
samtools sort -o reads_1.srt.bam -O bam -T temp reads_1.sam  # Convert it to sorted bam
 samtools index reads_1.srt.bam # Index it by samtools index
# View in IGV or other alignments viewer.
```
>File source specification:

>The reference file, lambda_virus.fa, and the reads file, reads_1.fq are originally from example files in [Bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml).
IGV_Figure

![IGV_Figure](https://github.com/RodenLuo/BWT-Aligner/blob/master/images/IGV_figure.png)

Zoom_in_1

![zoom_in](https://github.com/RodenLuo/BWT-Aligner/blob/master/images/Zoom_in_1.png)

Zoom_in_2

![zoom_in](https://github.com/RodenLuo/BWT-Aligner/blob/master/images/Zoom_in_2.png)
##BWT-Aligner-in-Perl: For Human genome
Building BWT index for huge genome like human is a little more complicated because of the sorting process. This perl implementation uses 140bp header to sort in lambda virus reference. For human genome 1000bp has been used to sort but there are still some identical sequences. So I have sorted it step by step. I will push this part after I clean up my code.
