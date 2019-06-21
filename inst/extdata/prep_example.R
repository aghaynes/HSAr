library(HSAr)
options(stringsAsFactors = FALSE)

# create regions

A <- Polygons(list(Polygon(cbind(c(0, 1, 1, 0, 0),
                                 c(0, 0, 4, 4, 0)))), "A")
B <- Polygons(list(Polygon(cbind(c(1, 3, 3, 2, 2, 1, 1),
                                 c(0, 0, 2, 2, 1, 1, 0)))), "B")
C <- Polygons(list(Polygon(cbind(c(3, 6, 6, 3, 3),
                                 c(0, 0, 1, 1, 0)))), "C")
D <- Polygons(list(Polygon(cbind(c(6, 8, 8, 6, 6, 7, 7, 6, 6),
                                 c(0, 0, 3, 3, 2, 2, 1, 1, 0)))), "D")
E <- Polygons(list(Polygon(cbind(c(3, 7, 7, 3, 3),
                                 c(1, 1, 2, 2, 1)))), "E")
G <- Polygons(list(Polygon(cbind(c(1, 2, 2, 5, 5, 2, 2, 1, 1),
                                 c(1, 1, 2, 2, 3, 3, 5, 5, 1)))), "G")
H <- Polygons(list(Polygon(cbind(c(0, 1, 1, 0, 0),
                                 c(4, 4, 10, 10, 4)))), "H")
I <- Polygons(list(Polygon(cbind(c(0, 1, 1, 0, 0),
                                 c(10, 10, 11, 11, 10)))), "I")
J <- Polygons(list(Polygon(cbind(c(2, 3, 3, 2, 2),
                                 c(3, 3, 7, 7, 3)))), "J")
K <- Polygons(list(Polygon(cbind(c(3, 5, 5, 3, 3),
                                 c(3, 3, 4, 4, 3)))), "K")
L <- Polygons(list(Polygon(cbind(c(5, 6, 6, 5, 5),
                                 c(2, 2, 5, 5, 2)))), "L")
M <- Polygons(list(Polygon(cbind(c(6, 8, 8, 6, 6),
                                 c(3, 3, 5, 5, 3)))), "M")
N <- Polygons(list(Polygon(cbind(c(3, 4, 4, 5, 5, 3, 3),
                                 c(4, 4, 6, 6, 7, 7, 4)))), "N")
O <- Polygons(list(Polygon(cbind(c(4, 5, 5, 8, 8, 4, 4),
                                 c(4, 4, 5, 5, 6, 6, 4)))), "O")
P <- Polygons(list(Polygon(cbind(c(1, 2, 2, 6, 6, 1, 1),
                                 c(5, 5, 7, 7, 8, 8, 5)))), "P")
Q <- Polygons(list(Polygon(cbind(c(5, 7, 7, 5, 5, 6, 6, 5, 5),
                                 c(6, 6, 9, 9, 8, 8, 7, 7, 6)))), "Q")
R <- Polygons(list(Polygon(cbind(c(7, 8, 8, 7, 7),
                                 c(6, 6, 9, 9, 6)))), "R")
S <- Polygons(list(Polygon(cbind(c(1, 3, 3, 1, 1),
                                 c(8, 8, 10, 10, 8)))), "S")
T <- Polygons(list(Polygon(cbind(c(3, 5, 5, 4, 4, 3, 3),
                                 c(8, 8, 11, 11, 10, 10, 8)))), "T")
U <- Polygons(list(Polygon(cbind(c(5, 8, 8, 5, 5),
                                 c(9, 9, 11, 11, 9)))), "U")
V <- Polygons(list(Polygon(cbind(c(1, 4, 4, 1, 1),
                                 c(10, 10, 11, 11, 10)))), "V")


Sp <- SpatialPolygons(list(A, B, C, D, E, G, H, I, J, K, L, M, N, O, P, Q, R, S, T, U, V))
plot(Sp)

z <- LETTERS[1:22]
z <- z[z != "F"]
df <- data.frame(reg = z,
                 x = rnorm(length(z), 100, 10),
                 stringsAsFactors = FALSE,
                 row.names = z)

