#!/bin/bash
 
#SBATCH --nodes=1 
#SBATCH --ntasks=1 
#SBATCH --cpus-per-task=10 
#SBATCH --mem=50000 # using 50Gb of memory
#SBATCH --error covid_assembly-%A-%a.err   #sam_to_fastq-%A-%a.err 
#SBATCH --output covid_assembly-%A-%a.out  #sam_to_fastq-%A-%a.out
#SBATCH --mail-type=END,FAIL
#SBATCH --mail-user=kmane@mrc.gm
###SBATCH --time=5-00:00:00

typeset -F SECONDS
module load artic
threads=10

function usage()
{
	cat << HEREDOC
	
	 About:	This script is used to perform genome assembly on COVID samples sequenced with nanopore.
	 
	 
	 Usage:	./$progname --input-dir INPUT-FILES-DIRECTORY --output-dir OUTPUT-DIRECTORY --plateform SEQUENCING-PLATEFORM in interactive mode    
	 	or sbatch --array=1-16%5 $progname --input-dir INPUT-FILES-DIRECTORY --output-dir OUTPUT-DIRECTORY --plateform SEQUENCING-PLATEFORM in batch mode 
	 
	 
	 Options:
	    -i, --input-dir				full path to the folder with the input files
	    -o, --output-dir				full path to the folder where to store the output files
	    -p, --plateform				the name of the sequencing plateform (either MinION or PromethION)
	    -h, --help					display the help message and exit
	    -v, --verbose				verbose                                                                         
	 
HEREDOC
}

function validate()
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
        #exit
	fi
	
	if [ ! -z "$p" ]   
	then
		inform "the sequencing plateform is: "$p
	else
		problem "the plateform name should be ot type string. Use the -h option to display the usage"
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


OPTS=$(getopt -o "hi:o:p:v" --long "help,input-dir:,output-dir:,plateform:,verbose" -n "$0" -- "$@")
if [ $? != 0 ] ; then echo "Error in command line arguments." >&2 ; usage; exit 1 ; fi
eval set -- "$OPTS"

while true; do
  case "$1" in
    -h | --help ) usage; exit; ;;
    -i | --input-dir ) i="$2"; shift 2 ;;
    -o | --output-dir ) o="$2"; shift 2 ;;
    -p | --plateform ) p="$2"; shift 2 ;;
    -v | --verbose ) verbose=$((verbose + 1)); shift ;;
    -- ) shift; break ;;
    * ) break ;;
  esac
done
validate

dirs=`ls ${i}`  
sample_id=`echo ${dirs} | cut -d" " -f ${SLURM_ARRAY_TASK_ID}`
mkdir -p "${o}/${sample_id}" || exit

if [ "$p" = "MinION" ] 
then
	medaka_model="r941_min_fast_g303"
else
	medaka_model="r941_prom_hac_g303"
fi

# Read filtering
artic guppyplex --prefix ${o}/${sample_id}/${sample_id} --min-length 350 --max-length 700 --directory ${i}/${sample_id} 

# genome assembly
cd ${o}
artic minion --medaka --medaka-model ${medaka_model} --normalise 200 --threads ${threads} --scheme-directory $ARTIC_DIR/artic-ncov2019/primer_schemes --read-file ${o}/${sample_id}/${sample_id}_${sample_id}.fastq nCoV-2019/V3 ${sample_id}

sleep 2

echo -e "\n\nWall time is "$SECONDS" seconds"




