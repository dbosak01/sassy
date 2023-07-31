
base_path <- "c:/packages/sassy/tests/testthat"
data_dir <- base_path

base_path <- tempdir()
data_dir <- "."


dev <- FALSE

options("logr.print" = FALSE)

test_that("IQ-01: check_sum() works as expected.", {


  pth <- file.path(.libPaths()[1], "common/R/common.rdb")

  ver <- as.character(packageVersion("common"))

  res <- check_sum("common", ver, pth)

  expect_equal(res, TRUE)

})


test_that("IQ-02: examine_common() works as expected.", {

  res <- examine_common()


  expect_equal(nrow(res), 2)
  expect_equal(all(res$Pass), TRUE)

})


test_that("IQ-03: examine_logr() works as expected.", {

  res <- examine_logr()


  expect_equal(nrow(res), 2)
  expect_equal(all(res$Pass), TRUE)

})


test_that("IQ-04: examine_fmtr() works as expected.", {

  res <- examine_fmtr()


  expect_equal(nrow(res), 2)
  expect_equal(all(res$Pass), TRUE)

})


test_that("IQ-05: examine_libr() works as expected.", {

  res <- examine_libr()


  expect_equal(nrow(res), 2)
  expect_equal(all(res$Pass), TRUE)

})


test_that("IQ-06: examine_reporter() works as expected.", {

  res <- examine_reporter()


  expect_equal(nrow(res), 2)
  expect_equal(all(res$Pass), TRUE)

})


test_that("IQ-07: examine_procs() works as expected.", {

  res <- examine_procs()


  expect_equal(nrow(res), 2)
  expect_equal(all(res$Pass), TRUE)

})


test_that("IQ-08: run_iq() works as expected.", {

  pth <- file.path(base_path, "IQ")


  if (!dir.exists(pth))
    dir.create(pth, recursive = TRUE)


  res <- run_iq(pth)

  expect_equal(file.exists(res), TRUE)

  #file.show(res)

  if (!dev) {
    if (file.exists(res))
      file.remove(res)

  }

})
