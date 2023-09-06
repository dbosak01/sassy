


#' @noRd
print_report <- function(path, dat, ttls) {


  if (!dir.exists(dirname(path))) {

    stop("Directory " %p% dirname(path) %p% " does not exist.")
  }

  if (is.null(dat)) {

    stop("Data is NULL.")
  }


  datm <- data.frame(ID = seq(1, nrow(dat)), dat)

  tbl <- create_table(datm, header_bold = TRUE)

  rpt <- create_report(path, output_type = "PDF", font = "Arial",
                       orientation = "landscape") |>
    titles(ttls, bold = TRUE, font_size = 12, blank_row = "none") |>
    titles("Date: " %p% fapply(Sys.time(), "%Y-%m-%d %H:%M:%S %p")) |>
    add_content(tbl)

  res <- write_report(rpt)


  return(res$modified_path)
}


#' @noRd
view_report <- function(dat, ttls) {


  if (is.null(dat)) {

    stop("Data is NULL.")
  }

  path <- tempfile(fileext = ".html")


  datm <- data.frame(ID = seq(1, nrow(dat)), dat)

  tbl <- create_table(datm, header_bold = TRUE) |>
    titles(ttls, bold = TRUE, font_size = 12, blank_row = "none") |>
    titles("Date: " %p% fapply(Sys.time(), "%Y-%m-%d %H:%M:%S %p"))

  rpt <- create_report(path, output_type = "HTML", font = "Arial",
                       paper_size = "none",
                       orientation = "portrait") |>
    set_margins(top = .5, bottom = .5, left = .5, right = .5) |>
    add_content(tbl)

  res <- write_report(rpt)

  show_viewer(res$modified_path)


  return(res$modified_path)
}


#' @noRd
show_viewer <- function(path) {


  if (file.exists(path)) {

    opts <- options("procs.print")[[1]]

    if (.Platform$GUI == "RStudio") {

      pth <- path

      viewer <- getOption("viewer")

      if (!is.null(viewer))
        viewer(path)
      else
        utils::browseURL(path)

    }

  }


  return(NULL)

}
