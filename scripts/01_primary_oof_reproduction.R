# ============================================================
# JYF FINAL PRIMARY REPRODUCTION AUDIT
# 目的：
#   1) 不下载任何数据，不读取 01_raw_data / cardiac_public_data；
#   2) 只使用已经冻结的 target-level OOF 表；
#   3) 从 fold + predictors + Y 重新拟合 E1/E2、E4、corrected E5；
#   4) 核对重新拟合的 OOF prediction 是否与现有最终文件逐点一致；
#   5) 核对论文主结果对应的 R2 / delta R2 / Spearman；
#   6) 不覆盖任何原始结果，只生成一个审计目录和 ZIP。
#
# 输出：
#   F:/JYF/JYF生信计算/03_results/FINAL_PRIMARY_REPRO_AUDIT/
#   F:/JYF/JYF生信计算/00_FINAL_PRIMARY_REPRO_AUDIT.zip
#
# 依赖：仅 base R
# ============================================================

options(stringsAsFactors = FALSE, warn = 1)

ROOT <- normalizePath(".", winslash = "/", mustWork = TRUE)
if (!dir.exists(ROOT)) stop("找不到项目根目录：", ROOT)
setwd(ROOT)

OUTDIR <- file.path(ROOT, "reproduction_audit")
ZIPFILE <- file.path(ROOT, "reproduction_audit.zip")

if (dir.exists(OUTDIR)) unlink(OUTDIR, recursive = TRUE, force = TRUE)
dir.create(OUTDIR, recursive = TRUE, showWarnings = FALSE)
if (file.exists(ZIPFILE)) file.remove(ZIPFILE)

must_exist <- function(path) {
  full <- file.path(ROOT, path)
  if (!file.exists(full)) stop("缺少文件：", full)
  full
}

read_tsv <- function(path) {
  read.delim(must_exist(path), check.names = FALSE, stringsAsFactors = FALSE)
}

oof_r2 <- function(y, pred) {
  y <- as.numeric(y); pred <- as.numeric(pred)
  1 - sum((y - pred)^2) / sum((y - mean(y))^2)
}

safe_spearman <- function(x, y) {
  suppressWarnings(cor(as.numeric(x), as.numeric(y), method = "spearman", use = "complete.obs"))
}

fit_oof_linear <- function(dat, predictors) {
  req <- c("Y", "fold", predictors)
  miss <- setdiff(req, names(dat))
  if (length(miss)) stop("fit_oof_linear 缺少列：", paste(miss, collapse = ", "))
  pred <- rep(NA_real_, nrow(dat))
  folds <- sort(unique(dat$fold))
  for (f in folds) {
    i_test <- dat$fold == f; i_train <- !i_test
    Xtr <- as.matrix(dat[i_train, predictors, drop = FALSE])
    Xte <- as.matrix(dat[i_test, predictors, drop = FALSE])
    ytr <- as.numeric(dat$Y[i_train])
    storage.mode(Xtr) <- "double"; storage.mode(Xte) <- "double"
    mu <- colMeans(Xtr); s <- apply(Xtr, 2, sd)
    s[!is.finite(s) | s == 0] <- 1
    Xtr_z <- sweep(sweep(Xtr, 2, mu, "-"), 2, s, "/")
    Xte_z <- sweep(sweep(Xte, 2, mu, "-"), 2, s, "/")
    fit <- lm.fit(x = cbind("(Intercept)" = 1, Xtr_z), y = ytr)
    b <- fit$coefficients
    if (anyNA(b)) stop("出现 rank-deficient primary linear fit；fold=", f, "；predictors=", paste(predictors, collapse = ", "))
    pred[i_test] <- as.vector(cbind("(Intercept)" = 1, Xte_z) %*% b)
  }
  pred
}

