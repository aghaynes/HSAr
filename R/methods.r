#' @export print.hsa
#' @export plot.hsa
#' @export summary.hsa
#' @export validate_hsa

print.hsa <- function(object){
  validate_hsa(object)

  cat(paste("Number of origins                          :", length(unique(object$original_data$from)), "\n"))
  cat(paste("Number of destinations                     :", length(unique(object$original_data$to)), "\n"))
  cat(paste("Number of HSAs created                     :", length(object$names), "\n"))
  cat(paste("Number of iterations                       :", length(object$n_it), "\n"))
  cat(paste("Number of small HSAs (< min_interventions) :", sum(object$n_int < object$min_interventions), "\n"))
  cat(paste("Number of iterations                       :", length(object$n_it), "\n"))

}

plot.hsa <- function(object, hsabcol = "black", regbcol = "grey", lakes = NULL, lakecol = "skyblue", ...){
  validate_hsa(object)

  pars <- par("mai")
  on.exit(suppressWarnings(par(mai = pars)))

  par(mai = c(0,0,0,0))
  plot(object$original_shp, border = regbcol)

  if(!is.null(lakes)) plot(lakes, border = NA, col = lakecol, add = TRUE)

  plot(object$shp, border = hsabcol, add = TRUE, ...)


}

plot.hsa.clust <- function(object, hsabcol = "black", regbcol = "grey", lakes = NULL, lakecol = "skyblue", ...){

  pars <- par("mai")
  on.exit(suppressWarnings(par(mai = pars)))

  par(mai = c(0,0,0,0))
  plot(object$original_shp, border = regbcol)

  if(!is.null(lakes)) plot(lakes, border = NA, col = lakecol, add = TRUE)

  plot(object$shp, border = hsabcol, add = TRUE, ...)


}

summary.hsa <- function(object, li = FALSE, n_interv = FALSE, plot = FALSE, ...){
  validate_hsa(object)

  x <- object$li
  x <- data.frame(HSA = names(x), LI = unlist(x), stringsAsFactors = FALSE, row.names = NULL)
  x <- x[order(-x$LI),]
  x$LI <- sprintf("%4.3f", x$LI)
  # if(nrow(x) > 10){
  #   x <- x[c(1:5, (nrow(x)-5):nrow(x)), ]
  #   x[6,1] <- "..."
  #   x[6,2] <- "..."
  #   # print(x, quote=FALSE, right=TRUE, row.names = FALSE)
  # } #else {
    # print(x, quote=FALSE, right=TRUE)
  # }

  y <- as.data.frame(table(factor(object$reassigned_data$to_hsa, levels = unique(object$lookup$assignment))))
  names(y)[1] <- "HSA"
  y <- y[order(-y$Freq),]

  method <- as.data.frame(table(object$method))

  out <- list(# call = object$call,
              li_threshold = object$li_threshold,
              min_interv = object$min_interventions,
              n_iter = object$iterations,
              shp_reg = nrow(object$original_shp@data),
              shp_reg_from = row.names(object$original_shp)[!row.names(object$original_shp) %in% object$original_data$from],
              shp_reg_to = row.names(object$original_shp)[!row.names(object$original_shp) %in% object$original_data$to],
              shp_src_from = object$original_data$from[!object$original_data$from %in% row.names(object$original_shp)],
              shp_src_to = object$original_data$to[!object$original_data$to %in% row.names(object$original_shp)],
              hsas = unique(object$shp@data$assignment),
              li = x,
              n_interv = y,
              assign = method)

  # cat(paste("Call:\n", out$call, "\n"))
  cat("Criteria\n")
  cat(paste("   Localization Index (LI) threshold:   ", out$li_threshold,"\n"))
  cat(paste("   Minimum interventions:               ", out$min_interv,"\n"))
  cat(paste("Iterations required to satisfy criteria:", out$n_iter,"\n\n"))
  cat("Shapefile\nNumber of regions in original shapefile: ")
  cat(out$shp_reg)
  cat(paste0("\n'shp' regions not in 'from' (", length(out$shp_reg_from),"): \n"))
  cat(out$shp_reg_from)
  cat(paste0("\n'shp' regions not in 'to' (", length(out$shp_reg_to),"): \n"))
  cat(out$shp_reg_from)
  cat(paste0("\n'from' regions not in 'shp' (", length(out$shp_src_from),"): \n"))
  cat(out$shp_src_from)
  cat(paste0("\n'to' regions not in 'shp' (", length(out$shp_src_to),"): \n"))
  cat(out$shp_src_to)
  cat("\n")
  cat(paste0("HSAs generated (", length(out$hsas), "):\n"))
  cat(out$hsas)
  cat("\nRegions assigned to HSAs via:\n")
  print(out$assign, quote=FALSE, right=TRUE, row.names=FALSE)

  cat("\n\nLocalization Index\n")
  print(summary(as.numeric(out$li$LI)))
  if(li){
    cat("\n")
    print(out$li, quote=FALSE, right=TRUE, row.names=FALSE)
  }
  cat("\nInterventions\n")
  print(summary(as.numeric(out$n_interv$Freq)))

  if(n_interv) {
    cat("\n")
    print(out$n_interv, quote=FALSE, right=TRUE, row.names=FALSE)
  }

  if(plot){
    if(class(object) == "hsa"){
      cat("\nCreating 3 plots\n")
      pars <- par("mai")
      on.exit(suppressWarnings(par(mai = pars)))
      # par(mai = c(1.02, 0.82, 0.42, 0.42))
      plot(object$n_it, xlab = "Iteration", ylab = "Number of (proto-)HSAs", las = 1, type = "b")

      # interventions per HSA
      x <- table(factor(object$reassigned_data$to, levels = unique(object$lookup$assignment)))
      x <- x[order(x)]
      plot(x, las = 2, ylab = "Interventions")
      text(x = 1:length(x), y = x, labels = x, srt = 90, pos = 3)
      abline(h = object$min_interventions, col = "red")
      legend("topleft", legend = "Threshold", col = "red", lty = 1, bty = "n")

      # LI
      plot(object$li[order(object$li, na.last = FALSE)], xaxt = "n", ylab = "Localization index", ylim = c(min(min(object$li, na.rm = TRUE), object$li_threshold), max(object$li, na.rm = TRUE)))
      axis(1, at = 1:length(object$li), names(object$li)[order(object$li, na.last = FALSE)], las = 2)
      abline(h = object$li_threshold, col = "red")
      legend("topleft", legend = "Threshold", col = "red", lty = 1, bty = "n")
    }
    if(class(object) == "hsa.clust"){
      cat("\nCreating 1 plot\n")
      plot(object$scree)
    }
  }



}


