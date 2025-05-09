simplify_terms <- function(x) {
  # This is like stats:::terms.default
  # but doesn't look at x$terms.

  check_terms(x)

  # It removes the environment
  # (which could be large)
  # - it is not needed for prediction
  # - it is used in model.matrix(data = environment(object))
  #   but you should never need that
  # - I guess it could be used to look up global variables in a formula,
  #   but don't we want to guard against that?
  # - It is used in model.frame() to evaluate the predvars, but that is also
  #   evaluated in the presence of the data so that should always suffice?
  attr(x, ".Environment") <- NULL

  x
}

# - RHS `.` should be expanded ahead of time by `expand_formula_dot_notation()`
# - Can't use `get_all_vars()` because it chokes on formulas with variables with
#   spaces like ~ `x y`
get_all_predictors <- function(formula, data, ..., call = caller_env()) {
  check_dots_empty0(...)

  predictor_formula <- new_formula(
    lhs = NULL,
    rhs = f_rhs(formula),
    env = f_env(formula)
  )

  predictors <- all.vars(predictor_formula)

  extra_predictors <- setdiff(predictors, names(data))
  if (length(extra_predictors) > 0) {
    cli::cli_abort(
      "The following predictor{?s} {?was/were} not found in {.arg data}:
      {.val {extra_predictors}}.",
      call = call
    )
  }

  predictors
}

# LHS `.` are NOT expanded by `expand_formula_dot_notation()`, and should be
# considered errors
get_all_outcomes <- function(formula, data, ..., call = caller_env()) {
  check_dots_empty0(...)

  outcome_formula <- new_formula(
    lhs = f_lhs(formula),
    rhs = 1,
    env = f_env(formula)
  )

  outcomes <- all.vars(outcome_formula)

  if ("." %in% outcomes) {
    cli::cli_abort(
      "The left-hand side of the formula cannot contain {.code .}.",
      call = call
    )
  }

  extra_outcomes <- setdiff(outcomes, names(data))
  if (length(extra_outcomes) > 0) {
    cli::cli_abort(
      "The following outcome{?s} {?was/were} not found in {.arg data}:
      {.val {extra_outcomes}}.",
      call = call
    )
  }

  outcomes
}

remove_formula_intercept <- function(formula, intercept) {
  if (intercept) {
    return(formula)
  }

  rhs <- f_rhs(formula)
  lhs <- f_lhs(formula)
  env <- f_env(formula)

  rhs <- expr(!!rhs + 0)

  new_formula(
    lhs = lhs,
    rhs = rhs,
    env = env
  )
}

check_unique_names <- function(
  x,
  ...,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (has_unique_names(x)) {
    return(invisible(NULL))
  }

  cli::cli_abort(
    "All elements of {.arg {arg}} must have unique names.",
    call = call
  )
}

check_unique_column_names <- function(
  x,
  ...,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (has_unique_column_names(x)) {
    return(invisible(NULL))
  }

  cli::cli_abort(
    "All columns of {.arg {arg}} must have unique names.",
    call = call
  )
}

has_unique_names <- function(x) {
  nms <- names(x)

  if (length(nms) != length(x)) {
    return(FALSE)
  }

  if (any(is.na(nms) | nms == "")) {
    return(FALSE)
  }

  !anyDuplicated(nms)
}

has_unique_column_names <- function(x) {
  nms <- colnames(x)

  if (length(nms) != NCOL(x)) {
    return(FALSE)
  }

  if (any(is.na(nms) | nms == "")) {
    return(FALSE)
  }

  !anyDuplicated(nms)
}

# ------------------------------------------------------------------------------

check_data_frame_or_matrix <- function(
  x,
  ...,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (!missing(x)) {
    if (is.data.frame(x) || is.matrix(x)) {
      return(invisible(NULL))
    }
  }

  stop_input_type(
    x = x,
    what = "a data frame or a matrix",
    arg = arg,
    call = call
  )
}

coerce_to_tibble <- function(x) {
  # Only to be used after calling `check_data_frame_or_matrix()`.
  # Coerces matrices and bare data frames to tibbles.
  # Avoids calling `as_tibble()` on data frames, as that is more expensive than
  # you'd think, even on tibbles. Need to call `hardhat_new_tibble()` even on
  # existing tibbles to ensure subclasses are dropped (#228).
  if (is.data.frame(x)) {
    hardhat_new_tibble(x, size = vec_size(x))
  } else {
    tibble::as_tibble(x, .name_repair = "minimal")
  }
}

# ------------------------------------------------------------------------------

hardhat_new_tibble <- function(x, size) {
  # Faster than `tibble::new_tibble()`, and it drops extra attributes
  new_data_frame(x = x, n = size, class = c("tbl_df", "tbl"))
}

# ------------------------------------------------------------------------------

with_na_pass <- function(expr) {
  # TODO: This helper is only used because `withr::defer()` is somewhat slow
  # right now. Remove this helper and use `rlang::with_options()` once the next
  # version of withr/rlang is on CRAN https://github.com/r-lib/withr/pull/221.
  old <- options(na.action = "na.pass")
  on.exit(options(old), add = TRUE, after = FALSE)
  expr
}

# ------------------------------------------------------------------------------

vec_paste0 <- function(...) {
  args <- vec_recycle_common(...)
  exec(paste0, !!!args)
}

# ------------------------------------------------------------------------------

check_inherits <- function(
  x,
  what,
  ...,
  allow_null = FALSE,
  arg = caller_arg(x),
  call = caller_env()
) {
  if (!missing(x)) {
    if (inherits(x, what)) {
      return(invisible(NULL))
    }
    if (allow_null && is_null(x)) {
      return(invisible(NULL))
    }
  }

  stop_input_type(
    x = x,
    what = cli::format_inline("a <{what}>"),
    arg = arg,
    call = call
  )
}

# ------------------------------------------------------------------------------

vec_cast_named <- function(x, to, ..., call = caller_env()) {
  # vec_cast() drops names currently
  # https://github.com/r-lib/vctrs/issues/623
  out <- vec_cast(x, to, ..., call = call)

  names <- vec_names(x)
  if (!is.null(names)) {
    out <- vec_set_names(out, names)
  }

  out
}
