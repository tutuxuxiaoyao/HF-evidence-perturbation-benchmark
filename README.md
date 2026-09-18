# HF evidence-to-perturbation cross-system benchmark

Reproducibility repository for the manuscript:

**Cross-system benchmarking reveals limited predictive transfer from human heart failure evidence to cardiomyocyte perturbation effects**

## What this repository contains

The repository provides:
- code for the primary target-level out-of-fold reproduction audit;
- scripts that regenerate the three main manuscript figures from frozen numerical source data;
- frozen numerical source-data tables for the three main figures;
- transparent documentation of the scope and limits of retained code;
- software-environment, citation, and licensing metadata.

The primary reproduction code was independently checked against the retained frozen target-level tables and reproduced the primary OOF predictions and reported delta-OOF-R2 values to numerical precision.

## Quick start

To regenerate the three main figures from the numerical source data already included here:

```r
source("scripts/02_figure1_primary_validity.R")
source("scripts/03_figure2_model_robustness.R")
source("scripts/04_figure3_structural_robustness.R")
```

The primary target-level audit script is:

```r
source("scripts/01_primary_oof_reproduction.R")
```

That audit uses the larger frozen target-level data bundle deposited in the versioned Zenodo archive below.

## Repository structure

- `scripts/` — primary OOF audit and figure-regeneration scripts
- `source_data/` — frozen numerical source data for the three main figures
- `DATA_AVAILABILITY.md` — data provenance and reproducibility scope
- `R_ENVIRONMENT_REQUIREMENTS.txt` — software requirements
- `CITATION.cff` — citation metadata
- `LICENSE` — MIT license for repository code

## Public biological inputs

The biological input datasets are third-party public resources cited in the manuscript. Raw third-party biological data are not redistributed here where the original study or repository is the appropriate source.

## Reproducibility boundary

The historical project did not retain every upstream source-reconstruction script as a clean standalone script. This repository therefore does not claim complete reconstruction from raw public downloads. It provides the retained target-level reproduction logic and figure-level reproducibility without fabricating missing provenance.

## Archival DOI

Zenodo version 1.0.0: https://doi.org/10.5281/zenodo.22823039

## Repository URL

https://github.com/tutuxuxiaoyao/HF-evidence-perturbation-benchmark

## License

Code: MIT License. Third-party data remain subject to their original repository and study terms.
