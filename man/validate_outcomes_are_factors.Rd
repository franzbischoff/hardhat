% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/validation.R
\name{validate_outcomes_are_factors}
\alias{validate_outcomes_are_factors}
\alias{check_outcomes_are_factors}
\title{Ensure that the outcome has only factor columns}
\usage{
validate_outcomes_are_factors(outcomes)

check_outcomes_are_factors(outcomes, ..., call = caller_env())
}
\arguments{
\item{outcomes}{An object to check.}

\item{...}{These dots are for future extensions and must be empty.}

\item{call}{The call used for errors and warnings.}
}
\value{
\code{validate_outcomes_are_factors()} returns \code{outcomes} invisibly.

\code{check_outcomes_are_factors()} returns a named list of two components,
\code{ok} and \code{bad_classes}.
}
\description{
validate - asserts the following:
\itemize{
\item \code{outcomes} must have factor columns.
}

check - returns the following:
\itemize{
\item \code{ok} A logical. Does the check pass?
\item \code{bad_classes} A named list. The names are the names of problematic columns,
and the values are the classes of the matching column.
}
}
\details{
The expected way to use this validation function is to supply it the
\verb{$outcomes} element of the result of a call to \code{\link[=mold]{mold()}}.
}
\section{Validation}{


hardhat provides validation functions at two levels.
\itemize{
\item \verb{check_*()}:  \emph{check a condition, and return a list}. The list
always contains at least one element, \code{ok}, a logical that specifies if the
check passed. Each check also has check specific elements in the returned
list that can be used to construct meaningful error messages.
\item \verb{validate_*()}: \emph{check a condition, and error if it does not pass}. These
functions call their corresponding check function, and
then provide a default error message. If you, as a developer, want a
different error message, then call the \verb{check_*()} function yourself,
and provide your own validation function.
}
}

\examples{
# Not a factor column.
check_outcomes_are_factors(data.frame(x = 1))

# All good
check_outcomes_are_factors(data.frame(x = factor(c("A", "B"))))
}
\seealso{
Other validation functions: 
\code{\link{validate_column_names}()},
\code{\link{validate_no_formula_duplication}()},
\code{\link{validate_outcomes_are_binary}()},
\code{\link{validate_outcomes_are_numeric}()},
\code{\link{validate_outcomes_are_univariate}()},
\code{\link{validate_prediction_size}()},
\code{\link{validate_predictors_are_numeric}()}
}
\concept{validation functions}
