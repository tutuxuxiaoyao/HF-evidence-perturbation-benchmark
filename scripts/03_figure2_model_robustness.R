# Regenerate main Figure 2 from frozen robustness source data
# No biological analysis is rerun.

options(stringsAsFactors = FALSE)
req <- c("ggplot2", "dplyr", "patchwork")
miss <- req[!vapply(req, requireNamespace, logical(1), quietly = TRUE)]
if (length(miss)) stop("Install required packages: ", paste(miss, collapse = ", "))
library(ggplot2); library(dplyr); library(patchwork)

x <- read.delim("source_data/Figure3_source_data.tsv", check.names = FALSE)
dir.create("figures_generated", showWarnings = FALSE)

A <- x %>% filter(panel == "A", block != "JOINT") %>% mutate(spec = paste(outcome_transform, functional_form, sep = " / "))
pA <- ggplot(A, aes(estimate, spec, colour = system)) +
  geom_vline(xintercept = 0, linetype = 2) + geom_point(size = 1.8) +
  facet_wrap(~block, scales = "free_y", ncol = 1) +
  labs(title = "Fixed sensitivity landscape", x = "Delta out-of-fold R2", y = NULL) +
  theme_classic(base_size = 8) + theme(legend.position = "top")

B <- x %>% filter(panel == "B")
pB <- ggplot(B, aes(estimate, functional_form, colour = system)) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), position = position_dodge(width = 0.35), height = 0.12) +
  geom_point(position = position_dodge(width = 0.35), size = 1.8) +
  labs(title = "Joint model sensitivity", x = "Delta out-of-fold R2", y = NULL) +
  theme_classic(base_size = 8) + theme(legend.position = "top")

C <- x %>% filter(panel == "C")
pC <- ggplot(C, aes(estimate, block, colour = system)) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_errorbarh(aes(xmin = permutation_q025, xmax = permutation_q975), position = position_dodge(width = 0.35), height = 0.12) +
  geom_point(position = position_dodge(width = 0.35), size = 1.8) +
  labs(title = "Target-label permutation controls", x = "Observed delta out-of-fold R2", y = NULL) +
  theme_classic(base_size = 8) + theme(legend.position = "top")

D <- x %>% filter(panel == "D")
pD <- ggplot(D, aes(system, estimate)) + geom_point(size = 2.5) +
  ylim(0, 1.05) + labs(title = "Deliberate leakage positive control", x = NULL, y = "Recovered signal") +
  theme_classic(base_size = 8)

fig <- (pA | pB) / (pC | pD) + plot_annotation(tag_levels = "A")
ggsave("figures_generated/Figure2_model_robustness.pdf", fig, width = 7.2, height = 6.0)
ggsave("figures_generated/Figure2_model_robustness.png", fig, width = 7.2, height = 6.0, dpi = 300)
