#' @title Making R more palatable to SAS® Programmers
#'
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
#'   \item {\code{\link[reporter]{reporter}}:}{ Write reports and output in text and PDF.}
#' }
#'
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
