# Regenerate main Figure 1 from frozen source data
# No biological analysis is rerun.

options(stringsAsFactors = FALSE)
req <- c("ggplot2", "dplyr", "patchwork")
miss <- req[!vapply(req, requireNamespace, logical(1), quietly = TRUE)]
if (length(miss)) stop("Install required packages: ", paste(miss, collapse = ", "))
library(ggplot2); library(dplyr); library(patchwork)

x <- read.delim("source_data/Figure2_source_data_v2.tsv", check.names = FALSE)
dir.create("figures_generated", showWarnings = FALSE)

A <- x %>% filter(panel == "A")
pA <- ggplot(A, aes(block, N, fill = system)) +
  geom_col(position = "dodge") +
  scale_y_log10() +
  labs(title = "Evaluated targets", x = NULL, y = "Targets (log scale)") +
  theme_classic(base_size = 9) + theme(legend.position = "top")

B <- x %>% filter(panel == "B")
pB <- ggplot(B, aes(estimate, system)) +
  geom_vline(xintercept = 0, linetype = 2) + geom_point(size = 2) +
  labs(title = "Direct E1 association", x = "Spearman rho", y = NULL) +
  theme_classic(base_size = 9)

C <- x %>% filter(panel == "C")
pC <- ggplot(C, aes(estimate, system)) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), height = 0.12) + geom_point(size = 2) +
  labs(title = "Baseline E1 OOS validity", x = "Out-of-fold R2", y = NULL) +
  theme_classic(base_size = 9)

D <- x %>% filter(panel == "D")
pD <- ggplot(D, aes(estimate, block, colour = system)) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), position = position_dodge(width = 0.35), height = 0.12) +
  geom_point(position = position_dodge(width = 0.35), size = 2) +
  labs(title = "Incremental validity beyond E1", x = "Delta out-of-fold R2", y = NULL) +
  theme_classic(base_size = 9) + theme(legend.position = "top")

E <- x %>% filter(panel == "E")
pE <- ggplot(E, aes(estimate, block)) + geom_point(size = 2.5) +
  geom_vline(xintercept = 2, linetype = 2) + scale_x_continuous(breaks = 0:3, limits = c(0,3)) +
  labs(title = "Cross-system gate", x = "Positive systems (n of 3)", y = NULL) +
  theme_classic(base_size = 9)

fig <- (pA | pB | pC) / (pD | pE) + plot_annotation(tag_levels = "A")
ggsave("figures_generated/Figure1_primary_validity.pdf", fig, width = 7.2, height = 5.2)
ggsave("figures_generated/Figure1_primary_validity.png", fig, width = 7.2, height = 5.2, dpi = 300)
