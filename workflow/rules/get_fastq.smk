rule fastq_dump:
    output:
        fastq=expand(
            "results/sra/fastq_dump/{{accession}}{read}.fastq.gz",
            read=["_1", "_2"] if is_paired_end() else ["_1"],
        ),
    log:
        "results/sra/fastq_dump/{accession}.log",
    conda:
        "../envs/sratools.yml"
    threads: 6  # defaults to 6
    params:
        outdir=lambda w, output: os.path.dirname(output.fastq[0]),
        extra=config["get_fastq"]["fastq_dump"]["extra"],
        paired_flag="--split-3" if is_paired_end() else "",
        is_paired="true" if is_paired_end() else "false",
    shell:
        """
        fastq-dump {params.extra} {params.paired_flag} --outdir {params.outdir} {wildcards.accession} &>{log}
        if [ {params.is_paired} = "true" ]; then
            pigz -p {threads} -f {params.outdir}/{wildcards.accession}_1.fastq
            pigz -p {threads} -f {params.outdir}/{wildcards.accession}_2.fastq
        else
            pigz -p {threads} -f {params.outdir}/{wildcards.accession}.fastq
            mv {params.outdir}/{wildcards.accession}.fastq.gz {params.outdir}/{wildcards.accession}_1.fastq.gz
        fi
        """


rule fasterq_dump:
    output:
        fastq=expand(
            "results/sra/fasterq_dump/{{accession}}{read}.fastq.gz",
            read=["_1", "_2"] if is_paired_end() else [""],
        ),
    log:
        "results/sra/fasterq_dump/{accession}.log",
    threads: 6  # defaults to 6
    params:
        extra=config["get_fastq"]["fasterq_dump"]["extra"],
    wrapper:
        "v9.15.0/bio/sra-tools/fasterq-dump"


rule get_fastq:
    input:
        get_fastq,
    output:
        fastq="results/get_fastq/{sample}_{read}.fastq.gz",
    log:
        "results/get_fastq/{sample}_{read}.log",
    conda:
        "../envs/basic.yml"
    message:
        "obtaining fastq files"
    shell:
        """
        input_file=$(realpath {input})
        ln -s $input_file {output.fastq}
        echo 'made symbolic link from {input} to {output.fastq}' >{log}
        """
