# snakemake-prep-reads

**A snakemake module focused on preprocessing reads prior to alignment with associated QC**

This is a fork of nicely designed [snakemake-simple-mapping](https://github.com/MPUSP/snakemake-simple-mapping) repository. This fork removes any rules outside of preprocess reads and adds the following features: 

1. UMI handling
2. Download files directly from Sequence Read Archive (NCBI) and European Nucleotide Archive (ENA)
3. Fast5 handling [TODO]

## Authors

- Arya Zandvakili MD PhD
  - Affiliation: University of Cincinnati College of Medicine
  - ORCID profile: https://orcid.org/my-orcid?orcid=0000-0001-8031-8067
  - github page: https://github.com/aryazand

## References

> Köster, J., Mölder, F., Jablonski, K. P., Letcher, B., Hall, M. B., Tomkins-Tinch, C. H., Sochat, V., Forster, J., Lee, S., Twardziok, S. O., Kanitz, A., Wilm, A., Holtgrewe, M., Rahmann, S., & Nahnsen, S. _Sustainable data analysis with Snakemake_. F1000Research, 10:33, 10, 33, **2021**. https://doi.org/10.12688/f1000research.29032.2.