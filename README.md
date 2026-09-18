# HF evidence-to-perturbation cross-system benchmark

Reproducibility repository for the manuscript:

**Disease relevance and perturbational consequence are distinct evidence axes: a cross-system heart-failure benchmark**

## What this repository contains

The repository provides:
- scripts that regenerate the three main manuscript figures from frozen numerical source data;
- frozen numerical source-data tables for the three main figures;
- the retained primary target-level out-of-fold audit script;
- transparent documentation of the scope and limits of retained code;
- software-environment, citation, and licensing metadata.

## Quick start

To regenerate the three main figures from the numerical source data included here:

```r
source("scripts/02_figure1_primary_validity.R")
source("scripts/03_figure2_model_robustness.R")
source("scripts/04_figure3_structural_robustness.R")
```

The retained primary target-level audit script is:

```r
source("scripts/01_primary_oof_reproduction.R")
```

That audit script depends on larger frozen target-level tables from the historical analysis workspace. Those tables are **not currently distributed in this GitHub repository**. The script is retained to document the exact model-refitting and audit logic; a project-specific persistent archive containing the required target-level tables should be created before the manuscript cites a complete public reproduction bundle.

## Repository structure

- `scripts/` — retained primary OOF audit and figure-regeneration scripts
- `source_data/` — frozen numerical source data for the three main figures
- `DATA_AVAILABILITY.md` — data provenance and reproducibility scope
- `R_ENVIRONMENT_REQUIREMENTS.txt` — software requirements
- `CITATION.cff` — citation metadata
- `LICENSE` — MIT license for repository code

## Public biological inputs

The biological input datasets are third-party public resources cited in the manuscript. Raw third-party biological data are not redistributed here where the original study or repository is the appropriate source.

## Reproducibility boundary

The historical project did not retain every upstream source-reconstruction script as a clean standalone workflow. This repository therefore does not claim complete reconstruction from raw public downloads. It provides figure-level reproducibility from the included frozen numerical source data and retains the primary target-level audit logic for transparency.

## Persistent archive status

A Zenodo DOI previously written into draft documentation was found during final verification to resolve to an unrelated record and has been removed. Do not cite that DOI for this project. A verified project-specific persistent archive should be created for the retained larger target-level tables before final submission if a complete public target-level reproduction object is claimed.

## Repository URL

https://github.com/tutuxuxiaoyao/HF-evidence-perturbation-benchmark

## License

Code: MIT License. Third-party data remain subject to their original repository and study terms.
