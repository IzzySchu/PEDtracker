# Default settings for different larval stages
Settings <-
  list (
    new(
      "LarvaSettings",
      Area = 50,
      Circularity = c(0.3, 0.9),
      Roundness = 0.5,
      Solidity = c(0.3, 0.95),
      AspectRatio = 2,
      minFolder = 1,
      maxFolder = 10
    ),
    new(
      "LarvaSettings",
      Area = 450,
      Circularity = c(0.4, 0.9),
      Roundness = 0.5,
      Solidity = c(0.3, 0.95),
      AspectRatio = 2,
      minFolder = 11,
      maxFolder = 20
    ),
    new(
      "LarvaSettings",
      Area = 1050,
      Circularity = c(0.4, 0.9),
      Roundness = 0.5,
      Solidity = c(0.5, 0.95),
      AspectRatio = 3,
      minFolder = 21,
      maxFolder = 99
    )
  )
