#!/usr/bin/env bash

#$input_TEs: fasta file with TEs consensus sequences
input_TEs="bergman_TEs_cons.fa"

#input transcripts: fasta file of transcripts (trinity output)
input_transcripts="cem_trinity.fasta"

#$output: blast DB for TEs consensus sequences
output="blast_DB"

#$output1: blastn results
output1="blast_output.tsv"

#$output2: blastn results filtered by highest bitscore
output2="blast_higherbitscore.txt"

#$output3: transcript IDs with best bit score
output3="blast_bestbitscore.txt"

#$output4: removel of duplicated IDs with best bit scores
output4="blast_dup.txt"

#$output_final: fasta file od transcripts with high similarity with TEs consensus sequences
output_final="final.txt"

#$output_sam
output_sam="output_sam.txt"

#$output_final_fai: .fai file
output_final_fai="final.txt.fai"

#$output_cut
output_cut="cut.txt"

#$awkcut
awkcut="awkcut.txt"

# creating blastn database
makeblastdb -in $input_TEs -dbtype nucl -out $output

# blastn
blastn -query $input_transcripts -db $output -evalue 1e-50 -outfmt 6 -out $output1

# sort table 	
sort -k1,1 -k12,12gr -k11,11g -k3,3gr $output1 | sort -u -k1,1 --merge > $output2

# colum 1 to another table		
awk '{print $1}' $output2 > $output3

# sorting and removing duplicates			
sort $output3 | uniq > $output4

# seqtk				
seqtk subseq $input_transcripts $output4 > $output_final

### checking results ###

# count number of sequences
grep '>' $output_final | wc -l

# samtools
samtools faidx $output_final 

# colum 1-2 to new table
cut -f1-2 $output_final_fai > $output_cut

# summing colum 2 and dividing by the number of lines
awk '{ total += $2 } END { print total/NR }' $output_cut

# sorting colum 2
awk '{print $2}' $output_cut | sort > $awkcut
