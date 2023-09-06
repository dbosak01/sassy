

# Installation Qualification ----------------------------------------------



#' @title Generates an Installation Qualification Report
#' @description The \code{run_iq} function executes an
#' installation qualification (IQ)
#' on the currently installed \strong{sassy} packages, and generates a report
#' on the results. The IQ ensures that the files in the \strong{sassy} packages
#' are correct, and have not been altered.
#' The results of the IQ will be placed in the supplied location.
#' @details
#' The \code{run_iq} function works by comparing package checksums and file
#' sizes against expected values.
#'
#' The function first tries to determine the
#' installation location of each package. If the installation location cannot
#' be found, the check for that package will fail.  If the installation
#' location is found, the function will open the package and capture a
#' checksum and file size on the code repository.  The checksum and file
#' sizes are then compared against known values. Ideally, the checksum
#' value will match.  If not, the function will compare the file sizes.  If
#' both the checksum and file size comparison fail, the check for that package
#' will fail.  If one of them passes, the check will pass.
#'
#' Note that the checksum values are somewhat volatile, and can change
#' from one Operating System to the next. The checksum can also change
#' if the R version is upgraded. Therefore, the checksum is not a perfectly
#' reliable indicator of authenticity.  It is for that reason that the
#' file size is used as a backup indicator.
#'
#' @param location The path to the desired output directory.  The IQ
#' reports and any associated files will be placed in this directory.
#' @return The path to the output directory.  The directory
#' will contain a PDF report showing a summary of the results of the IQ. After
#' the function is run, review this report to ensure that all tests passed.
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
    ret <- rbind(ret, examine_package("common"))

    sep("Examine fmtr package")
    ret <- rbind(ret, examine_package("fmtr"))

    sep("Examine libr package")
    ret <- rbind(ret, examine_package("libr"))

    sep("Examine reporter package")
    ret <- rbind(ret, examine_package("reporter"))

    sep("Examine procs package")
    ret <- rbind(ret, examine_package("procs"))

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

common_ck <- list("1.0.8" = c(checksum = "eaaf045fd6a752e01e6233c63f48cb4a", size = "42701"),
                  "1.0.7" = c(checksum = "1ebbf9fbe0b42f6df5bb15e6bf12f229", size = ""),
                  "1.0.5" = c(checksum = "21f1b333ec7259c6ffe41e9aeaf1391e", size = ""),
                  "1.0.4" = c(checksum = "b1841850c492cd6d998efa788dee7cd0", size = ""),
                  "1.0.3" = c(checksum = "b61aa170486b1b4327d0507b96c26204", size = ""),
                  "1.0.1" = c(checksum = "9f8e73b66a0d6d2d7832788fa0c94a55", size = ""))

fmtr_ck <- list("1.5.9" = c(checksum = "20a01e1e7cbf0003ba274253721d3c85", size = "59378"), # "300deb40502efff0239d0ef731f4171b"
                "1.5.8" = c(checksum = "8d609b0585bf23dcc758d8eb4b5c3d30", size = ""),
                "1.5.7" = c(checksum = "ff2d61b3af6b755a55a225bcd03a0755", size = ""),
                "1.5.5" = c(checksum = "f3d5371e59bbda4626a96f10b546eaf9", size = ""),
                "1.5.4" = c(checksum = "a44eb1f1e9b63e9a23237c545f300599", size = ""),
                "1.5.3" = c(checksum = "25fb35e9af0726f7e453ebe9f78a1f83", size = ""),
                "1.5.2" = c(checksum = "012a0de7a015b2376530e3dbf7ee412f", size = ""),
                "1.5.1" = c(checksum = "3c909974a90ed47253dea996e6315e12", size = ""),
                "1.5.0" = c(checksum = "e77283c81ffab8e03d9d2d570cc2996c", size = ""))

