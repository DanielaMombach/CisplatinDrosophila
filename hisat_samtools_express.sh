#!/bin/bash

#BASH SCRIPT FOR RNASEQ ANALYSIS

set -e


###Define variables (directories, softwares, array of data names)
DIR="your_pathway"
DIR2="your_pathway"
DIRSOFT=/sofware_directory

DIRFASTQ="$DIR"
DIRFASTQ2="$DIR2"
DIRREF=/reference_directory
DIRALIGN="$DIR"/align
DIRALIGN2="$DIR2/align2"
DIRCOUNTREADS="$DIR"/countreads
DIRCOUNTREADS2="$DIR2"/countreads2
DIRCOUNTTE="$DIR"/countte
DIRCOUNTTE2="$DIR2"/countte2

HISAT2=/your_pathway/hisat2
HISAT2BUILD=/your_pathway/hisat2-build
SAMTOOLS=/your_pathway/samtools
EXPRESS="$DIRSOFT"/express-1.5.1-linux_x86_64/express

REF=reference_genome

###Create index of the reference genome with hisat2
echo -e "\n*---------- CREATE INDEX"
"$HISAT2BUILD" -p 4 -f "$DIRREF"/"$REF".fasta "$DIRREF"/"$REF""_hisat2.index"


###Align reads to the reference genome with hisat2

	echo -e "\n*---------- ALIGN READS control 1 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/control_rep1.fq -S "$DIRALIGN"/control_rep1.sam

	echo -e "\n*---------- ALIGN READS control 2 TO THE REF GENOME"
	"$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ2"/control_rep2 -S "$DIRALIGN2"/control_rep2.sam

	echo -e "\n*---------- ALIGN READS treatment 1 TO THE REF GENOME"
   "$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/treatment_rep1.fq -S "$DIRALIGN"/treatment_rep1.sam

	echo -e "\n*---------- ALIGN READS treatment 2 TO THE REF GENOME"
    "$HISAT2" -p 4 -x "$DIRREF"/"$REF""_hisat2.index" "$DIRFASTQ"/treatment_rep2.fq -S "$DIRALIGN"/treatment_rep2.sam


###Convert SAM files to BAM

	echo -e "n*-----------control 1 SAM TO BAM"
	"$SAMTOOLS" view -bS "$DIRALIGN"/control_rep1.sam > "$DIRALIGN"/control_rep1.bam
	echo -e "n*-----------control 1 SAM EXCLUDING"
       rm -R "$DIRALIGN"/control_rep1.sam

	echo -e "n*-----------control 2 SAM TO BAM"
        "$SAMTOOLS" view -bS "$DIRALIGN2"/control_rep2 > "$DIRALIGN2"/control_rep2.bam
	echo -e "n*-----------control 2 SAM EXCLUDING"
        rm -R "$DIRALIGN2"/control_rep2.sam

  echo -e "n*-----------treatment 1 SAM TO BAM"
        "$SAMTOOLS" view -bS "$DIRALIGN"/treatment_rep1.sam > "$DIRALIGN"/treatment_rep1.bam
	echo -e "n*-----------treatment 1 SAM EXCLUDING"
       rm -R "$DIRALIGN"/treatment_rep1.sam

  echo -e "n*-----------treatment 2 SAM TO BAM"
     "$SAMTOOLS" view -bS "$DIRALIGN"/treatment_rep2.sam > "$DIRALIGN"/treatment_rep2.bam
  echo -e "n*-----------treatment 2 SAM EXCLUDING"
       rm -R "$DIRALIGN"/treatment_rep2.sam
	

###Count reads per gene with express

	echo -e "\n*---------- COUNT READS PER GENE"
	"$EXPRESS" -o "$DIRCOUNTREADS"/control_rep1 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/control_rep1.bam
	
	"$EXPRESS" -o "$DIRCOUNTREADS2"/control_rep2 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN2"/control_rep2.bam

	"$EXPRESS" -o "$DIRCOUNTREADS2"/treatment_rep1 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN2"/treatment_rep1.bam
	
	"$EXPRESS" -o "$DIRCOUNTREADS"/treatment_rep2 -O 1 --output-align-prob --calc-covar "$DIRREF"/"$REF".fasta --f-stranded "$DIRALIGN"/treatment_rep2.bam