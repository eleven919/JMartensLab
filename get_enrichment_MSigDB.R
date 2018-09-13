#!/usr/bin/Rscript --slave --no-restore --no-save

args <- commandArgs(TRUE)

if (length(args)!=4){
  stop("Four arguments must be supplied")
}else{
  #Load Data
  message("Reading data...")
  #one column containing gene name
  gene_list <- read.table(file = args[1], header = F)[,1]
  #gene number
  gene_bg <- as.integer(args[2])
  #reading MSigDB collections
  numcols = count.fields(file = args[3])
  msigdata = read.table(file = args[3], fill=TRUE, col.names=1:max(numcols))
}


library(qvalue)

get_enrichments <- function(msigdata, gene_list, gene_bg) {
  genesetsizes=apply(msigdata, 1, function(msigdbgroup) {return(length(which(msigdbgroup[3:length(msigdbgroup)]!="")))})
  web=apply(msigdata, 1, function(msigdbgroup) {return(msigdbgroup[2])})
  overlaps=apply(msigdata, 1, function(msigdbgroup) { msigdbgenes=msigdbgroup[3:length(msigdbgroup)]; overlap=subset(gene_list,gene_list %in% msigdbgenes); overlap=paste(as.character(overlap), collapse=", "); return(overlap) })
  numoverlaps=apply(msigdata, 1, function(msigdbgroup) { msigdbgenes=msigdbgroup[3:length(msigdbgroup)]; numoverlap=length(which(gene_list %in% msigdbgenes)); return(numoverlap) })
  gene_listsize=length(gene_list)
  ## calculate hypergeom p-vals
  pvals=lapply(1:nrow(msigdata), function(ind) {
  k=numoverlaps[ind]-1
  genesetsize=genesetsizes[ind]
  return(phyper(k, genesetsize, gene_bg-genesetsize, gene_listsize, lower.tail=FALSE))})
  pvals=unlist(pvals)
  names(pvals)=msigdata[,1]
  ordering=order(pvals, decreasing=FALSE)
  sorted.pvals=pvals[ordering]
  print(paste("Number of unique gene ids used for enrichment:", gene_listsize))
  fdr.vals=qvalue(sorted.pvals)$qvalue
  names(fdr.vals)=names(sorted.pvals)
  results=data.frame(geneset=names(fdr.vals), web=web[ordering],genesetsizes=as.numeric(genesetsizes[ordering]), numoverlaps=as.numeric(numoverlaps[ordering]),overlaps=as.character(overlaps[ordering]), koverK=as.numeric(numoverlaps[ordering])/as.numeric(genesetsizes[ordering]), qval=as.numeric(fdr.vals), origpval=as.numeric(sorted.pvals))
  row.names(results)=names(fdr.vals)
  colnames(results)=c("geneset", "web","genesetsize (K)", "numoverlaps (k)", "genes", "k/K", "qval", "orig_pval")
  keepinds=which(results[,"qval"]<=1)
  results=results[keepinds,]
  if(length(keepinds)>1) {
  tmporder=order(results[, 4], decreasing=TRUE)
  tmp=results[tmporder,]
  finalorder=order(tmp[, "qval"], decreasing=FALSE)
  results=tmp[finalorder,]
}
  write.table(results, file=args[4], quote=FALSE, row.names=FALSE, sep="\t")
}

get_enrichments(msigdata, gene_list, gene_bg)
