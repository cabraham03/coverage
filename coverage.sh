#!/bin/sh

# Author: Abraham Guerrero 
# Email:  aguerrero@ciad.mx and cabraham03@gmail.com
# Version 0.1

# Script to calculate the genome coverage from paired-end fastq files 
# the script works with:
#                       Samtools (Version: 1.2)                     http://www.htslib.org/download
#                       BWA (bwa-0.7.12) Burrows-Wheeler Aligner    http://bio-bwa.sourceforge.net

#analyze the results with: 
#                       BAMStats (BAMStats-1.25)                    http://bamstats.sourceforge.net
#                               or
#                       Qualimap  (qualimap_v2.2)                   http://qualimap.bioinfo.cipf.es


# example
# coverage Reference.fasta File_R1.fastq File_R2.fastq Results

reference=$1
fastqR1=$2
fastqR2=$3
output=$4

echo "\n----------------------------------------------"
echo "         Reference Genome Index"
echo "----------------------------------------------\n"

bwa index -a bwtsw $reference

echo "\n----------------------------------------------"
echo "                Alignment"
echo "----------------------------------------------\n"

bwa aln $reference $fastqR1 > $output.R1.sai
bwa aln $reference $fastqR2 > $output.R2.sai
bwa sampe $reference $output.R1.sai $output.R2.sai $fastqR1 $fastqR2 > $output.sam

echo "\n----------------------------------------------"
echo "                 BAM Files"
echo "----------------------------------------------\n"

samtools faidx $reference
samtools import $reference.fai $output.sam $output.bam
samtools sort $output.bam $output.sorted
samtools index $output.sorted.bam

echo "\n----------------------------------------------"
echo "        Open the $output.sorted.bam file"
echo "           with BAMStats or Qualimap"
echo "                    Done"
echo "----------------------------------------------\n"

exit 0;
