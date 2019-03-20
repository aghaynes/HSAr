#' Minimaps of generated HSAs
#'
#' @param object object of hsa class (i.e. from gen_hsa(...))
#' @param hsa string - a regex expression defining which HSA(s) to plot
#' @param lake shapefile containing lakes (SpatialPolygons format)
#' @param col colour to use for focus area
#' @param bcol HSA border colour
#' @param regbcol colour to use for region borders
#' @param lcol colour to use for lakes
#' @return 
#' @export minimap.hsa
#' @export minimap.default
#' @export minimap.SpatialPolygonsDataFrame
#' @export minimap
#' @examples

minimap <- function(object, ...) UseMethod("minimap", object)

minimap.default <- function() stop("No minimap method for this class type")

minimap.hsa <- function(object, 
                        hsa = NULL, 
                        reg = NULL, 
                        col = "green", 
                        bcol = "blue", 
                        hsalab = TRUE, 
                        hsalabcol = "blue", 
                        regbcol = "grey", 
                        reglab = TRUE, 
                        reglabcol = "black",
                        lakes = NULL, 
                        lcol = "skyblue", 
                        zoomout = 1, 
                        bg = "white", 
                        dev = dev.cur(), ...){
  
  poly <- SpatialPolygons(object$shp@polygons)
  pars <- par("mai")
  on.exit(par(mai = pars))
  par(mai = c(0,0,0,0))
  if(!is.null(hsa)){
    windows(4.5,4.5,restoreConsole=T)
    plot(poly[grepl(hsa, rownames(object$shp@data))])
    x <- par("usr")
    dev.off(dev.cur())
    dev.set(which = dev)
    xwidth <- (x[2] - x[1])*zoomout
    xlims <- c(x[1]-xwidth, x[2]+xwidth)
    ywidth <- (x[4] - x[3])*zoomout
    ylims <- c(x[3]-ywidth, x[4]+ywidth)
    plot(poly[grepl(hsa, rownames(object$shp@data))], col = col, xlim = xlims, ylim = ylims, bg = bg, ...)
    plot(object$shp, add = TRUE)  
    } else if(!is.null(reg)){
    poly <- SpatialPolygons(object$original_shp@polygons)
    plot(poly[grepl(hsa, rownames(object$shp@data))], col = col, bg = bg)
    # if(zoomout){
    #   x <- par("usr")
    #   xwidth <- x[2] - x[1]
    #   xlims <- c(x[1]-xwidth, x[2]+xwidth)
    #   ywidth <- x[4] - x[3]
    #   ylims <- c(x[3]-ywidth, x[4]+ywidth)
    #   plot(poly[grepl(hsa, rownames(object$shp@data))], col = col, xlim = xlims, ylim = ylims)
    # }
    plot(object$shp, add = TRUE) 
  } else {
    plot(object, bg = bg)  
  }
  
  if(!is.null(lakes)) plot(lakes, col = lcol, add = TRUE, border = NA)
  plot(object$original_shp, border = regbcol, add = TRUE)
  plot(object$shp, border = bcol, add = TRUE)
  
  if(reglab){
    co <- coordinates(object$original_shp)
    text(x = co[,1], y = co[,2], labels = rownames(object$original_shp@data), col = reglabcol, cex = .5)
  }
  if(hsalab){
    co <- coordinates(object$shp)
    text(x = co[,1], y = co[,2], labels = rownames(co), col = hsalabcol, cex = 1, font = 2)
  }
}

# minimap(hsas, "GE05")

minimap.hsa.clust <- function(...){
  minimap.hsa(...)
}


minimap.SpatialPolygonsDataFrame <- function(object, 
                                             object2 = NULL, 
                                             polygon = NULL, 
                                             col = "green", 
                                             bcol = "blue", 
                                             lab = TRUE, 
                                             labcol = "blue", 
                                             lakes = NULL, 
                                             lcol = "skyblue", 
                                             zoomout = 1, 
                                             bg = "white", 
                                             object2_bcol = "grey",
                                             object2_lab = TRUE,
                                             object2_labcol = "grey",
                                             dev = dev.cur(), ...){
  
  poly <- SpatialPolygons(object@polygons)
  pars <- par("mai")
  on.exit(par(mai = pars))
  par(mai = c(0,0,0,0))
  if(!is.null(polygon)){
    poly <- poly[which(grepl(polygon, rownames(object@data)))]
    windows(4.5,4.5,restoreConsole=T)
    plot(poly)
    x <- par("usr")
    dev.off(dev.cur())
    dev.set(which = dev)
    xwidth <- (x[2] - x[1])*zoomout
    xlims <- c(x[1]-xwidth, x[2]+xwidth)
    ywidth <- (x[4] - x[3])*zoomout
    ylims <- c(x[3]-ywidth, x[4]+ywidth)
    plot(poly, col = col, xlim = xlims, ylim = ylims, bg = bg)
    plot(object, add = TRUE, border = bcol)  
  } else {
    plot(object, bg = bg, col = col, border = bcol)  
  }
  
  if(!is.null(lakes)) plot(lakes, col = lcol, add = TRUE, border = NA)
  if(!is.null(object2)) {
    plot(object2, border = object2_bcol, add = TRUE)
    if(object2_lab){
      co <- coordinates(object2)
      text(x = co[,1], y = co[,2], labels = rownames(co), col = object2_labcol, cex = 0.5)
    }
  }
  plot(object, border = bcol, add = TRUE)
  
  if(lab){
    co <- coordinates(object)
    text(x = co[,1], y = co[,2], labels = rownames(co), col = labcol, cex = 1, font = 2)
  }
}

# minimap(shp, "JU06", lake = lac_shp)
minimap.SpatialPolygons <- function(...){
  minimap.SpatialPolygonsDataFrame(...)
}


minimap.sf <- function(object, idvar, polygon = NULL, 
                       col = "green", bcol = "blue", 
                       lab = TRUE, labcol = "blue", 
                       lakes = NULL, lcol = "skyblue", 
                       zoomout = 1, bg = "white", 
                       dev = dev.cur(),...){
  pars <- par("mai")
  on.exit(par(mai = pars))
  par(mai = c(0,0,0,0))
  if(!is.null(polygon)){
    poly <- object[which(grepl(polygon, object[, idvar])),]
    windows(4.5,4.5,restoreConsole=T)
    plot(poly)
    x <- par("usr")
    dev.off(dev.cur())
    dev.set(which = dev)
    xwidth <- (x[2] - x[1])*zoomout
    xlims <- c(x[1]-xwidth, x[2]+xwidth)
    ywidth <- (x[4] - x[3])*zoomout
    ylims <- c(x[3]-ywidth, x[4]+ywidth)
    plot(poly$geometry, col = col, xlim = xlims, ylim = ylims, bg = bg)
    plot(object$geometry, add = TRUE, col = NA, border = bcol)  
  } else {
    plot(object$geometry, bg = bg, col = NA, border = bcol)  
  }
  
  if(!is.null(lakes)) plot(lakes, col = lcol, add = TRUE, border = NA)
  plot(object$geometry, border = bcol, add = TRUE, col = NA)
  
  if(lab){
    co <- st_centroid(object)
    geom <- as.character(co$geometry)
    geom <- gsub("^c\\(|,|\\)$", "", geom)
    geom <- strsplit(geom, " ")
    x <- as.numeric(unlist(sapply(geom, function(x)x[1])))
    y <- as.numeric(unlist(sapply(geom, function(x)x[2])))
    text(x = x, y = y, labels = idvar, col = labcol, cex = 1, font = 2)
  }
}
# minimap(sfd4, "medstat", "AG04")
