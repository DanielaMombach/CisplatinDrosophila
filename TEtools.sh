#!/bin/bash

# Master paths
DANIP="/pathway_files"
TETOOLS="/your_pathway/tetools-master"

# Essential files
ROSETTE="$DANIP/rosette.txt"
TE_FASTA="$DANIP/TEreference.fasta"

# FastQ File paths
FQ_01="$DANIP/control_rep1.fq"
FQ_02="$DANIP/control_rep2.fq"
FQ_03="$DANIP/treatment_rep1.fq"
FQ_04="$DANIP/treatment_rep2.fq"

# TE output
COUNT_FILE="count_out.txt"
HTML_FILE="$DANIP/result_diff.html"
DIFF_OUTDIR="$DANIP/"

# TE count
python3 $TETOOLS/TEcount.py -bowtie2 -rosette $ROSETTE -column 1 -TE_fasta $TE_FASTA -count $COUNT_FILE -RNA $FQ_01 $FQ_02 $FQ_03 $FQ_04 $FQ_05 $FQ_06 $FQ_07 $FQ_08 $FQ_09
# TE diff
Rscript $TETOOLS/TEdiff.R --args --FDR_level=0.05 --count_column=1 --count_file=\"$COUNT_FILE\" --experiment_formula=\"Treatment:Replicate\" --sample_names=\"Control:Rep1,Control:Rep2,Control:Rep3,50:Rep1,50:Rep2,50:Rep3,100:Rep1,100:Rep2,100:Rep3\" --outdir=\"$DIFF_OUTDIR\" --htmlfile=\"$HTML_FILE\"

echo "Done! :)"
