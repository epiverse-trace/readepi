#!/bin/bash

###SBATCH --job-name="combine_fasta"
###SBATCH --partition=bigmem # 
###SBATCH --qos=bigmem 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=10 
#SBATCH --mem=5000 # using 5Gb of memory
#SBATCH --error combine_fasta.err   
#SBATCH --output combine_fasta.out  
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=kmane@mrc.gm
###SBATCH --time=5-00:00:00


function usage()
{
	cat << HEREDOC
	
	 About:	This script is used to merge the individual consensus fasta files into one single file.
	 
	 
	 Usage:	./$progname --input-dir INPUT-FILES-DIRECTORY --output-dir OUTPUT-DIRECTORY in interactive mode    
	 	or sbatch $progname --input-dir INPUT-FILES-DIRECTORY --output-dir OUTPUT-DIRECTORY in batch mode 
	 
	 
	 Options:
	    -i, --input-dir			full path to the folder with the outputs frpm the genome assembly step 
	    -o, --output-dir			full path to the folder where to store the merged fasta file
	    -h, --help				display the help message and exit
	    -v, --verbose			verbose                                                                         
	 
HEREDOC
}

validate()
{
	if [ -d $i ]
	then
		inform "the barcodes are in: "$i
	else
		problem "required path to the input files not found! Use the -h option to display the usage"
        exit
	fi
	
	if [ -d $o ]
	then
		inform "the output files will be stored in: "$o
	else
		mkdir $o
        exit
	fi
}

function inform {
  TIMESTAMP=`date +"%a %b %d %X %Y"`
  echo "[$TIMESTAMP] $*" 1>&2
}

function problem {
  TIMESTAMP=`date +"%a %b %d %T %Y"`
  echo -e "\n[$TIMESTAMP] *ERROR*: $*" 1>&2
}

progname=$(basename $0) 

if [[ ! $@ =~ ^\-.+ ]]
then
	echo "No options were passed! See usage below"
	usage
	exit
fi


OPTS=$(getopt -o "hi:o:v" --long "help,input-dir:,output-dir:,verbose" -n "$0" -- "$@")
if [ $? != 0 ] ; then echo "Error in command line arguments." >&2 ; usage; exit 1 ; fi
eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help ) usage; exit; ;;
    -i | --input-dir ) i="$2"; shift 2 ;;
    -o | --output-dir ) o="$2"; shift 2 ;;
    -v | --verbose ) verbose=$((verbose + 1)); shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
validate

cd ${i}

cat *.consensus.fasta > ${o}/consensus_genomes.fasta




