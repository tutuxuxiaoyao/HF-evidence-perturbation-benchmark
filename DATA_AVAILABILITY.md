# Data availability and reproducibility scope

This GitHub repository provides the analysis code, publication-figure source data, and documentation for the manuscript **“Cross-system benchmarking reveals limited predictive transfer from human heart failure evidence to cardiomyocyte perturbation effects.”**

## Public biological inputs

The biological inputs are third-party public datasets and published supplementary resources cited in the manuscript. In particular, the study uses public adult-human heart-failure transcriptomic resources, GEO accession GSE226314 for the recovery audit, GEO accession GSE276161 for the K4 perturbation resource, the published rare predicted loss-of-function gene-burden results used for E4, and source data accompanying the cited K2 and K3 perturbation studies.

Raw third-party biological data are not redistributed here where the original study or repository is the appropriate source.

## Files included directly in GitHub

The repository contains:
- code for the primary target-level out-of-fold reproduction audit;
- scripts that regenerate the three main manuscript figures from frozen numerical source data;
- frozen numerical source-data tables for the three main figures;
- citation, software-environment, and licensing metadata.

## Full target-level reproduction bundle

The exact frozen target-level tables used by `scripts/01_primary_oof_reproduction.R` are larger than the compact figure-source tables. They should be deposited as a versioned archival data bundle (for example in Zenodo) before journal submission, and the DOI should then be added to the manuscript Data availability statement and this file.

The historical project did not retain every upstream source-reconstruction script as a clean standalone script. This repository therefore does not claim full reconstruction from raw public downloads. The retained code reproduces the primary target-level models from the frozen target-level tables and regenerates the publication figures from frozen results.
