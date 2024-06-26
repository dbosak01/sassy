#' @title sassy: Making R Easier for Everyone
#' @encoding UTF-8
#' @description The \strong{sassy} package is a meta-package that
#' installs a set of functions that aim to make R easier for everyone,
#' especially programmers
#' whose primary experience is with SAS® software.
#' These functions provide the ability to create
#' data libraries, format catalogs, data dictionaries, a traceable log, and
#' includes reporting capabilities reminiscent of those found in SAS®.
#' These packages were written independently, and the authors have no association
#' with, approval of, or endorsement by SAS® Institute.
#'
#' @section Packages Included:
#' The packages included in the \strong{sassy} meta-package are
#' as follows:
#' \itemize{
#'   \item {\code{\link[libr]{libr}}: Define a libname, view
#'   data dictionaries, and simulate a data step.}
#'   \item {\code{\link[fmtr]{fmtr}}: Create a format catalog
#' and apply formats to a data frame or vector.}
#'   \item {\code{\link[logr]{logr}}: Generate a traceable log.}
#'   \item {\code{\link[reporter]{reporter}}: Write reports and output
#'   in TXT, RTF, PDF, HTML, and DOCX.}
#'   \item {\code{\link[common]{common}}: A set of utility functions
#'   shared across the \strong{sassy} family of packages.}
#'   \item {\code{\link[procs]{procs}}: A package to simulate frequently used SAS® procedures.}
#' }
#' @examples
#' #########################################################
#' #####         Example: Simple Data Listing          #####
#' #########################################################
#' library(sassy)
#' library(magrittr)
#'
#' options("logr.notes" = FALSE)
#'
#' # Get path to temp directory
#' tmp <- tempdir()
#'
#' # Get path to sample data
#' pkg <- system.file("extdata", package = "sassy")
#'
#' # Open log
#' lgpth <- log_open(file.path(tmp, "example1.log"))
#'
#' sep("Get Data")
#'
#' # Define data library
#' libname(sdtm, pkg, "csv") %>% put()
#'
#' sep("Write Report")
#'
#' # Define table object
#' tbl <- create_table(sdtm$DM) %>%
#'   define(USUBJID, id_var = TRUE)
#'
#' # Construct report path
#' pth <- file.path(tmp, "output/l_dm.rtf") %>% put()
#'
#' # Define report object
#' rpt <- create_report(pth, output_type = "RTF", font = "Courier") %>%
#'   page_header("Sponsor: Company", "Study: ABC") %>%
#'   titles("Listing 1.0", "SDTM Demographics") %>%
#'   add_content(tbl, align = "left") %>%
#'   page_footer(Sys.time(), "CONFIDENTIAL", "Page [pg] of [tpg]")
#'
#' # Write report to file system
#' write_report(rpt) %>% put()
#'
#' # Close log
#' log_close()
#'
#' # View report
#' # file.show(pth)
#'
#' # View log
#' # file.show(lgpth)
#' @keywords internal
#' @name sassy
#' @aliases sassy-package
#' @import fmtr
#' @import common
#' @import logr
#' @import libr
#' @import reporter
#' @import procs
"_PACKAGE"



.onAttach <- function(...) {

  do.call("library", list("fmtr"))
  do.call("library", list("common"))
  do.call("library", list("logr"))
  do.call("library", list("libr"))
  do.call("library", list("reporter"))
  do.call("library", list("procs"))

}







