library(data.table)
library(stats4)
library(BiocGenerics)
library(S4Vectors)
library(IRanges)
library(GenomeInfoDb)
library(GenomicRanges)
library(intervals)
library(purrr)

#Import tables

Genes=read.csv("genes_down_100.csv", header = T, sep = "\t")
head(Genes)

TEs=read.csv("dmel_insertions_up.csv", header = T, sep = "\t")
head(TEs)


##### STEP 1 #####
#Create intervals to genes and TEs
GeneRanges=GRanges(seqnames=Genes$chromosome,ranges=IRanges(start=as.numeric(as.vector(Genes$start)),end=as.numeric(as.vector(Genes$end))), name=Genes$info)
TEsRanges=GRanges(seqnames=TEs$chromosome,ranges=IRanges(start=as.numeric(as.vector(TEs$start)),end=as.numeric(as.vector(TEs$end))),name=TEs$id)

#Search for overlap sequences
Overlaps=findOverlapPairs(GeneRanges, TEsRanges)
PosTable=Overlaps@second # coordinates of the TEs that are inside the Genes
PosTable=Overlaps@second$name # IDs of the ones that are inside

#Save overlapped sequences
write.table(Overlaps, "Overlaps.csv")
write.table(PosTable, "TEs_inside_genes.csv")


##### STEP 2 #####

# To do the Up and Downstream what I did is just change the start and end of the gene + or - the quantity you want
x = 2000
Genes$Start_UP=Genes$start-x
Genes$End_Down=Genes$end+x

# And now redo the Ranges but with the new Start or end
# Search for promoter/regulatory region with TE sequence
GenesRanges_UP=GRanges(seqnames=Genes$chromosome,ranges=IRanges(start=as.numeric(as.vector(Genes$S)),end=as.numeric(as.vector(Genes$start))),name=Genes$info)

#Search for TE sequence downstream gene
GenesRanges_DOWN=GRanges(seqnames=Genes$chromosome,ranges=IRanges(start=as.numeric(as.vector(Genes$start)),end=as.numeric(as.vector(Genes$End_Down))),name=Genes$id)

#Save table with TEs sequences inside promoter region
Overlaps2=findOverlapPairs(GenesRanges_UP, TEsRanges)
write.table(Overlaps2, "Overlaps2.csv")
                          
                          
                          
                          
