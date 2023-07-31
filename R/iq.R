

# Installation Qualification ----------------------------------------------



#' @title Performs Installation Qualification
#' @description The \code{run_iq} function executes an
#' installation qualification (IQ)
#' on the currently installed \strong{sassy} packages, and generates a report
#' on the results. The IQ ensures that the files in the \strong{sassy} packages
#' are correct, and have not been altered.
#' The results of the IQ will be placed in the supplied location.
#' @param location The path to the desired output directory.  The IQ
#' reports and any associated files will be placed in this directory.
#' @return The path to the output directory.
#' @examples
#' # Create a temp directory
#' tmp <- tempdir()
#'
#' # Run the Installation Qualification
#' run_iq(tmp)
#' @export
run_iq <- function(location) {

  if (!dir.exists(location)) {
    dir.create(opth, recursive = TRUE)
  }

  # Create needed folders
  opth <- file.path(location, "output")
  if (!dir.exists(opth))
    dir.create(opth)

  lpth <- file.path(location, "log")
  if (!dir.exists(lpth))
    dir.create(lpth)

  # Initialize output data frame
  ret <- data.frame(Category = "sassy",
                    Description = "System Initialization",
                    Pass = TRUE,
                    Message = "",
                    stringsAsFactors = FALSE)


  # Check that all sassy packages exist
  ret <- rbind(ret, check_packages())

  # Checks for logr package
  ret <- rbind(ret, check_logr(opth))

  # Now that log is tested and packages exist, create run log
  lg <- log_open(file.path(lpth, "runIQ.log"), logdir = FALSE,
                 show_notes = FALSE, autolog = TRUE)

  sep("Initialization results")
  put(ret)

  if (all(ret$Pass == TRUE)) {

    sep("Package File Examination")

    sep("Examine common package")
    ret <- rbind(ret, examine_common())

    sep("Examine fmtr package")
    ret <- rbind(ret, examine_fmtr())

    sep("Examine libr package")
    ret <- rbind(ret, examine_libr())

    sep("Examine reporter package")
    ret <- rbind(ret, examine_reporter())

    sep("Examine procs package")
    ret <- rbind(ret, examine_procs())

  } else {

    put("IQ run stopped due to initalization failure.")
  }

  sep("Preparing Report")

  put("Complete Results: ")
  put(ret)

  # Print report
  ttls <-   c("Installation Qualification Results Report",
              "SASSY System")

  pth <- file.path(location, "sassyIQ-" %p% Sys.Date())

  put("Printing report")
  put("Report path: " %p% pth)
  res <- print_report(pth, ret, ttls)

  view_report(ret, ttls)

  log_close()

  return(res)


}



# IQ Checksums ------------------------------------------------------------

common_ck <- list("1.0.8" = "eaaf045fd6a752e01e6233c63f48cb4a")

fmtr_ck <- list("1.5.9" = "300deb40502efff0239d0ef731f4171b")

logr_ck <- list("1.3.4" = "efbe075f699490aec2556a8be7c6913b")

libr_ck <- list("1.2.8" = "c30e6df3b5774b1992376284b1a02a6f")

reporter_ck <- list("1.4.1" = "2e20b4a9614f6027e03e4044d073a96a")

procs_ck <- list("1.0.0" = "9c421179d6dd05290f0fa7aaf4b159bc")


# IQ Subroutines ----------------------------------------------------------


check_sum <- function(pkg, ver, pth) {

  ret <- FALSE

  if (pkg == "common") {

    if (common_ck[[ver]] == md5sum(pth))
      ret <- TRUE

  } else if (pkg == "logr") {

    if (logr_ck[[ver]] == md5sum(pth))
      ret <- TRUE

  } else if (pkg == "fmtr") {

    if (fmtr_ck[[ver]] == md5sum(pth))
      ret <- TRUE

  } else if (pkg == "libr") {

    if (libr_ck[[ver]] == md5sum(pth))
      ret <- TRUE


  } else if (pkg == "reporter") {

    if (reporter_ck[[ver]] == md5sum(pth))
      ret <- TRUE

  } else if (pkg == "procs") {

    if (procs_ck[[ver]] == md5sum(pth))
      ret <- TRUE

  }


  return(ret)
}


#' @import tools
#' @import utils
examine_common <- function() {

  ver <- as.character(packageVersion("common"))

  pth <- file.path(.libPaths()[1], "common/R/common.rdb")


  tmplt <- data.frame(Category = "common",
                      Description = "Common source code found.",
                      Pass = TRUE,
                      Message = "",
                      stringsAsFactors = FALSE)

  tmp <- tmplt
  if (!file.exists(pth)) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "Common source code not found."
    put("Common source code not found.")
  } else {
    put("Common source code found.")
  }


  ret <- tmp

  tmp <- tmplt
  tmp[1, "Description"] <- "Examine common source code checksum."
  if (check_sum("common", ver, pth) == FALSE) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "Checksum does not match expected value."
    put("Common source code checksum failed.")
  } else {
    put("Common source code checksum passed.")
  }

  ret <- rbind(ret, tmp)


  return(ret)
}


