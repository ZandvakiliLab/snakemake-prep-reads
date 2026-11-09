rule pre_fastqc:
    input:
        fastq="results/get_fastq/{sample}_{read}.fastq.gz",
    output:
        html=report(
            "results/fastqc/pre/{sample}_{read}_fastqc.html",
            category="QC",
            subcategory="FastQC",
        ),
        zip="results/fastqc/pre/{sample}_{read}_fastqc.zip",
    log:
        "results/fastqc/pre/{sample}_{read}.log",
    threads: 1
    resources:
        mem_mb=4096,
    params:
        extra=config["qc"]["fastqc"]["extra"],
    message:
        "checking fastq files with FastQC"
    wrapper:
        "v7.6.0/bio/fastqc"


rule post_fastqc:
    input:
        fastq=lambda wildcards: "results/{tool}/{sample}_{read}.fastq.gz".format(
            tool=config["trimming"]["tool"],
            sample=wildcards.sample,
            read=wildcards.read,
        ),
    output:
        html=report(
            "results/fastqc/post/{sample}_{read}_fastqc.html",
            category="QC",
            subcategory="FastQC",
        ),
        zip="results/fastqc/post/{sample}_{read}_fastqc.zip",
    log:
        "results/fastqc/post/{sample}_{read}.log",
    threads: 1
    resources:
        mem_mb=4096,
    params:
        extra=config["qc"]["fastqc"]["extra"],
    message:
        "checking fastq files with FastQC"
    wrapper:
        "v7.6.0/bio/fastqc"


rule multiqc:
    input:
        get_multiqc_input,
    output:
        report(
            directory("results/multiqc"),
            htmlindex="multiqc_report.html",
            category="QC",
            subcategory="MultiQC",
        ),
    log:
        "results/multiqc/multiqc.log",
    params:
        extra=config["qc"]["multiqc"]["extra"],
    conda:
        "../envs/multiqc.yaml",
    message:
        "generating MultiQC report for seq data"
    shell:
        """
        multiqc {params.extra} --force \
            --outdir {output} \
            --filename multiqc_report.html \
            {input} > {log} 2>&1
        """
