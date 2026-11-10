rule fastp:
    input:
        sample=get_fastq_pairs,
    output:
        html=report("results/fastp/{sample}.html", category="Trimming"),
        json="results/fastp/{sample}.json",
        trimmed=expand(
            "results/fastp/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
    log:
        "results/fastp/{sample}.log",
    threads: 2
    resources:
        mem_mb=4096,
    params:
        extra=config["trimming"]["fastp"]["extra"],
    message:
        "trimming and QC filtering reads using fastp"
    wrapper:
        "v9.4.1/bio/fastp"


rule fastplong:
    input:
        sample=get_fastq_pairs,
    output:
        html=report("results/fastplong/{sample}.html", category="Trimming"),
        json="results/fastplong/{sample}.json",
        trimmed=expand(
            "results/fastplong/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
    log:
        "results/fastplong/{sample}.log",
    conda:
        "../envs/fastplong.yml"
    threads: 2
    resources:
        mem_mb=4096,
    params:
        extra=config["trimming"]["fastplong"]["extra"],
    message:
        "trimming and QC filtering reads using fastplong"
    shell:
        """
        fastplong \
            --thread {threads} \
            --in {input.sample} \
            --out {output.trimmed} \
            --html {output.html} \
            --json {output.json} \
            {params.extra} \
            >{log} 2>&1
        """


if config["get_fastq"]["PE"] == True:
    rule cutadapt:
        input:
            get_fastq_pairs,
        output:
            fastq1="results/cutadapt/{sample}_read1.fastq.gz",
            fastq2="results/cutadapt/{sample}_read2.fastq.gz",
            qc="results/cutadapt/{sample}.qc.txt",
        log:
            "results/cutadapt/{sample}.log",
        threads: 4  # set desired number of threads here
        params:
            adapters=config["trimming"]["cutadapt"]["adapters"],
            extra=config["trimming"]["cutadapt"]["extra"],
        message:
            "trimming and QC filtering reads using cutadapt"
        wrapper:
            "v9.19.4/bio/cutadapt/pe"
else:
    rule cutadapt:
        input:
            get_fastq_pairs,
        output:
            fastq="results/cutadapt/{sample}_read1.fastq.gz",
            qc="results/cutadapt/{sample}.qc.txt",
        log:
            "results/cutadapt/{sample}.log",
        threads: 4  # set desired number of threads here
        params:
            adapters=config["trimming"]["cutadapt"]["adapters"],
            extra=config["trimming"]["cutadapt"]["extra"],
        message:
            "trimming and QC filtering reads using cutadapt"
        wrapper:
            "v9.19.4/bio/cutadapt/se"