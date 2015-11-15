# BWT-Aligner
Perl implementation of Burrows-Wheeler Transform and the Alignment process, which is the core algorithm for Bowtie2 and BWA.

This is the course project for Bioinformatics(BI3204 2015.03-2015.07) at [SUSTC](http://www.sustc.edu.cn/).

##Introduction to BWT and the alignment algorithms

##BWT-Aligner-in-Per: For Lambda_virus
```bash
perl rotation.pl lambda_virus.fa lambda_rot
# Rotate the reference sequence and sort it.
# This will output two files: lambda_rot.sort and lambda_rot.sort.ref_name.bdx. And one temporary file called lambda_rot.out will be generated and then deleted.
```

##BWT-Aligner-in-Per: For Human genome
