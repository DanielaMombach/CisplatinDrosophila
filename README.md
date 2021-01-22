# CisplatinDrosophila
Code for Bioinformatics Analyses of....

## python script to split reads above 100bp
### fastq_splitter.py (manual_fastq_splitter.txt)

## hisat2 and eXpress for alignment with reference genome and to create the genes count table
### hisat_samtools_express.sh
reference genome used: dmel-all-gene-r6.32.fasta.gz (ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r6.32_FB2020_01/fasta/)

## TEtools - TEcount to create TEs count table
### TEtools.sh
TEs reference used: dmel-all-transposon-r6.32.fasta.gz (ftp://ftp.flybase.net/genomes/Drosophila_melanogaster/dmel_r6.32_FB2020_01/fasta/)

## deseq2 for differential expression analysis
### deseq2.R

## GenomicRanges to cross TEs and genes coordinates
### TEs_Genomic_Ranges.R

## Blastn of transcripts from Trinity assembly (Galaxy Repository) against TEs consensus sequences from Sackton et al. (2009)
### TEs_blastn.sh
