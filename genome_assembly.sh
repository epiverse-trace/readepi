#!/bin/zsh

conda deactivate
conda activate artic-ncov2019

# argument1: sample id
# argument2: input files dir
# argument3: genome assembly dir
# argument4: number of threads per process
# argument5: medaka model

# Read filtering
mkdir -p ${3}/${1}
artic guppyplex --prefix ${3}/${1}/${1} --min-length 350 --max-length 700 --directory ${2} #   --output ${3}/${1} 

# genome assembly
cd ${3}
artic minion --medaka --medaka-model ${5} --normalise 200 --threads ${4} --scheme-directory ~/artic-ncov2019/primer_schemes --read-file ${3}/${1}/${1}_${1}.fastq nCoV-2019/V3 ${1}  #--medaka

conda deactivate