audit_one <- function(analysis, system, dat, baseline_predictors, block_predictors, stored_baseline_col, stored_block_col) {
  p0 <- fit_oof_linear(dat, baseline_predictors)
  p1 <- fit_oof_linear(dat, block_predictors)
  stored0 <- as.numeric(dat[[stored_baseline_col]])
  stored1 <- as.numeric(dat[[stored_block_col]])
  maxdiff0 <- max(abs(p0 - stored0), na.rm = TRUE)
  maxdiff1 <- max(abs(p1 - stored1), na.rm = TRUE)
  data.frame(
    analysis = analysis, system = system, N = nrow(dat),
    max_abs_diff_baseline_prediction = maxdiff0,
    max_abs_diff_block_prediction = maxdiff1,
    direct_E1_Spearman = safe_spearman(dat$E1_HF_strength, dat$Y),
    OOF_R2_baseline = oof_r2(dat$Y, p0), OOF_R2_block = oof_r2(dat$Y, p1),
    delta_OOF_R2 = oof_r2(dat$Y, p1) - oof_r2(dat$Y, p0),
    OOF_rho_baseline = safe_spearman(dat$Y, p0), OOF_rho_block = safe_spearman(dat$Y, p1),
    prediction_reproduction_pass = maxdiff0 < 1e-10 && maxdiff1 < 1e-10,
    stringsAsFactors = FALSE
  )
}

CORE_FILES <- c(
  K2 = "03_results/Stage1B_core_benchmark_E1_E2/K2_PRIMARY_OOF_PREDICTIONS.tsv",
  K3 = "03_results/Stage1B_core_benchmark_E1_E2/K3_PRIMARY_OOF_PREDICTIONS.tsv",
  K4 = "03_results/Stage1B_core_benchmark_E1_E2/K4_CRISPRa_PRIMARY_OOF_PREDICTIONS.tsv"
)
E4_FILES <- c(
  K2 = "03_results/Stage1B_E4_genetics_frozen_plan/K2_PRIMARY_E4_OOF_FROZEN_PLAN.tsv",
  K3 = "03_results/Stage1B_E4_genetics_frozen_plan/K3_PRIMARY_E4_OOF_FROZEN_PLAN.tsv",
  K4 = "03_results/Stage1B_E4_genetics_frozen_plan/K4_CRISPRa_PRIMARY_E4_OOF_FROZEN_PLAN.tsv"
)
E5_FILES <- c(
  K2 = "03_results/Stage1B_E4_genetics_frozen_plan/K2_PRIMARY_E5_OOF_FROZEN_PLAN.tsv",
  K3 = "03_results/Stage1B_E4_genetics_frozen_plan/K3_PRIMARY_E5_OOF_FROZEN_PLAN.tsv",
  K4 = "03_results/Stage1B_E4_genetics_frozen_plan/K4_CRISPRa_PRIMARY_E5_OOF_FROZEN_PLAN.tsv"
)

audit_rows <- list()
for (s in names(CORE_FILES)) {
  d <- read_tsv(CORE_FILES[[s]])
  audit_rows[[length(audit_rows)+1L]] <- audit_one("E1_plus_E2_vs_E1", s, d,
    c("E1_HF_strength"), c("E1_HF_strength","E2_sign_concordance","E2_I2"), "pred_M0", "pred_M1")
}
for (s in names(E4_FILES)) {
  d <- read_tsv(E4_FILES[[s]])
  audit_rows[[length(audit_rows)+1L]] <- audit_one("E1_plus_E4_vs_E1", s, d,
    c("E1_HF_strength"), c("E1_HF_strength","E4_pLoF_strength"), "p_E1", "p_block")
}
for (s in names(E5_FILES)) {
  d <- read_tsv(E5_FILES[[s]])
  audit_rows[[length(audit_rows)+1L]] <- audit_one("E1_plus_corrected_E5_vs_E1", s, d,
    c("E1_HF_strength"), c("E1_HF_strength","E5_CM_specificity_mean","E5_CM_specificity_consistency"), "p_E1", "p_block")
}
AUDIT <- do.call(rbind, audit_rows)
write.table(AUDIT, file.path(OUTDIR, "PRIMARY_OOF_REPRODUCTION_AUDIT.tsv"), sep="\t", quote=FALSE, row.names=FALSE)

