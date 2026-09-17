# HF evidence-to-perturbation cross-system benchmark

Reproducibility archive for the manuscript:

**Cross-system benchmarking reveals limited predictive transfer from human heart failure evidence to cardiomyocyte perturbation effects**

## What this archive reproduces

This archive contains:
- frozen target-level evidence and perturbation tables used in the benchmark;
- exact target-level out-of-fold tables for E1/E2, E4, and corrected E5 analyses;
- retained robustness and permutation result tables;
- post hoc cross-system concordance and detectability-calibration outputs;
- code that re-fits the primary target-level out-of-fold models from the frozen tables and verifies the reported primary metrics;
- code that regenerates the three main publication figures from frozen result tables;
- machine-readable manifests and frozen analysis-protocol files.

The primary reproduction script was independently checked against the retained target-level tables and reproduces the primary OOF predictions and reported delta-OOF-R2 values to numerical precision.

## Quick start

From the repository root:

```r
source("scripts/01_primary_oof_reproduction.R")
```

To regenerate all three main figures as well:

```r
source("run_all.R")
```

The primary reproduction uses base R only. Figure regeneration requires the packages listed in `R_ENVIRONMENT_REQUIREMENTS.txt`.

## Directory structure

- `scripts/` - primary OOF reproduction and publication-figure scripts
- `03_results/Stage1B_core_benchmark_E1_E2/` - frozen core E1/E2 benchmark
- `03_results/Stage1B_E4_genetics_frozen_plan/` - E4 and corrected E5 benchmark files
- `03_results/Stage1B_null_robustness/` - fixed model-sensitivity and target-label controls
- `03_results/Stage1B_final_null_validation/` - structural blocking, source removal and disease-label controls
- `03_results/posthoc_calibration/` - cross-system outcome concordance and detectability calibration
- `source_data/` - numerical source data used for figures
- `manifests/` - frozen protocols and provenance manifests

## Public source data

The biological input datasets are third-party public resources cited in the manuscript. This archive intentionally does not redistribute raw controlled or third-party biological data where the original repository is the appropriate source.

## Scope of retained code

The archive provides exact primary OOF re-fitting from the frozen target-level tables and figure regeneration from frozen result tables. The historical project did not retain every upstream source-reconstruction script in a clean standalone form. To avoid fabricating provenance, this archive does not claim otherwise. Source reconstruction is documented in the manuscript Methods and frozen protocol/manifests included here.

## Repository

https://github.com/tutuxuxiaoyao/HF-evidence-perturbation-benchmark

## License

Code: MIT License. Third-party data remain subject to their original repository and study terms.
