% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/session.R
\name{is_installed}
\alias{is_installed}
\alias{check_installed}
\title{Are packages installed in any of the libraries?}
\usage{
is_installed(pkg, ..., version = NULL, compare = NULL)

check_installed(
  pkg,
  reason = NULL,
  ...,
  version = NULL,
  compare = NULL,
  action = NULL,
  call = caller_env()
)
}
\arguments{
\item{pkg}{The package names. Can include version requirements,
e.g. \code{"pkg (>= 1.0.0)"}.}

\item{...}{These dots must be empty.}

\item{version}{Minimum versions for \code{pkg}. If supplied, must be the
same length as \code{pkg}. \code{NA} elements stand for any versions.}

\item{compare}{A character vector of comparison operators to use
for \code{version}. If supplied, must be the same length as
\code{version}. If \code{NULL}, \code{>=} is used as default for all
elements. \code{NA} elements in \code{compare} are also set to \code{>=} by
default.}

\item{reason}{Optional string indicating why is \code{pkg} needed.
Appears in error messages (if non-interactive) and user prompts
(if interactive).}

\item{action}{An optional function taking \code{pkg} and \code{...}
arguments. It is called by \code{check_installed()} when the user
chooses to update outdated packages. The function is passed the
missing and outdated packages as a character vector of names.}

\item{call}{The execution environment of a currently
running function, e.g. \code{caller_env()}. The function will be
mentioned in error messages as the source of the error. See the
\code{call} argument of \code{\link[=abort]{abort()}} for more information.}
}
\value{
\code{is_installed()} returns \code{TRUE} if \emph{all} package names
provided in \code{pkg} are installed, \code{FALSE}
otherwise. \code{check_installed()} either doesn't return or returns
\code{NULL}.
}
\description{
These functions check that packages are installed with minimal side
effects. If installed, the packages will be loaded but not
attached.
\itemize{
\item \code{is_installed()} doesn't interact with the user. It simply
returns \code{TRUE} or \code{FALSE} depending on whether the packages are
installed.
\item In interactive sessions, \code{check_installed()} asks the user
whether to install missing packages. If the user accepts, the
packages are installed with \code{pak::pkg_install()} if available, or
\code{\link[utils:install.packages]{utils::install.packages()}} otherwise. If the session is non
interactive or if the user chooses not to install the packages,
the current evaluation is aborted.
}

You can disable the prompt by setting the
\code{rlib_restart_package_not_found} global option to \code{FALSE}. In that
case, missing packages always cause an error.
}
\section{Handling package not found errors}{

\code{check_installed()} signals error conditions of class
\code{rlib_error_package_not_found}. The error includes \code{pkg} and
\code{version} fields. They are vectorised and may include several
packages.

The error is signalled with a \code{rlib_restart_package_not_found}
restart on the stack to allow handlers to install the required
packages. To do so, add a \link[=withCallingHandlers]{calling handler}
for \code{rlib_error_package_not_found}, install the required packages,
and invoke the restart without arguments. This restarts the check
from scratch.

The condition is not signalled in non-interactive sessions, in the
restarting case, or if the \code{rlib_restart_package_not_found} user
option is set to \code{FALSE}.
}

\examples{
is_installed("utils")
is_installed(c("base", "ggplot5"))
is_installed(c("base", "ggplot5"), version = c(NA, "5.1.0"))
}
