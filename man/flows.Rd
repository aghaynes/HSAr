% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/flows.r
\name{flows}
\alias{flows}
\title{Generate flow table}
\usage{
flows(from, to, zeros = TRUE, keepFrom = NULL, keepTo = NULL)
}
\arguments{
\item{from}{patients home region}

\item{to}{patients destination}

\item{zeros}{retain combinations with zero counts}

\item{keepFrom}{values of 'from' to keep}

\item{keepTo}{values of 'from' to keep}
}
\value{
dataframe detailing flow between \code{from} and \code{to}.
\describe{
  \item{\code{from}}{entries in \code{from}}
  \item{\code{to}}{entries in \code{to}}
  \item{\code{N}}{frequency of flow from \code{from} to \code{to}}
  \item{\code{N_from}}{total number of interventions from \code{from}}
  \item{\code{N_to}}{total number of interventions to \code{to}}
  \item{\code{prop_from}}{proportion of interventions from \code{from} going to \code{to}}
  \item{\code{prop_to}}{proportion of interventions to \code{to} originating in \code{from}}
  \item{\code{rank_from}}{rank of \code{prop_from} within each \code{from}}
  \item{\code{rank_to}}{rank of \code{prop_to} within each \code{to}}
  }
}
\description{
Generate flow table
}
\details{
keepFrom and keepTo default to retaining all unique values of the respective options
}
