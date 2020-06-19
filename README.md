# Conda : Samtools Package Development

This repository is to help build conda package for samtools (and htslib) from their development branch using conda recipes.  
As both of these tools are not python based these cannot be directly installed using pip in conda enviroment file.

## 1. Setting up the conda enviroment

**Download and install Miniconda:**
```
$ sudo apt-get update -y

$ sudo apt install openjdk-8-jre-headless -y

$ wget "https://repo.anaconda.com/miniconda/Miniconda2-latest-Linux-x86_64.sh"

$ bash Miniconda2-latest-Linux-x86_64.sh
[use defaults]

```
This will install and create a base conda enviroment in your home directory (which is the default location for miniconda2 environment.

**Source your base Miniconda2 environment:**
```
$ source ~/miniconda2/bin/activate
(base) $
```

## 2. Build conda packages from conda recipes

> Use this section only if you wish to build conda packages from conda recipes, else jump to [step](https://github.com/ac55-sanger/conda_samtools_development#install-in-a-different-conda-environment). These recipes are taken from bioconda repo [1](https://github.com/bioconda/bioconda-recipes/tree/master/recipes/samtools) [2](https://github.com/bioconda/bioconda-recipes/tree/master/recipes/htslib)

Let's build the packages step by step (make sure to have sourced the base conda environment):

**Install conda-build package:**
```
(base) $ conda install conda-build 
```

**Clone this repository:**
```
(base) $ git clone https://github.com/ac55-sanger/conda_samtools_development.git

# Install required packages from apt
(base) $ sudo apt-get install autoconf automake build-essential make gcc perl zlib1g-dev libbz2-dev liblzma-dev libcurl4-gnutls-dev libssl-dev libncurses5-dev 
```

**Build htslib package:**
```
(base) $ cd ~/conda_samtools_development/conda_recipes/htslib/

(base) $ conda-build .
```
This will build htslib package under `~/miniconda2/conda-bld/linux-64/` directory.
> Version in conda recipe file meta.yaml is given as 1.19, which is just arbitarily  

Search the conda package for htslib:
```
(base) $ conda search htslib=1.19 --use-local
# Name                       Version           Build  Channel             
htslib                          1.19      h14c3975_0  home/ubuntu/miniconda2/conda-bld
```

**Build samtools package:**
```
(base) $ cd ~/conda_samtools_development/conda_recipes/samtools/

(base) $ conda-build .
```
This will build samtools package under `~/miniconda2/conda-bld/linux-64/` directory.
> Version in conda recipe file meta.yaml is given as 1.19, which is just arbitarily  

Search the conda package for samtools:
```
(base) $ conda search samtools=1.19 --use-local
# Name                       Version           Build  Channel             
samtools                        1.19      h14c3975_0  home/ubuntu/miniconda2/conda-bld
```

## 3. Install conda packages

#### Install in the same base environment

```
(base) $ conda install htslib=1.19 --use-local

(base) $ conda install samtools=1.19 --use-local
```

This will install `htslib` and `samtools` in the base miniconda2 environment.

#### Install in a different conda environment

```
# Switch to new environment
(base) $ conda activate my_env
(my_env) $

# Install conda-build package under my_env
(my_env) $ conda install conda-build

# Create a new directory ~/my_env/conda-bld/linux-64
(my_env) $ mkdir -p ~/my_env/conda-bld/linux-64

# Copy either the built package from Step2 above
(my_env) $ cp ~/miniconda2/conda-bld/linux-64/htslib-1.19-h14c3975_0.tar.bz2 ~/my_env/conda-bld/linux-64/.
(my_env) $ cp ~/miniconda2/conda-bld/linux-64/samtools-1.19-h14c3975_0.tar.bz2 ~/my_env/conda-bld/linux-64/.

# OR from this repo location conda_samtools_development/conda-packages which are pre-built
(my_env) $ cp ~/conda_samtools_development/conda-packages/* ~/my_env/conda-bld/linux-64/.

# Index the conda environment package
(my_env) $ conda index ~/my_env/conda-bld

# Install the packages
(my_env) $ conda install htslib=1.19 --use-local

(my_env) $ conda install samtools=1.19 --use-local
```

#### Install using an environment file

Now let's go back to (base) conda environment and install these packages into a new enviroment `my_env_from_file` using environment file.

Also, as we are in base environment where we originally built these packages we don't need to copy and index, else follow part of above [step](https://github.com/ac55-sanger/conda_samtools_development/new/master#install-in-a-different-conda-environment) to copy and index the packages.

> Make sure to update the channel in environment.yml file to the correct local location of conda-bld directory (here home/ubuntu/miniconda2/conda-bld)

```
(base) $ cd ~conda_samtools_development/

(base) $ conda env create --file environement.yml

# Activate the new environment (name of the environment is mentioned in environment.yml file)
(base) $ conda activate my_env_from_file

(my_env_from_file) $ samtools --version
samtools 1.10
Using htslib 1.10.2
Copyright (C) 2019 Genome Research Ltd.
```