logr_ck <- list("1.3.4" = c(checksum = "b51c880285dd4ab646db79ce87dcb888", size = "31979"), # "efbe075f699490aec2556a8be7c6913b"
                "1.3.3" = c(checksum = "8808443fa943d1f3b09b6c9fa0f02f41", size = ""),
                "1.3.2" = c(checksum = "7efb9daa7ac020ad58f34461b6933339", size = ""),
                "1.3.1" = c(checksum = "d9e46ede3740524605240d450ba3e732", size = ""),
                "1.3.0" = c(checksum = "a4da1be2f0bf4245fc139f2479178d00", size = ""),
                "1.2.9" = c(checksum = "619b933a95d31ae27bf641bbdbc0687b", size = ""),
                "1.2.8" = c(checksum = "5e4c6e66afeeaa10aa29fd01f88e28f8", size = ""),
                "1.2.7" = c(checksum = "c2ef573871fb01f657d5e23936baa320", size = ""),
                "1.2.6" = c(checksum = "07c2f979656775c763fd2dc1b5c99e74", size = ""),
                "1.2.5" = c(checksum = "a1c9b8a5e6df93dc2472ebfdc063c5ac", size = ""))

libr_ck <- list("1.2.8" = c(checksum = "6bec5e1d2255ba1add47f2ce326c0a2a", size = "98426"), # "c30e6df3b5774b1992376284b1a02a6f"
                "1.2.5" = c(checksum = "0cef946bd42ab45bd04dd7d6e56f3ab0", size = ""),
                "1.2.3" = c(checksum = "f5457b9953e425c93b0a11d00085ba58", size = ""),
                "1.2.2" = c(checksum = "44c5e9c9b4d232b9ec004391294637cb", size = ""),
                "1.2.1" = c(checksum = "2b6ecefd020a84b951ab46a40f189d94", size = ""),
                "1.2.0" = c(checksum = "f5280880f67282ce4b3a981bca9df8f2", size = ""))

reporter_ck <- list("1.4.1" = c(checksum = "8430053e29e8a1b2c3466f8121a6dbad", size = "1348439"), # "2e20b4a9614f6027e03e4044d073a96a"
                    "1.3.9" = c(checksum = "4b96f23b7ebf73c21072ccf28aeaebf5", size = ""),
                    "1.3.8" = c(checksum = "e0eb2a9ce749d8faf5c905af06e4bfe0", size = ""),
                    "1.3.7" = c(checksum = "f302a1d656653e31af358d67666b4544", size = ""),
                    "1.3.6" = c(checksum = "4b77e2243a56edf0ff56d22c99421ac6", size = ""),
                    "1.3.5" = c(checksum = "208e8b50a9d87828120c8bce3c205405", size = ""),
                    "1.3.3" = c(checksum = "f2c33a13f3ec46c2255ab3a5fb99c802", size = ""),
                    "1.3.1" = c(checksum = "f12d521d0cfada434f46727fc3764d48", size = ""),
                    "1.2.9" = c(checksum = "e0cb98e3985dd3743edd33f6f1ebdc9d", size = ""),
                    "1.2.8" = c(checksum = "e5f5ce2f57dd2761e9bcb3a99fe33f84", size = ""))

procs_ck <- list("1.0.3" = c(checksum = "079989cd230fb815e7a0b5a1a34c4521", size = "150483"),
                 "1.0.2" = c(checksum = "89ea73d0a6a821ea44e00c8123d3167a", size = "145777"), # "89ea73d0a6a821ea44e00c8123d3167a"
                 "1.0.0" = c(checksum = "7f507932591ab8c62f34e557db75ad50", size = "144709"))


# IQ Subroutines ----------------------------------------------------------

#' @import tools
check_sum <- function(pkg, ver, pth) {

  ret <- FALSE

  if (pkg == "common") {

    if (!is.null(common_ck[[ver]])) {
      if (common_ck[[ver]][["checksum"]] == md5sum(pth))
        ret <- TRUE
    }

  } else if (pkg == "logr") {

    if (!is.null(logr_ck[[ver]])) {
      if (logr_ck[[ver]][["checksum"]] == md5sum(pth))
        ret <- TRUE
    }

  } else if (pkg == "fmtr") {

    if (!is.null(fmtr_ck[[ver]])) {
      if (fmtr_ck[[ver]][["checksum"]] == md5sum(pth))
        ret <- TRUE
    }

  } else if (pkg == "libr") {

    if (!is.null(libr_ck[[ver]])) {
      if (libr_ck[[ver]][["checksum"]] == md5sum(pth))
        ret <- TRUE
    }


  } else if (pkg == "reporter") {

    if (!is.null(reporter_ck[[ver]])) {
      if (reporter_ck[[ver]][["checksum"]] == md5sum(pth))
        ret <- TRUE
    }

  } else if (pkg == "procs") {

    if (!is.null(procs_ck[[ver]])) {
      if (procs_ck[[ver]][["checksum"]] == md5sum(pth))
        ret <- TRUE
    }

  }


  return(ret)
}