shape <- SpatialPolygonsDataFrame(Sp, df)
plot(shape)
save(shape, file = "data/shape.rda")
l <- ls()
rm(list = l[!l %in% "shape"])
writePolyShape(shape, "inst/extdata/shape")
minimap(shape)

# simulate flow data
# No flow from N to anywhere
# hospitals in S, J, O, C
na <- 40
nb <- 100
nc <- 66
nd <- 67
ne <- 82
nf <- 10
ng <- 44
nh <- 67
ni <- 21
nj <- 34
nk <- 56
nl <- 59
nm <- 20
nn <- 0
no <- 48
np <- 98
nq <- 78
nr <- 67
ns <- 78
nt <- 89
nu <- 91
nv <- 30

hosps <- c("S", "J", "O", "C")

set.seed(12345)
flow <- data.frame(from = rep("I", ni),
                   to = sample(hosps, ni,
                               prob = c(.6, .2, .1, .1),
                               replace = TRUE))
flow <- rbind(flow,
              data.frame(from = rep("A", na),
                         to = sample(hosps, na,
                                     prob = c(.05, .2, .1, .8),
                                     replace = TRUE)),
              data.frame(from = rep("B", nb),
                         to = sample(hosps, nb,
                                     prob = c(.1, .3, .1, .9),
                                     replace = TRUE))
              ,
              data.frame(from = rep("C", nc),
                         to = sample(hosps, nc,
                                     prob = c(.1, .1, .1, .95),
                                     replace = TRUE)),
              data.frame(from = rep("D", nd),
                         to = sample(hosps, nd,
                                     prob = c(.1, .2, .1, .6),
                                     replace = TRUE)),
              data.frame(from = rep("E", ne),
                         to = sample(hosps, ne,
                                     prob = c(.2, .3, .1, .8),
                                     replace = TRUE)),
              data.frame(from = rep("G", ng),
                         to = sample(hosps, ng,
                                     prob = c(.2, .5, .2, .5),
                                     replace = TRUE)),
              data.frame(from = rep("H", nh),
                         to = sample(hosps, nh,
                                     prob = c(.6, .4, .2, .1),
                                     replace = TRUE)),
              data.frame(from = rep("I", ni),
                         to = sample(hosps, ni,
                                     prob = c(.6, .2, .2, .1),
                                     replace = TRUE)),
              data.frame(from = rep("J", nj),
                         to = sample(hosps, nj,
                                     prob = c(.4, .8, .2, .3),
                                     replace = TRUE)),
              data.frame(from = rep("K", nk),
                         to = sample(hosps, nk,
                                     prob = c(.2, .7, .2, .3),
                                     replace = TRUE)),
              data.frame(from = rep("L", nl),
                         to = sample(hosps, nl,
                                     prob = c(.1, .4, .5, .1),
                                     replace = TRUE)),
              data.frame(from = rep("M", nm),
                         to = sample(hosps, nm,
                                     prob = c(.1, .2, .3, .5),
                                     replace = TRUE)),
              data.frame(from = rep("O", no),
                         to = sample(hosps, no,
                                     prob = c(.1, .9, .4, .1),
                                     replace = TRUE)),
              data.frame(from = rep("Q", np),
                         to = sample(hosps, np,
                                     prob = c(.6, .6, .3, .1),
                                     replace = TRUE)),
              data.frame(from = rep("R", nr),
                         to = sample(hosps, nr,
                                     prob = c(.4, .4, .4, .4),
                                     replace = TRUE)),
              data.frame(from = rep("S", ns),
                         to = sample(hosps, ns,
                                     prob = c(.6, .2, .2, .1),
                                     replace = TRUE)),
              data.frame(from = rep("T", nt),
                         to = sample(hosps, nt,
                                     prob = c(.9, .1, .1, .1),
                                     replace = TRUE)),
              data.frame(from = rep("U", nu),
                         to = sample(hosps, nu,
                                     prob = c(.6, .2, .2, .1),
                                     replace = TRUE)),
              data.frame(from = rep("V", nv),
                         to = sample(hosps, nv,
                                     prob = c(.6, .2, .2, .1),
                                     replace = TRUE))
              )


save(flow, file = "data/flow.rda")