# print.summary.hsa <- function(object){
#   # cat(paste("---- Automated generation of HSAs ----\n", object$call))
#   cat(paste("Call:\n", object$call, "\n"))
#   cat("Criteria\n")
#   cat(paste("   Localization Index (LI) threshold:   ", object$li_threshold,"\n"))
#   cat(paste("   Minimum interventions:               ", object$min_interv,"\n"))
#   cat(paste("Iterations required to satisfy criteria:", object$n_iter,"\n\n"))
#   cat("Shapefile\nNumber of regions in original shapefile: ")
#   cat(object$shp_reg)
#   cat("\n")
# }

validate_hsa <- function(object){

  if(!is.data.frame(object$lookup))     stop("lookup slot should be data.frame")
  if(!is.list(object$lookups))          stop("lookups slot should be list")
  if(!is.list(object$original_data))    stop("original_data slot should be list")
  if(!is.list(object$reassigned_data))  stop("reassigned_data slot should be list")
  if(!class(object$original_shp) == "SpatialPolygonsDataFrame"){
    stop("original_shp slot should be SpatialPolygonsDataFrame")
  }
  if(!class(object$shp) == "SpatialPolygonsDataFrame"){
    stop("original_shp slot should be SpatialPolygonsDataFrame")
  }
  if(!is.numeric(object$iterations))    stop("iterations slot should be numeric")
  if(!is.numeric(object$li))            stop("li slot should be numeric")
  if(!is.numeric(object$li_threshold))  stop("li_threshold slot should be numeric")
  if(!is.numeric(object$n))             stop("n slot should be numeric")
  if(!is.numeric(object$n_it))          stop("n_it slot should be list")
  if(!is.character(object$names))       stop("names slot should be list")
  if(!is.data.frame(object$flow))       stop("flow slot should be list")

}


# as.SpatialPolygonsDataFrame <- function(object){
#   UseMethod("as.SpatialPolygonsDataFrame", object)
# }
# as.SpatialPolygonsDataFrame.hsa <- function(object){
#   validate_hsa(object)
#   object$shp
# }
#
# as.SpatialPolygons <- function(object){
#   UseMethod("as.SpatialPolygons", object)
# }
# as.SpatialPolygons.hsa <- function(object){
#   validate_hsa(object)
#
# }