core_obs <- read_tsv("03_results/Stage1B_core_benchmark_E1_E2/CORE_BENCHMARK_OBSERVED_METRICS.tsv")
e4_obs <- read_tsv("03_results/Stage1B_E4_genetics_frozen_plan/E4_BENCHMARK_OBSERVED.tsv")
e5_obs <- read_tsv("03_results/Stage1B_E4_genetics_frozen_plan/E5_CORRECTED_BENCHMARK_OBSERVED.tsv")
system_map <- c(K2_PRIMARY="K2", K3_PRIMARY="K3", K4_CRISPRa_PRIMARY="K4")
compare_rows <- list()
for (i in seq_len(nrow(core_obs))) {
  if (!core_obs$system[i] %in% names(system_map)) next
  s <- unname(system_map[core_obs$system[i]])
  a <- AUDIT[AUDIT$analysis=="E1_plus_E2_vs_E1" & AUDIT$system==s,,drop=FALSE]
  compare_rows[[length(compare_rows)+1L]] <- data.frame(block="E2",system=s,reported_delta_R2=core_obs$OOF_delta_R2[i],recomputed_delta_R2=a$delta_OOF_R2,abs_difference=abs(core_obs$OOF_delta_R2[i]-a$delta_OOF_R2),pass=abs(core_obs$OOF_delta_R2[i]-a$delta_OOF_R2)<1e-10)
}
for (i in seq_len(nrow(e4_obs))) {
  if (!e4_obs$system[i] %in% names(system_map)) next
  s <- unname(system_map[e4_obs$system[i]])
  a <- AUDIT[AUDIT$analysis=="E1_plus_E4_vs_E1" & AUDIT$system==s,,drop=FALSE]
  compare_rows[[length(compare_rows)+1L]] <- data.frame(block="E4",system=s,reported_delta_R2=e4_obs$OOF_delta_R2_vs_E1[i],recomputed_delta_R2=a$delta_OOF_R2,abs_difference=abs(e4_obs$OOF_delta_R2_vs_E1[i]-a$delta_OOF_R2),pass=abs(e4_obs$OOF_delta_R2_vs_E1[i]-a$delta_OOF_R2)<1e-10)
}
for (i in seq_len(nrow(e5_obs))) {
  if (!e5_obs$system[i] %in% names(system_map)) next
  s <- unname(system_map[e5_obs$system[i]])
  a <- AUDIT[AUDIT$analysis=="E1_plus_corrected_E5_vs_E1" & AUDIT$system==s,,drop=FALSE]
  compare_rows[[length(compare_rows)+1L]] <- data.frame(block="E5_corrected",system=s,reported_delta_R2=e5_obs$OOF_delta_R2_vs_E1[i],recomputed_delta_R2=a$delta_OOF_R2,abs_difference=abs(e5_obs$OOF_delta_R2_vs_E1[i]-a$delta_OOF_R2),pass=abs(e5_obs$OOF_delta_R2_vs_E1[i]-a$delta_OOF_R2)<1e-10)
}
COMPARE <- do.call(rbind, compare_rows)
write.table(COMPARE, file.path(OUTDIR, "REPORTED_VS_RECOMPUTED_PRIMARY_DELTA_R2.tsv"), sep="\t", quote=FALSE, row.names=FALSE)

