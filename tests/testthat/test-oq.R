base_path <- "c:/packages/sassy/tests/testthat"
data_dir <- base_path

base_path <- tempdir()
data_dir <- "."


dev <- FALSE

options("logr.print" = FALSE)

test_that("OQ-01: print_report() works as expected.", {


  ret <- data.frame(Category = "Initialization",
                    Description = "System Initialization",
                    Pass = TRUE, Message = "", stringsAsFactors = FALSE)

  bp <- file.path(base_path, "output")

  if (!dir.exists(bp)) {

    dir.create(bp)
  }

  pth <- file.path(bp, "sassyOQ-" %p% Sys.Date())

  res <- print_report(pth, ret, "Test")

  expect_equal(file.exists(res), TRUE)

  #file.show(res)

  if (dev == FALSE) {
    if (file.exists(res)) {

      file.remove(res)
    }
  }

})

# Have to check this visually
test_that("OQ-02: view_report() works as expected.", {


  ret <- data.frame(Category = "Initialization",
                    Description = "System Initialization",
                    Pass = TRUE, Message = "", stringsAsFactors = FALSE)



  res <- view_report(ret, "Test")

  expect_equal(file.exists(res), TRUE)

  #file.show(res)

  if (dev == FALSE) {
    if (file.exists(res)) {

      file.remove(res)
    }
  }

})


test_that("OQ-03: check_packages() works as expected.", {


  res <- check_packages()

  expect_equal(nrow(res), 6)
  expect(all(res$Pass == TRUE), TRUE)

})


test_that("OQ-04: check_common() works as expected.", {

  pth <- file.path(base_path, "OQ/log")

  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)

  res <- check_common()

  expect_equal(nrow(res), 7)
  expect(all(res$Pass == TRUE), TRUE)

})


test_that("OQ-05: check_fmtr() works as expected.", {


  pth <- file.path(base_path, "OQ/log")

  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)

  pth <- file.path(base_path, "OQ/output")

  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)

  res <- check_fmtr(pth)

  expect_equal(nrow(res), 6)
  expect(all(res$Pass == TRUE), TRUE)

})


test_that("OQ-06: check_logr() works as expected.", {

  pth <- file.path(base_path, "OQ/log")

  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)

  res <- check_logr(pth)

  expect_equal(nrow(res), 1)
  expect(all(res$Pass == TRUE), TRUE)

})

test_that("OQ-07: check_libr() works as expected.", {

  pth <- file.path(base_path, "OQ/data")

  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)

  res <- check_libr(pth)

  expect_equal(nrow(res), 6)
  expect(all(res$Pass == TRUE), TRUE)

})


test_that("OQ-08: check_reporter() works as expected.", {

  pth <- file.path(base_path, "OQ/output")

  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)

  res <- check_reporter(pth)

  expect_equal(nrow(res), 5)
  expect(all(res$Pass == TRUE), TRUE)

})


test_that("OQ-09: check_procs() works as expected.", {

  pth <- file.path(base_path, "OQ/output")

  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)

  res <- check_procs(pth)

  res
  expect_equal(nrow(res), 6)
  expect(all(res$Pass == TRUE), TRUE)

})




test_that("OQ-10: run_oq() works as expected.", {

  pth <- file.path(base_path, "OQ")

  res <- run_oq(pth)

  expect_equal(file.exists(res), TRUE)

  #file.show(res)

  if (!dev) {
    if (file.exists(res))
      file.remove(res)

  }

})

