# # Required packages
# library(dplyr)
# library(tidyr)
# library(forcats)
# library(ggplot2)
# library(patchwork)
#
# #--- Inputs (rename these to match your data) ---------------------------------
# # vitals must have:
# #   AVISIT  = visit label (e.g., "Baseline", "Month 6", ...)
# #   ARM     = treatment arm (e.g., "Drug Name Dosage A", "Control")
# #   AVAL    = systolic blood pressure (mmHg)
# # Optional (recommended): USUBJID for distinct-subject counts
# #
# # vitals <- your_data
#
# pkg <- system.file("extdata", package = "sassy")
#
# library(libr)
#
# libname(dat, pkg, "csv")
#
# vitals <- dat$VS
#
# visit_levels <- c(
#   "Baseline","Month 6","Month 12","Month 18","Month 24","Month 30",
#   "Month 36","Month 42","Month 48","Month 54","Month 60"
# )
#
# arm_levels <- c("Drug Name Dosage A", "Control")
#
# vitals2 <- vitals %>%
#   dplyr::mutate(
#     AVISIT = factor(AVISIT, levels = visit_levels),
#     ARM    = factor(ARM,    levels = arm_levels)
#   )
#
# #--- Summary blocks used for the tables --------------------------------------
# summ <- vitals2 %>%
#   dplyr::filter(!is.na(AVISIT), !is.na(ARM), !is.na(AVAL)) %>%
#   dplyr::group_by(ARM, AVISIT) %>%
#   dplyr::summarise(
#     Mean = mean(AVAL, na.rm = TRUE),
#     N    = dplyr::if_else("USUBJID" %in% names(dplyr::cur_data_all()),
#                           dplyr::n_distinct(USUBJID),
#                           dplyr::n()),
#     .groups = "drop"
#   )
#
# # Colors to mimic the example
# arm_cols <- c("Drug Name Dosage A" = "#1f77b4", "Control" = "#2f2f2f")
#
# #--- Main boxplot -------------------------------------------------------------
# p_box <- ggplot2::ggplot(
#   vitals2,
#   ggplot2::aes(x = AVISIT, y = AVAL, fill = ARM, colour = ARM)
# ) +
#   ggplot2::geom_boxplot(
#     position = ggplot2::position_dodge(width = 0.75),
#     width = 0.6,
#     outlier.size = 0.7,
#     alpha = 0.9
#   ) +
#   ggplot2::scale_fill_manual(values = arm_cols) +
#   ggplot2::scale_colour_manual(values = arm_cols) +
#   ggplot2::labs(
#     title = "Figure 10. Box Plot: Median and Interquartile Range of Vital Sign Data Over Time by Treatment Arm, Safety Population, Pooled Analysis (or Trial X)",
#     x = NULL,
#     y = "Systolic Blood Pressure (mmHg)",
#     fill = NULL,
#     colour = NULL,
#     caption = paste(
#       "Source: [include Applicant source, datasets and/or software tools used].",
#       "Note: Boxes span the interquartile range (25th to 75th percentile); horizontal line = median;",
#       "whiskers = 1.5×IQR; individual outliers are those beyond this range.",
#       sep = "\n"
#     )
#   ) +
#   ggplot2::theme_bw(base_size = 10) +
#   ggplot2::theme(
#     legend.position = "bottom",
#     panel.grid.major.x = ggplot2::element_blank(),
#     plot.title = ggplot2::element_text(face = "bold", hjust = 0),
#     plot.caption = ggplot2::element_text(hjust = 0)
#   )
#
# #--- Helper to draw the “tables” under the plot ------------------------------
# make_table_plot <- function(df, value_col, title_text) {
#   df2 <- df %>%
#     dplyr::mutate(
#       ARM = forcats::fct_rev(ARM), # show Drug row above Control like the example
#       label = dplyr::case_when(
#         value_col == "Mean" ~ sprintf("%d", round(.data[[value_col]])),
#         TRUE ~ sprintf("%d", .data[[value_col]])
#       )
#     )
#
#   ggplot2::ggplot(df2, ggplot2::aes(x = AVISIT, y = ARM)) +
#     ggplot2::geom_tile(fill = "white", colour = "grey60", linewidth = 0.4) +
#     ggplot2::geom_text(
#       ggplot2::aes(label = label, colour = forcats::fct_rev(ARM)),
#       size = 3
#     ) +
#     ggplot2::scale_colour_manual(values = arm_cols) +
#     ggplot2::scale_x_discrete(drop = FALSE) +
#     ggplot2::labs(title = title_text, x = NULL, y = NULL) +
#     ggplot2::theme_void(base_size = 10) +
#     ggplot2::theme(
#       legend.position = "none",
#       plot.title = ggplot2::element_text(face = "bold", hjust = 0),
#       axis.text.y = ggplot2::element_text(colour = "black"),
#       plot.margin = ggplot2::margin(t = 2, r = 8, b = 2, l = 8)
#     )
# }
#
# p_mean <- make_table_plot(summ, "Mean", "Mean Value")
# p_n    <- make_table_plot(summ, "N",    "Number of Subjects with Data")
#
# #--- Stack them (aligned x) and keep one legend ------------------------------
# final_plot <-
#   p_box / p_mean / p_n +
#   patchwork::plot_layout(heights = c(6.5, 1.2, 1.4), guides = "collect") &
#   ggplot2::theme(legend.position = "bottom")
#
# final_plot