check_size <- function(pkg, ver, pth) {

  ret <- FALSE

  inf <- file.info(pth)

  if (pkg == "common") {

    if (!is.null(common_ck[[ver]])) {
      if (common_ck[[ver]][["size"]] == inf$size)
        ret <- TRUE
    }

  } else if (pkg == "logr") {

    if (!is.null(logr_ck[[ver]])) {
      if (logr_ck[[ver]][["size"]] == inf$size)
        ret <- TRUE
    }

  } else if (pkg == "fmtr") {

    if (!is.null(fmtr_ck[[ver]])) {
      if (fmtr_ck[[ver]][["size"]] == inf$size)
        ret <- TRUE
    }

  } else if (pkg == "libr") {

    if (!is.null(libr_ck[[ver]])) {
      if (libr_ck[[ver]][["size"]] == inf$size)
        ret <- TRUE
    }


  } else if (pkg == "reporter") {

    if (!is.null(reporter_ck[[ver]])) {
      if (reporter_ck[[ver]][["size"]] == inf$size)
        ret <- TRUE
    }

  } else if (pkg == "procs") {

    if (!is.null(procs_ck[[ver]])) {
      if (procs_ck[[ver]][["size"]] == inf$size)
        ret <- TRUE
    }

  }


  return(ret)
}



#' @import tools
#' @import utils
examine_package <- function(pkg) {

  ver <- as.character(packageVersion(pkg))

  pth <- file.path(.libPaths()[1], paste0(pkg, "/R/", pkg, ".rdb"))

  tmplt <- data.frame(Category = pkg,
                      Description = paste0(pkg, " source code found."),
                      Pass = TRUE,
                      Message = "",
                      stringsAsFactors = FALSE)

  tmp <- tmplt
  if (!file.exists(pth)) {
    tmp[1, "Pass"] <- FALSE
    tmp[1, "Message"] <- paste0(pkg, " source code not found.")
    put(pkg %p% " source code not found.")
  } else {
    put(pkg %p% " source code found.")
  }

  ret <- tmp

  tmp <- tmplt
  tmp[1, "Description"] <- paste0("Compare checksum for ", pkg, " version v", ver, ".")
  if (check_sum(pkg, ver, pth) == FALSE) {
    tmp[1, "Pass"] <- FALSE
    if (!ver %in% get_names(pkg)) {
      tmp[1, "Message"] <- "Package version checksum not found."
      put(paste0(pkg, " version checksum not found."))

    } else if (ver == max(get_names(pkg))) {
      if (check_size(pkg, ver, pth)) {
        tmp[1, "Pass"] <- TRUE
        tmp[1, "Message"] <- "Checksum failed but size check passed."
        put(paste0(pkg, " size check passed."))
      } else {
        tmp[1, "Message"] <- "File size does not match expected value."
        put(paste0(pkg, " source code size check failed."))
      }
    } else {
      tmp[1, "Message"] <- "Checksum does not match expected value."
      put(paste0(pkg, " source code checksum failed."))
    }
  } else {
    put(paste0(pkg, " source code checksum passed."))
  }

  ret <- rbind(ret, tmp)


  return(ret)

}

get_names <- function(pkg) {

  ret <- NULL

  if (pkg == "common")
    ret <- names(common_ck)
  else if (pkg == "logr")
    ret <- names(logr_ck)
  else if (pkg == "fmtr")
    ret <- names(fmtr_ck)
  else if (pkg == "libr")
    ret <- names(libr_ck)
  else if (pkg == "reporter")
    ret <- names(reporter_ck)
  else if (pkg == "procs")
    ret <- names(procs_ck)


  return(ret)
}
