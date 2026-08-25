# import basic packages
import pandas as pd
from snakemake.utils import validate
from pathlib import Path

# read sample sheet
samples = (
    pd.read_csv(config["samplesheet"], sep="\t", dtype={"sample": str})
    .set_index("sample", drop=False)
    .sort_index()
)


# validate sample sheet and config file
validate(samples, schema="../../config/schemas/samples.schema.yml")
validate(config, schema="../../config/schemas/config.schema.yml")


# determine input type
def is_paired_end():
    if config["get_fastq"]["PE"]:
        return True
    elif config["get_fastq"]["PE"] == False:
        return False
    else:
        return "config['get_fastq']['PE'] must be either True or False"


# get fastq files
def get_fastq(wildcards):
    if config["get_fastq"]["tool"] == "local":
        file = Path(samples.loc[wildcards.sample][wildcards.read])
        if file.is_absolute():
            return file
        else:
            input_dir = Path.absolute(Path.cwd())
            return input_dir / file
    else:
        accession = samples.loc[wildcards.sample]["accession"]
        tool = config["get_fastq"]["tool"]
        read = "1" if wildcards.read == "read1" else "2"
        return f"results/sra/{tool}/{accession}_{read}.fastq.gz"


# get pairs of fastq files for trimming
def get_fastq_pairs(wildcards):
    if config["umi_extraction"]["enabled"]:
        return expand(
            "results/{tool}/extract/{sample}_{read}.fastq.gz",
            sample=wildcards.sample,
            read=["read1", "read2"] if is_paired_end() else ["read1"],
            tool=config["umi_extraction"]["tool"],
        )
    else:
        return expand(
            "results/get_fastq/{sample}_{read}.fastq.gz",
            sample=wildcards.sample,
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        )


# get input for multiqc
def get_multiqc_input(wildcards):
    result = []
    result += expand(
        "results/fastqc/{sample}_{read}_fastqc.{ext}",
        sample=samples.index,
        read=["read1", "read2"] if is_paired_end() else ["read1"],
        ext=["html", "zip"],
    )
    result += expand(
        "results/fastp/{sample}.json",
        sample=samples.index,
    )
    return result
