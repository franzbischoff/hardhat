% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/blueprint-recipe-default.R, R/mold.R
\name{default_recipe_blueprint}
\alias{default_recipe_blueprint}
\alias{mold.recipe}
\title{Default recipe blueprint}
\usage{
default_recipe_blueprint(intercept = FALSE, fresh = FALSE)

\method{mold}{recipe}(x, data, ..., blueprint = NULL)
}
\arguments{
\item{intercept}{A logical. Should an intercept be included in the
processed data? This information is used by the \code{process} function
in the \code{mold} and \code{forge} function list.}

\item{fresh}{Should already trained operations be re-trained when \code{prep()} is
called?}

\item{x}{An unprepped recipe created from \code{\link[recipes:recipe]{recipes::recipe()}}.}

\item{data}{A data frame or matrix containing the outcomes and predictors.}

\item{...}{Not used.}

\item{blueprint}{A preprocessing \code{blueprint}. If left as \code{NULL}, then a
\code{\link[=default_recipe_blueprint]{default_recipe_blueprint()}} is used.}
}
\description{
This pages holds the details for the recipe preprocessing blueprint. This
is the blueprint used by default from \code{mold()} if \code{x} is a recipe.
}
\section{Mold}{


When \code{mold()} is used with the default recipe blueprint:
\itemize{
\item It calls \code{\link[recipes:prep]{recipes::prep()}} to prep the recipe.
\item It calls \code{\link[recipes:juice]{recipes::juice()}} to extract the outcomes and predictors. These
are returned as tibbles.
\item If \code{intercept = TRUE}, adds an intercept column to the predictors.
}
}

\section{Forge}{


When \code{forge()} is used with the default recipe blueprint:
\itemize{
\item It calls \code{\link[=shrink]{shrink()}} to trim \code{new_data} to only the required columns and
coerce \code{new_data} to a tibble.
\item It calls \code{\link[=scream]{scream()}} to perform validation on the structure of the columns
of \code{new_data}.
\item It calls \code{\link[recipes:bake]{recipes::bake()}} on the \code{new_data} using the prepped recipe
used during training.
\item It adds an intercept column onto \code{new_data} if \code{intercept = TRUE}.
}
}

\examples{
library(recipes)

# ---------------------------------------------------------------------------
# Setup

train <- iris[1:100,]
test <- iris[101:150,]

# ---------------------------------------------------------------------------
# Recipes example

# Create a recipe that logs a predictor
rec <- recipe(Species ~ Sepal.Length + Sepal.Width, train) \%>\%
   step_log(Sepal.Length)

processed <- mold(rec, train)

# Sepal.Length has been logged
processed$predictors

processed$outcomes

# The underlying blueprint is a prepped recipe
processed$blueprint$recipe

# Call forge() with the blueprint and the test data
# to have it preprocess the test data in the same way
forge(test, processed$blueprint)

# Use `outcomes = TRUE` to also extract the preprocessed outcome!
# This logged the Sepal.Length column of `new_data`
forge(test, processed$blueprint, outcomes = TRUE)

# ---------------------------------------------------------------------------
# With an intercept

# You can add an intercept with `intercept = TRUE`
processed <- mold(rec, train, blueprint = default_recipe_blueprint(intercept = TRUE))

processed$predictors

# But you also could have used a recipe step
rec2 <- step_intercept(rec)

mold(rec2, iris)$predictors

# ---------------------------------------------------------------------------
# Non standard roles

# If you have custom recipe roles, they are processed and returned in
# the `$extras$roles` slot of the return value of `mold()` and `forge()`.

rec_roles <- recipe(train) \%>\%
  update_role(Sepal.Width, new_role = "predictor") \%>\%
  update_role(Species, new_role = "outcome") \%>\%
  update_role(Sepal.Length, new_role = "custom_role") \%>\%
  update_role(Petal.Length, new_role = "custom_role2")

processed_roles <- mold(rec_roles, train)

processed_roles$extras

forge(test, processed_roles$blueprint)

}