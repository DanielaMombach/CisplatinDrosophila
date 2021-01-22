##Input count table
counttable = read.csv("count.gte.csv", header = TRUE, row.names = 1, sep = ",")
head(counttable)

##The dim must has only columns representing the samples
dim(counttable)

##colData creation
condition = c("control","control","50","50","100","100")
colData = data.frame(row.names=colnames(counttable), treatment=factor(condition, levels=c("control","50","100")))
colData                     

##Differential expression analysis

library(DESeq2)
dataset <- DESeqDataSetFromMatrix(countData = counttable, colData = colData, design = ~treatment)
dataset
dds = DESeq(dataset)
head(dds)
result = results(dds, contrast=c("treatment","50","control"))
write.table(result, file="50_deseq.csv", sep = ",")
result2 = results(dds, contrast=c("treatment","100","control"))
write.table(result2, file="100_deseq.csv", sep = ",")

