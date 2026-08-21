rule umi_tools_extract:
    input:
        fastq=expand(
            "results/get_fastq/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
    output:
        fastq=expand(
            "results/umi_tools/extract/{{sample}}_{read}.fastq.gz",
            read=["read1", "read2"] if is_paired_end() else ["read1"],
        ),
    log:
        "results/umi_tools/extract/{sample}.log",
    container:
        "docker://quay.io/biocontainers/umi_tools:1.1.6--py310h1fe012e_0"
    threads: 1
    params:
        extra=config["processing"]["umi_extraction"]["umi_tools"]["extra"],
        input_args=lambda wildcards, input, output: (
            f"-I {input.fastq[0]} -S {output.fastq[0]} "
            f"--read2-in={input.fastq[1]} --read2-out={output.fastq[1]}"
            if is_paired_end()
            else f"-I {input.fastq[0]} -S {output.fastq[0]}"
        ),
    message:
        "extracting UMIs using umi_tools"
    shell:
        """
        mkdir -p $(dirname {output.fastq[0]})
        umi_tools extract {params.extra} {params.input_args} -L {log}
        """