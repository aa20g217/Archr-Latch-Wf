library(ArchR)

dir.create("/root/results", showWarnings = FALSE)
setwd("/root/results")

args <- commandArgs(trailingOnly=TRUE)
# args=c("/Users/akshay/OneDrive - Universitaet Bern/PhD/Projetcs-extra/archR_1.0/example-dataset/inputData_for_ShinyArchR/Save-ProjHeme5",
#        "GeneScoreMatrix","A1BG,A1BG")

savedArchRProject <- loadArchRProject(args[1])
matrix=args[2]
geneList=strsplit(args[3], split = ",")[[1]]

height=8
width=8

#Umaps
#setwd("/Users/akshay/OneDrive - Universitaet Bern/latch/archrtest")
for (gene in geneList)
{
  if(matrix=="MotifMatrix")
  {
    gene1_plot=plotEmbedding(
      ArchRProj = savedArchRProject,
      colorBy = matrix,
      name = getFeatures(savedArchRProject, 
                         select = paste(gene, collapse="|"), 
                         useMatrix = matrix),
      embedding = "UMAP",
      imputeWeights = getImputeWeights(savedArchRProject))[[2]] 
  }else
  {
    gene1_plot=plotEmbedding(
      ArchRProj = savedArchRProject,
      colorBy = matrix,
      #continuousSet = "yellowBlue",
      name = gene,
      embedding = "UMAP",
      imputeWeights = getImputeWeights(savedArchRProject))
  }

  
  gene=paste(gene,matrix,sep="_")
  png(file = paste0(gene,".png"), width = width, height = height,units="in",res = 1500)
  print(gene1_plot)
  dev.off()
  }


#plot browser
loopTrackType=args[4]
geneList_pb=strsplit(args[5], split = ",")[[1]]
groupBy=args[6]
upstream = as.numeric(args[7])
downstream = as.numeric(args[8])

for (gene_pb in geneList_pb)
{
  if (loopTrackType=="Co-Accessibility")
  {
    pbPlot <- plotBrowserTrack(
      ArchRProj = savedArchRProject,
      groupBy = groupBy,
      geneSymbol = gene_pb,
      upstream =upstream,
      downstream = downstream,
      #tileSize = isolate(input$tile_size_1),
      #ylim =  c(0, isolate(input$ymax_1)),
      loops = getCoAccessibility(savedArchRProject)
    )[[gene_pb]]
  } else if(loopTrackType=="Peak2GeneLinks"){
    pbPlot <- plotBrowserTrack(
      ArchRProj = savedArchRProject,
      groupBy = groupBy,
      geneSymbol = gene_pb,
      upstream =upstream,
      downstream = downstream,
      #tileSize = isolate(input$tile_size_1),
      #ylim =  c(0, isolate(input$ymax_1)),
      loops = getPeak2GeneLinks(savedArchRProject)
    )[[gene_pb]]
  }else{print("Please provide a valid loop Track Type!")}
  
  gene_pb=paste(gene_pb,loopTrackType,sep="_")
  png(file = paste0(gene_pb,".png"), width = width, height = height,units="in",res = 1500)
  grid::grid.draw(pbPlot)
  dev.off()
}  
  




