# Data availability and reproducibility scope

This GitHub repository provides retained analysis code, publication-figure source data, and documentation for the manuscript **“Disease relevance and perturbational consequence are distinct evidence axes: a cross-system heart-failure benchmark.”**

## Public biological inputs

The biological inputs are third-party public datasets and published supplementary resources cited in the manuscript. In particular, the study uses public adult-human heart-failure transcriptomic resources, GEO accession GSE226314 for the recovery audit, GEO accession GSE276161 for the K4 perturbation resource, the published rare predicted loss-of-function gene-burden results used for E4, and source data accompanying the cited K2 and K3 perturbation studies.

Raw third-party biological data are not redistributed here where the original study or repository is the authoritative source.

## Files included directly in GitHub

The repository contains:
- scripts that regenerate the three main manuscript figures from frozen numerical source data;
- frozen numerical source-data tables for the three main figures;
- the retained primary target-level out-of-fold audit script;
- citation, software-environment, and licensing metadata.

## Reproducibility boundary

The historical project did not retain every upstream source-reconstruction script as a clean standalone workflow. In addition, the larger frozen target-level tables required by `scripts/01_primary_oof_reproduction.R` are not currently distributed in this GitHub repository. The retained script documents the exact target-level model-refitting and audit logic, while the included source-data tables support regeneration of the publication figures.

Accordingly, this repository does **not** claim complete reconstruction from raw public downloads or a complete public target-level reproduction bundle.

## Persistent archive status

A Zenodo DOI previously listed in draft documentation was checked during final manuscript preparation and found to resolve to an unrelated record. That DOI has therefore been removed and must not be cited as the archive for this project.

Before a manuscript claims a complete public target-level reproduction archive, the retained larger target-level tables should be deposited in a verified project-specific persistent repository and the resulting DOI should be checked directly.
