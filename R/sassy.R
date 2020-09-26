#' @title A Collection of Packages Inspired by SAS®
#'
#' @description The \strong{sassy} package is a meta-package that
#' installs a set of packages
#' inspired by SAS® software.  These packages include the ability to create
#' a traceable log, create data libraries and format catalogs, and includes
#' reporting capabilities similar to those found in SAS®.  This package was
#' written independently, and the authors have no association with or
#' endorsement of SAS Institute.
#'
#' @section Packages Included:
#' The packages included in the \strong{sassy} meta-package are
#' as follows:
#' \itemize{
#'   \item {\code{\link[logr]{logr}}:}{ Write a traceable log.}
#'   \item {\code{\link[fmtr]{fmtr}}:}{ Create a format catalog
#' and apply formats to a data frame or vector.}
#'   \item {\code{\link[libr]{libr}}:}{ Define a libname and generate
#'   data dictionaries.}
#'   \item {\code{\link[rptr]{rptr}}:}{ Write reports and output in text and PDF.}
#   \item {\code{\link[sasr]{sasr}}:}{ Access the SAS® system from R.}
#' }
#'
#' @docType package
#' @name sassy
#' @import logr
#' @import fmtr
#' @import libr
#' @import rptr
NULL



.onAttach <- function(...) {

  do.call("library", list("logr"))
  do.call("library", list("fmtr"))
  do.call("library", list("libr"))
  do.call("library", list("rptr"))

}
