#' Calculate larval length
#'
#' This function calculates movement.
#'
#' @param Data_Table Data
#' @param bin_time Binning window
#' @return A vector of movement
#' @export
Growth <- function(Data_Table,bin_time) {
  Growth_submean <- vector (mode = "numeric", length = nrow (Data_Table) / bin_time)

  j <- 0
  for (i in seq(1, nrow(Data_Table), bin_time)) {
    j = j + 1
    subtest <- seq(i, i + bin_time - 1)
    subarea <- Data_Table$Area [subtest]
    submean <- mean (subarea, na.rm=TRUE)
    Growth_submean [j] <- submean
  }
  return (Growth_submean)
}

#' Calculate larval length
#'
#' This function calculates movement.
#'
#' @param Data_Table Data
#' @param bin_time Binning window
#' @return A vector of movement
#' @export
Growth_median <- function(Data_Table,bin_time) {
  Growth_median <- vector (mode = "numeric", length = nrow (Data_Table) / bin_time)

  j <- 0
  for (i in seq(1, nrow(Data_Table), bin_time)) {
    j = j + 1
    subtest <- seq(i, i + bin_time - 1)
    subarea <- Data_Table$Area [subtest]
    submedian<- median (subarea, na.rm=TRUE)
    #print (submean)
    Growth_median [j] <- submedian
  }
  return (Growth_median)
}

#' Calculate larval length
#'
#' This function calculates movement.
#'
#' @param Data_Table Data
#' @param bin_time Binning window
#' @return A vector of movement
#' @export
Length_median <- function(Data_Table, bin_time) {
  Length_median <- vector (mode = "numeric", length = nrow (Data_Table) / bin_time)

  j <- 0
  for (i in seq(1, nrow(Data_Table), bin_time)) {
    j = j + 1
    subtest <- seq(i, i + bin_time - 1)
    submajor <- Data_Table$Major[subtest]
    subsort <- sort(submajor, decreasing = TRUE, na.last = TRUE)
    sublong <- subsort[seq(1, bin_time / 10)]
    submedian <- median (sublong, na.rm=TRUE)
    Length_median [j] <- submedian
  }
  return (Length_median)
}

#' Calculate movement
#'
#' This function calculates movement.
#'
#' @param Data_Table Data
#' @param bin_time Binning window
#' @return A vector of movement
#' @export
Movement <- function(Data_Table, bin_time) {
  larva_move <- vector (mode = "numeric", length = nrow(Data_Table))

  pythagorean <- function (a, b) {
    hypotenuse <- sqrt (a ^ 2 + b ^ 2)
    return (hypotenuse)
  }
  for (i in seq(1, nrow(Data_Table))) {
    X <- Data_Table$X [i] - Data_Table$X [i + 1]
    Y <- Data_Table$Y [i] - Data_Table$Y [i + 1]
    larva_move [i] <- pythagorean(X, Y)
    na.rm=TRUE
  }
  return (larva_move)
}

#' Calculate movement
#'
#' This function calculates movement.
#'
#' @param Data_Table Data
#' @param bin_time Binning window
#' @return A vector of movement
#' @export
Movement_Speed <- function(Data_Table, bin_time) {
  larva_speed <- vector (mode = "numeric", length = nrow(Data_Table) / bin_time)

  j <- 0
  for (i in seq(1, nrow(Data_Table), bin_time)) {
    j = j + 1
    subseq <- seq(i, i + bin_time - 1)
    subspeed <- Data_Table$Activity [subseq]
    submed <- median (subspeed, na.rm=TRUE)
    larva_speed [j] <- submed
  }
  return (larva_speed)
}

#' Calculate movement
#'
#' This function calculates movement.
#'
#' @param Data_Table Data
#' @param bin_time Binning window
#' @return A vector of movement
#' @export
Movement_Distance <- function (Data_Table, bin_time) {
  larva_dist <- vector (mode = "numeric", length = nrow(Data_Table) / bin_time)

  j <- 0
  for (i in seq(1, nrow(Data_Table), bin_time)) {
    j = j + 1
    subseq <- seq(i, i + bin_time - 1)
    subdist <- Data_Table$Activity [subseq]
    subsum <- sum (subdist, na.rm=TRUE)
    larva_dist [j] <- subsum
  }
  return (larva_dist)
}
