% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/forge.R, R/blueprint-formula-default.R,
%   R/blueprint-recipe-default.R, R/blueprint-xy-default.R
\name{run-forge}
\alias{run-forge}
\alias{run_forge}
\alias{run_forge.default_formula_blueprint}
\alias{run_forge.default_recipe_blueprint}
\alias{run_forge.default_xy_blueprint}
\title{\code{forge()} according to a blueprint}
\usage{
run_forge(blueprint, new_data, ..., outcomes = FALSE)

\method{run_forge}{default_formula_blueprint}(blueprint, new_data, ..., outcomes = FALSE, call = caller_env())

\method{run_forge}{default_recipe_blueprint}(blueprint, new_data, ..., outcomes = FALSE, call = caller_env())

\method{run_forge}{default_xy_blueprint}(blueprint, new_data, ..., outcomes = FALSE, call = caller_env())
}
\arguments{
\item{blueprint}{A preprocessing \code{blueprint}.}

\item{new_data}{A data frame or matrix of predictors to process. If
\code{outcomes = TRUE}, this should also contain the outcomes to process.}

\item{...}{Not used.}

\item{outcomes}{A logical. Should the outcomes be processed and returned
as well?}

\item{call}{The call used for errors and warnings.}
}
\value{
\code{run_forge()} methods return the object that is then immediately returned
from \code{forge()}. See the return value section of \code{\link[=forge]{forge()}} to understand what
the structure of the return value should look like.
}
\description{
This is a developer facing function that is \emph{only} used if you are creating
your own blueprint subclass. It is called from \code{\link[=forge]{forge()}} and dispatches off
the S3 class of the \code{blueprint}. This gives you an opportunity to forge the
new data in a way that is specific to your blueprint.

\code{run_forge()} is always called from \code{forge()} with the same arguments, unlike
\code{\link[=run_mold]{run_mold()}}, because there aren't different interfaces for calling
\code{forge()}. \code{run_forge()} is always called as:

\code{run_forge(blueprint, new_data = new_data, outcomes = outcomes)}

If you write a blueprint subclass for \code{\link[=new_xy_blueprint]{new_xy_blueprint()}},
\code{\link[=new_recipe_blueprint]{new_recipe_blueprint()}}, \code{\link[=new_formula_blueprint]{new_formula_blueprint()}}, or \code{\link[=new_blueprint]{new_blueprint()}},
then your \code{run_forge()} method signature must match this.
}
\examples{
bp <- default_xy_blueprint()

outcomes <- mtcars["mpg"]
predictors <- mtcars
predictors$mpg <- NULL

mold <- run_mold(bp, x = predictors, y = outcomes)

run_forge(mold$blueprint, new_data = predictors)
}