OLD_E5_OBS <- file.path(ROOT,"03_results/Stage1B_E3_resolve_E5_benchmark/E5_BENCHMARK_OBSERVED.tsv")
NEW_E5_OBS <- file.path(ROOT,"03_results/Stage1B_E4_genetics_frozen_plan/E5_CORRECTED_BENCHMARK_OBSERVED.tsv")
e5_status <- data.frame(
  path=c("03_results/Stage1B_E3_resolve_E5_benchmark/E5_BENCHMARK_OBSERVED.tsv","03_results/Stage1B_E4_genetics_frozen_plan/E5_CORRECTED_BENCHMARK_OBSERVED.tsv"),
  role=c("OBSOLETE_FOR_PRIMARY: initial E5 comparator was E1+E2","CANONICAL_FINAL: corrected block-wise comparator is E1"),
  exists=c(file.exists(OLD_E5_OBS),file.exists(NEW_E5_OBS)), stringsAsFactors=FALSE)
write.table(e5_status,file.path(OUTDIR,"E5_CANONICAL_FILE_STATUS.tsv"),sep="\t",quote=FALSE,row.names=FALSE)

all_pred_pass <- all(AUDIT$prediction_reproduction_pass)
all_metric_pass <- all(COMPARE$pass)
note <- c(
  "FINAL PRIMARY REPRODUCTION AUDIT", paste0("Generated: ",Sys.time()), "",
  "No raw biological data were read.", "No public data were downloaded.", "No existing result file was overwritten.", "",
  paste0("Exact OOF prediction reproduction: ",if(all_pred_pass) "PASS" else "FAIL"),
  paste0("Reported primary delta-R2 reproduction: ",if(all_metric_pass) "PASS" else "FAIL"), "",
  "Canonical primary E5 files are the corrected E5 files under:", "03_results/Stage1B_E4_genetics_frozen_plan/", "",
  "The older E5 results under:", "03_results/Stage1B_E3_resolve_E5_benchmark/",
  "used E1+E2 as the comparator and must not be used as the final primary E5 result.", "",
  "This audit reproduces the primary target-level OOF model fitting from frozen target-level tables.",
  "It does not reconstruct upstream pseudobulk creation or external source parsing from raw data.")
writeLines(note,file.path(OUTDIR,"README_PRIMARY_REPRO_AUDIT.txt"),useBytes=TRUE)

script_path <- tryCatch(normalizePath(sys.frames()[[1]]$ofile,winslash="/",mustWork=TRUE),error=function(e) NA_character_)
if (is.character(script_path) && length(script_path)==1L && !is.na(script_path) && file.exists(script_path)) {
  file.copy(script_path,file.path(OUTDIR,"04_final_primary_reproduction_audit.R"),overwrite=TRUE)
}

oldwd <- getwd(); setwd(OUTDIR); on.exit(setwd(oldwd),add=TRUE)
zip_items <- list.files(".",recursive=TRUE,full.names=FALSE,all.files=FALSE,no..=TRUE)
zip_ok <- FALSE
try({ utils::zip(zipfile=ZIPFILE,files=zip_items); zip_ok <- file.exists(ZIPFILE) },silent=TRUE)
if (!zip_ok) {
  setwd(ROOT)
  ps_dir <- gsub("'","''",OUTDIR); ps_zip <- gsub("'","''",ZIPFILE)
  cmd <- paste0("Compress-Archive -Force -Path '",ps_dir,"/*' -DestinationPath '",ps_zip,"'")
  suppressWarnings(system2("powershell",args=c("-NoProfile","-Command",shQuote(cmd)),stdout=FALSE,stderr=FALSE))
  zip_ok <- file.exists(ZIPFILE)
}
if (!zip_ok) stop("审计已完成，但 ZIP 创建失败。结果目录：",OUTDIR)
cat("\n完成。\n")
cat("Primary OOF prediction reproduction: ",if(all_pred_pass) "PASS" else "FAIL","\n",sep="")
cat("Reported delta-R2 reproduction: ",if(all_metric_pass) "PASS" else "FAIL","\n",sep="")
cat("输出：",ZIPFILE,"\n",sep="")
