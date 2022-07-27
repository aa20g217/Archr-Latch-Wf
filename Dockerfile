FROM 812206152185.dkr.ecr.us-west-2.amazonaws.com/latch-base:9a7d-main

#Install R
RUN apt install -y dirmngr apt-transport-https ca-certificates software-properties-common gnupg2
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/debian buster-cran40/'
RUN apt update
RUN apt install -y r-base

# Install system dependencies for R
RUN apt-get update -qq && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
        apt-transport-https \
        build-essential \
        curl \
        gfortran \
        libatlas-base-dev \
        libbz2-dev \
        libcairo2 \
        libcurl4-openssl-dev \
        libicu-dev \
        liblzma-dev \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libpcre3-dev \
        libtcl8.6 \
        libtiff5 \
        libtk8.6 \
        libx11-6 \
        libxt6 \
        locales \
        tzdata \
        zlib1g-dev

# Install system dependencies for devtools
RUN apt-get update -qq && \
        DEBIAN_FRONTEND=noninteractive apt-get install -y \
        git \
        libssl-dev \
        libicu-dev \
        libxml2-dev \
        make \
        libgit2-dev \
        pandoc \
        libgsl-dev


#Install R packages
RUN R -e 'install.packages("devtools",repo="https://cloud.r-project.org",dependencies = TRUE)'
RUN R -e 'install.packages("BiocManager",repo="https://cloud.r-project.org",dependencies = TRUE)'
RUN R -e 'devtools::install_github("GreenleafLab/ArchR", ref="master", repos = BiocManager::repositories())'
RUN R -e 'install.packages("hexbin",repo="https://cloud.r-project.org",dependencies = TRUE)'

# You can use local data to construct your workflow image.  Here we copy a
# archr object.
COPY runArchR.R /root/runArchR.R

# Install pip
RUN apt-get install -y python3-pip

# STOP HERE:
# The following lines are needed to ensure your build environement works
# correctly with latch.
COPY wf /root/wf
ARG tag
ENV FLYTE_INTERNAL_IMAGE $tag
RUN python3 -m pip install --upgrade latch
WORKDIR /root
