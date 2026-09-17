# Regenerate main Figure 3 from frozen structural/source robustness data
# No biological analysis is rerun.

options(stringsAsFactors = FALSE)
req <- c("ggplot2", "dplyr", "patchwork")
miss <- req[!vapply(req, requireNamespace, logical(1), quietly = TRUE)]
if (length(miss)) stop("Install required packages: ", paste(miss, collapse = ", "))
library(ggplot2); library(dplyr); library(patchwork)

x <- read.delim("source_data/Figure4_source_data.tsv", check.names = FALSE)
dir.create("figures_generated", showWarnings = FALSE)

forest_panel <- function(dat, ttl) {
  ggplot(dat, aes(estimate, label, colour = system)) +
    geom_vline(xintercept = 0, linetype = 2) +
    geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), position = position_dodge(width = 0.35), height = 0.12) +
    geom_point(position = position_dodge(width = 0.35), size = 1.8) +
    labs(title = ttl, x = "Delta out-of-fold R2", y = NULL) +
    theme_classic(base_size = 8) + theme(legend.position = "top")
}

pA <- forest_panel(x %>% filter(panel == "A"), "Family-blocked validation")
pB <- forest_panel(x %>% filter(panel == "B"), "Complex-blocked validation")

C <- x %>% filter(panel == "C")
pC <- ggplot(C, aes(system, label, fill = estimate)) +
  geom_tile(colour = "white") + geom_text(aes(label = sprintf("%+.3f", estimate)), size = 2.2) +
  scale_fill_gradient2(midpoint = 0) +
  labs(title = "Leave-one-HF-source-out sensitivity", x = NULL, y = NULL, fill = "Delta R2") +
  theme_minimal(base_size = 7) + theme(panel.grid = element_blank())

D <- x %>% filter(panel == "D")
pD <- ggplot(D, aes(estimate, system)) +
  geom_vline(xintercept = 0, linetype = 2) +
  geom_errorbarh(aes(xmin = CI_low, xmax = CI_high), height = 0.12) + geom_point(size = 2) +
  labs(title = "HF-label permutation E1 control", x = "Observed E1 out-of-fold R2", y = NULL) +
  theme_classic(base_size = 8)

E <- x %>% filter(panel == "E")
pE <- ggplot(E, aes(estimate, label)) + geom_point(size = 2.5) +
  scale_x_continuous(limits = c(0,3), breaks = 0:3) +
  labs(title = "Final robustness summary", x = "Cross-system signals retained", y = NULL) +
  theme_classic(base_size = 8)

fig <- (pA | pB) / (pC | (pD / pE)) + plot_annotation(tag_levels = "A")
ggsave("figures_generated/Figure3_structural_robustness.pdf", fig, width = 7.2, height = 6.1)
ggsave("figures_generated/Figure3_structural_robustness.png", fig, width = 7.2, height = 6.1, dpi = 300)
