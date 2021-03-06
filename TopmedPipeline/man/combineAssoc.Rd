% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/getAssoc.R
\name{combineAssoc}
\alias{combineAssoc}
\title{Combine association test results}
\usage{
combineAssoc(files, assoc_type)
}
\arguments{
\item{files}{Vector of file names with association test results}

\item{assoc_type}{Type of association test ("single", "aggregate", "window")}
}
\value{
Association test object
}
\description{
Combine association test results from multiple files into a single object.
}
\details{
Useful for combining per-segment results into a single file per chromosome.
}
