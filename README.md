# BWT-Aligner
Perl implementation of Burrows-Wheeler Transform and the Alignment process, which is the core algorithm for Bowtie2 and BWA.

This is the course project for Bioinformatics(BI3204 2015.03-2015.07) at [SUSTC](http://www.sustc.edu.cn/).

##Introduction to BWT and the alignment algorithms

##BWT-Aligner-in-Per: For Lambda_virus
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
##BWT-Aligner-in-Per: For Human genome
