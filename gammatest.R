#!/usr/bin/Rscript --slave --no-restore --no-save

args <- commandArgs(TRUE)

if (length(args)!=2){
  stop("Two arguments must be supplied")
}else{
  peakfolder <- args[1]
  filename <- args[2]
}


library(MASS)

files <- list.files(path=peakfolder, pattern="*.npf$", full.names=T, recursive=FALSE)

lapply(files, function(x){
  r <- read.table(x, header=F)
  s <- subset(r, r$V7>5)
  k <- subset(r, r$V7<5)
  g <- MASS::fitdistr(k$V7, "gamma")
  k$V8 <- sapply(k$V7, function(y) ks.test(y, "pgamma", shape=g$estimate["shape"], rate=g$estimate["rate"])$p.value)
  k <- subset(k, k$V8<0.05)
  if (is.data.frame(s) & nrow(s)==0) {
  k <- k[,c(1,2,3,7,8,10)]
  myfile <- paste(peakfolder,filename,sep="")
  write.table(k, myfile, sep="\t", row.names=FALSE, col.names=FALSE, quote=FALSE, append=TRUE)
  } else {s$V8 <- 0
  k <- rbind(k,s)
  k <- k[,c(1,2,3,7,8,10)]
  myfile <- paste(peakfolder,filename,sep="")
  write.table(k, myfile, sep="\t", row.names=FALSE, col.names=FALSE, quote=FALSE, append=TRUE)}
})
