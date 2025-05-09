test_that("quantile_pred error types", {
  expect_snapshot(
    error = TRUE,
    quantile_pred(1:10, 1:4 / 5)
  )
  expect_snapshot(
    error = TRUE,
    quantile_pred(matrix(1:20, 5), -1:4 / 5)
  )
  expect_snapshot(
    error = TRUE,
    quantile_pred(matrix(1:20, 5), 1:5 / 6)
  )
  expect_snapshot(
    error = TRUE,
    quantile_pred(matrix(1:20, 5), 4:1 / 5)
  )
})

test_that("quantile levels are checked", {
  expect_snapshot(error = TRUE, {
    quantile_pred(matrix(1:20, 5), quantile_levels = NULL)
  })
  expect_snapshot(error = TRUE, {
    quantile_pred(matrix(1:20, 5), quantile_levels = c(0.7, 0.7, 0.7))
  })
  expect_snapshot(error = TRUE, {
    quantile_pred(
      matrix(1:20, 5),
      quantile_levels = c(rep(0.7, 2), rep(0.8, 3))
    )
  })
  expect_snapshot(error = TRUE, {
    quantile_pred(matrix(1:20, 5), quantile_levels = c(0.8, 0.7))
  })
})

test_that("quantile_pred outputs", {
  v <- quantile_pred(matrix(1:20, 5), 1:4 / 5)
  expect_s3_class(v, "quantile_pred")
  expect_identical(attr(v, "quantile_levels"), 1:4 / 5)
  expect_identical(
    vctrs::vec_data(v),
    lapply(vctrs::vec_chop(matrix(1:20, 5)), drop)
  )
})

test_that("extract_quantile_levels", {
  v <- quantile_pred(matrix(1:20, 5), 1:4 / 5)
  expect_identical(extract_quantile_levels(v), 1:4 / 5)

  expect_snapshot(
    error = TRUE,
    extract_quantile_levels(1:10)
  )
})

test_that("quantile_pred formatting", {
  # multiple quantiles
  v <- quantile_pred(matrix(1:20, 5), 1:4 / 5)
  expect_snapshot(v)
  expect_snapshot(quantile_pred(matrix(1:18, 9), c(1 / 3, 2 / 3)))
  expect_snapshot(
    quantile_pred(matrix(seq(0.01, 1 - 0.01, length.out = 6), 3), c(.2, .8))
  )
  expect_snapshot(tibble(qntls = v))
  m <- matrix(1:20, 5)
  m[2, 3] <- NA
  m[4, 2] <- NA
  expect_snapshot(quantile_pred(m, 1:4 / 5))

  # single quantile
  m <- matrix(1:5)
  one_quantile <- quantile_pred(m, 5 / 9)
  expect_snapshot(one_quantile)
  expect_snapshot(tibble(qntls = one_quantile))
  m[2] <- NA
  expect_snapshot(quantile_pred(m, 5 / 9))

  set.seed(393)
  v <- quantile_pred(matrix(exp(rnorm(20)), ncol = 4), 1:4 / 5)
  expect_snapshot(format(v))
  expect_snapshot(format(v, digits = 5))
})

test_that("as_tibble() for quantile_pred", {
  v <- quantile_pred(matrix(1:20, 5), 1:4 / 5)
  tbl <- as_tibble(v)
  expect_s3_class(tbl, c("tbl_df", "tbl", "data.frame"))
  expect_named(tbl, c(".pred_quantile", ".quantile_levels", ".row"))
  expect_true(nrow(tbl) == 20)
})

test_that("as.matrix() for quantile_pred", {
  x <- matrix(1:20, 5)
  v <- quantile_pred(x, 1:4 / 5)
  m <- as.matrix(v)
  expect_true(is.matrix(m))
  expect_identical(m, x)
})