#' @import tools
#' @import utils
examine_logr <- function() {

  ver <- as.character(packageVersion("logr"))

  pth <- file.path(.libPaths()[1], "logr/R/logr.rdb")


  tmplt <- data.frame(Category = "logr",
                      Description = "logr source code found.",
                      Pass = TRUE,
                      Message = "",
                      stringsAsFactors = FALSE)

  tmp <- tmplt
  if (!file.exists(pth)) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "logr source code not found."
    put("Logr source code not found.")
  } else {
    put("Logr source code found.")
  }

  ret <- tmp

  tmp <- tmplt
  tmp[1, "Description"] <- "Examine logr source code checksum."
  if (check_sum("logr", ver, pth) == FALSE) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "Checksum does not match expected value."
    put("Logr source code checksum failed.")
  } else {
    put("Logr source code checksum passed.")
  }

  ret <- rbind(ret, tmp)


  return(ret)

}

#' @import tools
#' @import utils
examine_fmtr <- function() {

  ver <- as.character(packageVersion("fmtr"))

  pth <- file.path(.libPaths()[1], "fmtr/R/fmtr.rdb")


  tmplt <- data.frame(Category = "fmtr",
                      Description = "fmtr source code found.",
                      Pass = TRUE,
                      Message = "",
                      stringsAsFactors = FALSE)

  tmp <- tmplt
  if (!file.exists(pth)) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "fmtr source code not found."
    put("Fmtr source code not found.")
  } else {
    put("Fmtr source code found.")
  }

  ret <- tmp

  tmp <- tmplt
  tmp[1, "Description"] <- "Examine fmtr source code checksum."
  if (check_sum("fmtr", ver, pth) == FALSE) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "Checksum does not match expected value."
    put("Fmtr source code checksum failed.")
  } else {
    put("Fmtr source code checksum passed.")
  }

  ret <- rbind(ret, tmp)


  return(ret)

}


#' @import tools
#' @import utils
examine_libr <- function() {

  ver <- as.character(packageVersion("libr"))

  pth <- file.path(.libPaths()[1], "libr/R/libr.rdb")


  tmplt <- data.frame(Category = "libr",
                      Description = "libr source code found.",
                      Pass = TRUE,
                      Message = "",
                      stringsAsFactors = FALSE)

  tmp <- tmplt
  if (!file.exists(pth)) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "libr source code not found."
    put("Libr source code not found.")
  } else {
    put("Libr source code found.")
  }

  ret <- tmp

  tmp <- tmplt
  tmp[1, "Description"] <- "Examine libr source code checksum."
  if (check_sum("libr", ver, pth) == FALSE) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "Checksum does not match expected value."
    put("Libr source code checksum failed.")
  } else {
    put("Libr source code checksum passed.")
  }

  ret <- rbind(ret, tmp)


  return(ret)

}


#' @import tools
#' @import utils
examine_reporter <- function() {

  ver <- as.character(packageVersion("reporter"))

  pth <- file.path(.libPaths()[1], "reporter/R/reporter.rdb")


  tmplt <- data.frame(Category = "reporter",
                      Description = "reporter source code found.",
                      Pass = TRUE,
                      Message = "",
                      stringsAsFactors = FALSE)

  tmp <- tmplt
  if (!file.exists(pth)) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "reporter source code not found."
    put("Reporter source code not found.")
  } else {
    put("Reporter source code found.")
  }

  ret <- tmp

  tmp <- tmplt
  tmp[1, "Description"] <- "Examine reporter source code checksum."
  if (check_sum("reporter", ver, pth) == FALSE) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "Checksum does not match expected value."
    put("Reporter source code checksum failed.")
  } else {
    put("Reporter source code checksum passed.")
  }

  ret <- rbind(ret, tmp)


  return(ret)

}

#' @import tools
#' @import utils
examine_procs <- function() {

  ver <- as.character(packageVersion("procs"))

  pth <- file.path(.libPaths()[1], "procs/R/procs.rdb")


  tmplt <- data.frame(Category = "procs",
                      Description = "procs source code found.",
                      Pass = TRUE,
                      Message = "",
                      stringsAsFactors = FALSE)

  tmp <- tmplt
  if (!file.exists(pth)) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "procs source code not found."
    put("Procs source code not found.")
  } else {
    put("Procs source code found.")
  }

  ret <- tmp

  tmp <- tmplt
  tmp[1, "Description"] <- "Examine procs source code checksum."
  if (check_sum("procs", ver, pth) == FALSE) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- "Checksum does not match expected value."
    put("Procs source code checksum failed.")
  } else {
    put("Procs source code checksum passed.")
  }

  ret <- rbind(ret, tmp)


  return(ret)

}


