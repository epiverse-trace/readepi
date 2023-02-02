

#' Function to perform the genome assembly
#' @param input.dir the path to the folder with the input fastq files. Each sample/barcode will have a directory in this folder
#' @param assembly.dir the path to the folder where the output files from the genome assembly will be stored
#' @param consensus.fasta.dir the path to the folder where the merged consensus fasta file will be stored
#' @param num.samples the number of samples in the dataset
#' @param device the sequencing device (either MinION or PromethION)
#' @param partition the partition. Only set this when running on a HPC, default is NULL
#' @examples genome_assembly(input.dir, assembly.dir, consensus.fasta.dir, num.samples, device="MinION", partition=NULL)
#' @returns the output of this function is the merged fasta file that will be in the folder specified using the consensus.fasta.dir parameter
#' @export
genome_assembly = function(input.dir, assembly.dir, consensus.fasta.dir, num.samples, device="MinION", partition=NULL){
  # checking the input parameters
  if(!dir.exists(input.dir)){
    stop(input.dir," not found!")
  }
  system(sprintf("mkdir -p %s %s", assembly.dir, consensus.fasta.dir))
  if(!is.numeric(num.samples)){
    stop("The value for the num.samples argument should be type numeric.")
  }
  if(!(device %in% c("MinION", "PromethION"))){
    stop("Incorrect sequencing device name provided! Expected value are: 'MinION' or 'PromethION'")
  }
  if(device=="MinION") medaka.model = "r941_min_fast_g303"
  else medaka.model = "r941_prom_hac_g303"

  # identifying the support system
  if(grepl("Darwin", system(sprintf("uname -a"), intern = TRUE)) | is.null(partition)){
    cat("\nRunning genome assembly on Mac OS ...\n")
    sample.dirs = list.dirs(input.dir, recursive = FALSE, full.names = TRUE)
    if(length(sample.dirs)==0){
      stop("Fastq files must be stored in individual directories, 1 derectory per sample")
    }
    cores = parallel::detectCores()-1
    cl = parallel::makeCluster(cores)
    doParallel::registerDoParallel(cl)
    num.threads=2
    foreach::foreach(i=1:length(sample.dirs)) %dopar%{
      sample.id = basename(sample.dirs[i])
      system(sprintf("zsh -i genome_assembly.sh %s %s %s %d %s",
                     sample.id,
                     sample.dirs[i],
                     assembly.dir,
                     num.threads,
                     medaka.model))
    }
    parallel::stopCluster(cl = cl)
    cat("\nMerging the consensus fasta files")
    system(sprintf("./merge_fasta.sh %s %s",
                   assembly.dir,
                   consensus.fasta.dir))
  }else{
    cat("\nRunning genome assembly on HPC ...\n")
    if(num.samples>5){
      jid = system(sprintf("sbatch -J \"%s\" --partition=%s --qos=%s --array=[1-%d]%%5 covid_assembly_artic.sh --input-dir %s --output-dir %s",
                           "genome_assembly",
                           partition,
                           partition,
                           num.samples,
                           input.dir,
                           assembly.dir), intern = TRUE)
    }else{
      jid = system(sprintf("sbatch -J \"%s\" --partition=%s --qos=%s --array=[1-%d] covid_assembly_artic.sh --input-dir %s --output-dir %s",
                           "genome_assembly",
                           partition,
                           partition,
                           num.samples,
                           input.dir,
                           assembly.dir), intern = TRUE)
    }

    cat("\nConcatenating the individual fasta files\n")
    # jid2 = readr::parse_number(jid)
    system(sprintf("sbatch -J \"%s\" --partition=%s --qos=%s --dependency=afterok:%d put_consensus_together.sh --input-dir %s --output-dir %s",
                   "concatenate_fasta",
                   partition,
                   partition,
                   jid,
                   assembly.dir,
                   consensus.fasta.dir))
  }
}


#' function to perform clade assignment using **nextclade** and **pangolin**
#' @param merged.fasta path to the fasta file with the sequences from all samples
#' @param output.dir path to the folder where the clade assignment results will be stored
#' @details install both nextclade and pangolin using **conda**
#' @returns the output files in the specified output directory
#' @examples clade_assignment(merged.fasta, output.dir)
#' @export
clade_assignment = function(merged.fasta, output.dir){
  if(!file.exists(merged.fasta)){
    stop(merged.fasta," not found!")
  }
  system(sprintf("mkdir -p %s",output.dir))

  cat("\nPerforming clade assignment with nextclade\n")
  nextclade.dir = paste0(output.dir,"/nextclade")
  system(sprintf("mkdir -p %s",nextclade.dir))
  ref.data.dir = paste0(nextclade.dir,"/ref_data")
  system(sprintf("mkdir -p %s",ref.data.dir))
  ref.covid.data.dir = paste0(ref.data.dir,"/sars-cov-2")
  system(sprintf("mkdir -p %s",ref.covid.data.dir))
  system(sprintf("./run_nextclade.sh %s %s %s",
                 ref.covid.data.dir,
                 nextclade.dir,
                 merged.fasta))

  cat("\nPerforming clade assignment with pangolin\n")
  pangolin.dir = paste0(output.dir,"/pangolin")
  system(sprintf("mkdir -p %s",pangolin.dir))
  system(sprintf("zsh -i run_pangolin.sh %s %s",
                 merged.fasta,
                 pangolin.dir))
}
