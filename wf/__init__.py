"""
Latch wrapper of ArchR plotEmbedding function.
"""


import subprocess
from pathlib import Path

from flytekit import LaunchPlan, task, workflow
from latch.types import LatchDir

@task
def runScript(archrObj: LatchDir,output_dir: LatchDir,matrix: str="GeneScoreMatrix",geneList: str="A1BG",loopTrackType: str="Co-Accessibility",geneList_pb: str="ABCA2",groupBy: str="Clusters",upstream: str="50000",downstream: str="50000") -> LatchDir:

    subprocess.run(
        [
            "Rscript",
            "runArchR.R",
            #Path(archrObj).resolve(),
            archrObj.local_path,
            matrix,
            geneList,
            loopTrackType,
            geneList_pb,
            groupBy,
            upstream,
            downstream
        ]
    )

    local_output_dir = str(Path("/root/results").resolve())

    remote_path=output_dir.remote_path
    if remote_path[-1] != "/":
        remote_path += "/"

    return LatchDir(local_output_dir,remote_path)


@workflow
def shinyArchr_wf(archrObj: LatchDir,output_dir: LatchDir,matrix: str="GeneScoreMatrix",geneList: str="A1BG",loopTrackType: str="Co-Accessibility",geneList_pb: str="ABCA2",groupBy: str="Clusters",upstream: str="50000",downstream: str="50000") -> LatchDir:
    """is a full-featured software suite for the analysis of single-cell chromatin accessibility data.

    ArchR
    ----

    `ArchR` is a full-featured software suite for the analysis of single-cell chromatin accessibility data. Latch supports visualizing UMAPs from scATAC-seq data as well as peak browser tracks. In ArchR, embeddings, such as Uniform Manifold Approximation and Projection (UMAP) are used to visualize single cells in reduced dimension space. UMAP is designed to preserve both the local and most of the global structure in the data. Peak browser tracks are genome-track level visualizations of chromatin accessibility observed within groups of cells.


    __metadata__:
        display_name: ArchR
        author:
            name: Akshay
            email: akshaysuhag2511@gmail.com
            github:
        repository:
        license:
            id: MIT

    Args:

        archrObj:
          Select archrObj folder.

          __metadata__:
            display_name: ArchR Object

        matrix:
          Possible options: GeneScoreMatrix,GeneIntegrationMatrix and MotifMatrix.

          __metadata__:
            display_name: Matrix Type

        geneList:
          A comma seperated list of genes or motifs.

          __metadata__:
            display_name: Gene/Motif List. Example: A1BG,A1CF,A2M

        loopTrackType:
          Possible options: Co-Accessibility and Peak2GeneLinks.

          __metadata__:
            display_name: Loop Track Type
            _tmp:
                section_title: Plot Browser Parameters

        geneList_pb:
          A comma seperated list of genes.

          __metadata__:
            display_name: Gene List

        groupBy:
          A string that indicates how cells should be grouped.

          __metadata__:
            display_name: Group By

        upstream:
          The number of basepairs upstream of the transcription start site of geneSymbol to extend the plotting window.

          __metadata__:
            display_name: Upstream

        downstream:
          The number of basepairs downstream of the transcription start site of geneSymbol to extend the plotting window.

          __metadata__:
            display_name: Downstream

        output_dir:
          Where to save the plots?.

          __metadata__:
            display_name: Output Directory
    """
    return runScript(archrObj=archrObj,output_dir=output_dir,matrix=matrix,geneList=geneList,loopTrackType=loopTrackType,geneList_pb=geneList_pb,groupBy=groupBy,upstream=upstream,downstream=downstream)
