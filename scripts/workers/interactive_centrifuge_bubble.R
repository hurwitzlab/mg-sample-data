#!/usr/bin/env Rscript

library(plyr)
library(ggplot2)


#SETWD: Location of centrifuge_report.tsv files. Should all be in same directory
setwd("/Users/Scott/Google Drive/Hurwitz Lab/Postdocking/audnacs/phs000790/withQCandallthat/")

temp = list.files(pattern="*centrifuge_report.tsv")
myfiles = lapply(temp, read.delim)
sample_names <- as.list(sub("*centrifuge_report.tsv", "", temp))
myfiles = Map(cbind, myfiles, sample = sample_names)

exclude="9606,32630,374840"
exclude=unlist(strsplit(exclude,","))

#Filter settings, default is to remove human and synthetic constructs
for (i in exclude) {
    myfiles <- llply(myfiles, function(x)x[x$name!=i,])
}

#Proportion calculations: Each species "Number of Unique Reads" is divided by total "Unique Reads"

props = lapply(myfiles, function(x) {
  x$proportion <- ((x$numUniqueReads / sum(x$numUniqueReads)) * 100)
  x$abundance <- x$abundance * 100
  x$hitratio <- x$numUniqueReads / x$numReads
  return(x[,c("name","proportion", "abundance", "genomeSize", "sample", "numReads", "numUniqueReads", "taxID", "hitratio")])
})

#Final dataframe created for plotting, can change proportion value (Default 1%)
final <- llply(props, subset, abundance > .5)
final <- llply(final, subset, proportion > .5)
df <- ldply(final, data.frame)

names(df) <- c("Name", "Proportion", "Abundance", "genomeSize", "sample", "numReads", "numUniqueReads", "taxID", "hitratio")

#SCATTER PLOT WITH POINT SIZE
#Set file name and bubble plot title. Stored in out.dir
plot_title="test plot"
pdf("test.pdf")
p2 <- ggplot(df, aes(as.factor(sample), as.factor(Name))) + geom_point(aes(size = Abundance))
p2 <- p2 + theme(text = element_text(size=20), axis.text.x = element_text(angle = 90, hjust = 1))
p2 <- p2 + labs(y = "Organism", x = "Sample")
p2 <- p2 + ggtitle(plot_title) + theme(plot.title = element_text(hjust = 0.5))
p2 <- p2 + guides(color=F)
print(p2)
dev.off()

#write.csv(df, file = paste0(out.dir, file_name, ".csv"))

