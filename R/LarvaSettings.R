#' A class to hold experiment settings
#'
#' @import methods
#' @exportClass LarvaSettings
setClass (
  "LarvaSettings",
  slots = list(
    Area = "numeric",
    Circularity = "numeric",
    Roundness = "numeric",
    Solidity = "numeric",
    AspectRatio = "numeric",
    minFolder = "numeric",
    maxFolder = "numeric"
  )
)
