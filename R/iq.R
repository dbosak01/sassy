

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

common_ck <- list("1.0.8" = "eaaf045fd6a752e01e6233c63f48cb4a",
                  "1.0.7" = "1ebbf9fbe0b42f6df5bb15e6bf12f229",
                  "1.0.5" = "21f1b333ec7259c6ffe41e9aeaf1391e",
                  "1.0.4" = "b1841850c492cd6d998efa788dee7cd0",
                  "1.0.3" = "b61aa170486b1b4327d0507b96c26204",
                  "1.0.1" = "9f8e73b66a0d6d2d7832788fa0c94a55")

fmtr_ck <- list("1.5.9" = "20a01e1e7cbf0003ba274253721d3c85", # "300deb40502efff0239d0ef731f4171b"
                "1.5.8" = "8d609b0585bf23dcc758d8eb4b5c3d30",
                "1.5.7" = "ff2d61b3af6b755a55a225bcd03a0755",
                "1.5.5" = "f3d5371e59bbda4626a96f10b546eaf9",
                "1.5.4" = "a44eb1f1e9b63e9a23237c545f300599",
                "1.5.3" = "25fb35e9af0726f7e453ebe9f78a1f83",
                "1.5.2" = "012a0de7a015b2376530e3dbf7ee412f",
                "1.5.1" = "3c909974a90ed47253dea996e6315e12",
                "1.5.0" = "e77283c81ffab8e03d9d2d570cc2996c")

logr_ck <- list("1.3.4" = "b51c880285dd4ab646db79ce87dcb888", # "efbe075f699490aec2556a8be7c6913b"
                "1.3.3" = "8808443fa943d1f3b09b6c9fa0f02f41",
                "1.3.2" = "7efb9daa7ac020ad58f34461b6933339",
                "1.3.1" = "d9e46ede3740524605240d450ba3e732",
                "1.3.0" = "a4da1be2f0bf4245fc139f2479178d00",
                "1.2.9" = "619b933a95d31ae27bf641bbdbc0687b",
                "1.2.8" = "5e4c6e66afeeaa10aa29fd01f88e28f8",
                "1.2.7" = "c2ef573871fb01f657d5e23936baa320",
                "1.2.6" = "07c2f979656775c763fd2dc1b5c99e74",
                "1.2.5" = "a1c9b8a5e6df93dc2472ebfdc063c5ac")

libr_ck <- list("1.2.8" = "6bec5e1d2255ba1add47f2ce326c0a2a", # "c30e6df3b5774b1992376284b1a02a6f"
                "1.2.5" = "0cef946bd42ab45bd04dd7d6e56f3ab0",
                "1.2.3" = "f5457b9953e425c93b0a11d00085ba58",
                "1.2.2" = "44c5e9c9b4d232b9ec004391294637cb",
                "1.2.1" = "2b6ecefd020a84b951ab46a40f189d94",
                "1.2.0" = "f5280880f67282ce4b3a981bca9df8f2")

reporter_ck <- list("1.4.1" = "836d7bc24cff2644b2ecb1fe02ade55a", # "2e20b4a9614f6027e03e4044d073a96a"
                    "1.3.9" = "4b96f23b7ebf73c21072ccf28aeaebf5",
                    "1.3.8" = "e0eb2a9ce749d8faf5c905af06e4bfe0",
                    "1.3.7" = "f302a1d656653e31af358d67666b4544",
                    "1.3.6" = "4b77e2243a56edf0ff56d22c99421ac6",
                    "1.3.5" = "208e8b50a9d87828120c8bce3c205405",
                    "1.3.3" = "f2c33a13f3ec46c2255ab3a5fb99c802",
                    "1.3.1" = "f12d521d0cfada434f46727fc3764d48",
                    "1.2.9" = "e0cb98e3985dd3743edd33f6f1ebdc9d",
                    "1.2.8" = "e5f5ce2f57dd2761e9bcb3a99fe33f84")

procs_ck <- list("1.0.0" = "7f507932591ab8c62f34e557db75ad50") # "9c421179d6dd05290f0fa7aaf4b159bc"


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
  tmp[1, "Description"] <- "Compare checksum for common version v" %p% ver %p% "."
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
  tmp[1, "Description"] <- "Compare checksum for logr version v" %p% ver %p% "."
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
  tmp[1, "Description"] <- "Compare checksum for fmtr version v" %p% ver %p% "."
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
  tmp[1, "Description"] <- "Compare checksum for libr version v" %p% ver %p% "."
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
  tmp[1, "Description"] <- "Compare checksum for reporter version v" %p% ver %p% "."
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
  tmp[1, "Description"] <- "Compare checksum for procs version v" %p% ver %p% "."
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


