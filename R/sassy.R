#' @title sassy: Making R Easier for SAS® Programmers
#' @encoding UTF-8
#' @description The \strong{sassy} package is a meta-package that
#' installs a set of functions that aim to make R easier for programmers
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
#'   \item {\code{\link[libr]{libr}}:}{ Define a libname, view
#'   data dictionaries, and simulate a data step.}
#'   \item {\code{\link[fmtr]{fmtr}}:}{ Create a format catalog
#' and apply formats to a data frame or vector.}
#'   \item {\code{\link[logr]{logr}}:}{ Generate a traceable log.}
#'   \item {\code{\link[reporter]{reporter}}:}{ Write reports and output
#'   in text, RTF, and PDF.}
#' }
#'
#' @examples
#' #########################################################
#' #####         Example: Simple Data Listing          #####
#' #########################################################
#' library(sassy)
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
#' # # library 'sdtm': 10 items
#' # - attributes: csv not loaded
#' # - path: C:/Users/User/Documents/R/win-library/4.0/sassy/extdata
#' # - items:
#' #   Name Extension Rows Cols     Size        LastModified
#' # 1      AE       csv  150   27  88.1 Kb 2020-12-17 19:05:00
#' # 2      DA       csv 3587   18 527.8 Kb 2020-12-17 19:05:00
#' # 3      DM       csv   87   24  45.2 Kb 2020-12-17 19:05:00
#' # 4      DS       csv  174    9  33.7 Kb 2020-12-17 19:05:00
#' # 5      EX       csv   84   11    26 Kb 2020-12-17 19:05:00
#' # 6      IE       csv    2   14    13 Kb 2020-12-17 19:05:00
#' # 7      PE       csv 1854   17 277.9 Kb 2020-12-17 19:05:00
#' # 8  SUPPEX       csv  639   10  63.7 Kb 2020-12-17 19:05:00
#' # 9      SV       csv  685   10  69.9 Kb 2020-12-17 19:05:00
#' # 10     VS       csv 3358   17   467 Kb 2020-12-17 19:05:00
#'
#' # Load library into workspace
#' lib_load(sdtm)
#'
#' sep("Write Report")
#'
#' # Define table object
#' tbl <- create_table(sdtm.DM) %>%
#'   define(USUBJID, id_var = TRUE)
#'
#' # Construct report path
#' pth <- file.path(tmp, "output/l_dm.rtf") %>% put()
#'
#' # Define report object
#' rpt <- create_report(pth, output_type = "RTF") %>%
#'   page_header("Sponsor: Company", "Study: ABC") %>%
#'   titles("Listing 1.0", "SDTM Demographics") %>%
#'   add_content(tbl, align = "left") %>%
#'   page_footer(Sys.time(), "CONFIDENTIAL", "Page [pg] of [tpg]")
#'
#' # Write report to file system
#' write_report(rpt) %>% put()
#' # # A report specification: 9 pages
#' # - file_path: 'C:\\Users\\User\\AppData\\Local\\Temp\\RtmpsRnVcf/output/l_dm.rtf'
#' # - output_type: RTF
#' # - units: inches
#' # - orientation: landscape
#' # - line size/count: 108/48
#' # - page_header: left=Sponsor: Company right=Study: ABC
#' # - title 1: 'Listing 1.0'
#' # - title 2: 'SDTM Demographics'
#' # - page_footer: left=2020-12-13 17:27:41 center=CONFIDENTIAL right=Page [pg] of [tpg]
#' # - content:
#' # # A table specification:
#' # - data: tibble 'sdtm.DM' 87 rows 24 cols
#' # - show_cols: all
#' # - use_attributes: all
#' # - define: USUBJID id_var='TRUE'
#'
#' # Unload data
#' lib_unload(sdtm)
#'
#' # Close log
#' log_close()
#'
#' # Print log to console
#' writeLines(readLines(lgpth, encoding = "UTF-8"))
#'
#' # View report
#' # file.show(pth)
#' @docType package
#' @name sassy
#' @import logr
#' @import fmtr
#' @import libr
#' @import reporter
NULL



.onAttach <- function(...) {

  do.call("library", list("logr"))
  do.call("library", list("fmtr"))
  do.call("library", list("libr"))
  do.call("library", list("reporter"))

}
