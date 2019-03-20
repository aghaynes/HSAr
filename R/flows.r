#' Generate flow table
#' 
#'
#' @param from patients home region
#' @param to patients destination
#' @param zeros retain combinations with zero counts
#' @param keepFrom values of 'from' to keep
#' @param keepTo values of 'from' to keep
#' @details keepFrom and keepTo default to retaining all unique values of the respective options
#' @return dataframe detailing flow between \code{from} and \code{to}.
#' \describe{
#'   \item{\code{from}}{entries in \code{from}}
#'   \item{\code{to}}{entries in \code{to}}
#'   \item{\code{N}}{frequency of flow from \code{from} to \code{to}}
#'   \item{\code{N_from}}{total number of interventions from \code{from}}
#'   \item{\code{N_to}}{total number of interventions to \code{to}}
#'   \item{\code{prop_from}}{proportion of interventions from \code{from} going to \code{to}}
#'   \item{\code{prop_to}}{proportion of interventions to \code{to} originating in \code{from}}
#'   \item{\code{rank_from}}{rank of \code{prop_from} within each \code{from}}
#'   \item{\code{rank_to}}{rank of \code{prop_to} within each \code{to}}
#'   }
#' @export flows
#' @examples


# add exclude options?

flows <- function(from, to, zeros = TRUE, keepFrom = NULL, keepTo = NULL){
  require(data.table)
  flow <- as.data.table(table(from = from, to = to), stringsAsFactors = FALSE)
  
  if(!is.null(keepFrom)) flow <- flow[from %in% keepFrom]
  if(!is.null(keepTo)) flow <- flow[to %in% keepTo]
  if(!zeros) flow <- flow[N > 0]
  
  flow <- flow[, N_from:=.(sum(N)), by = "from"]
  flow <- flow[, N_to:=.(sum(N)), by = "to"]
  flow <- flow[, prop_from:=N/N_from]
  flow <- flow[, prop_to:=N/N_to]
  flow <- flow[order(from, - prop_from)]
  flow <- flow[, rank_from:=seq_len(.N), by = "from"]
  flow <- flow[order(to, - prop_to)]
  flow <- flow[, rank_to:=seq_len(.N), by = "to"]
  flow <- flow[order(from, rank_from)]
  flow <- as.data.frame(flow)
  flow
  
}

