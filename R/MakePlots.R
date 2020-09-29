#' Calculate larval growth
#'
#' Plot larval growth
#'
#' @param larvalcount Number of objects to process
#' @param targetpath Where to load the data from
#' @param binwindow bin width
#' @export
plotGrowth <- function(larvalcount, targetpath, binwindow=180) {
  for (k in 1:larvalcount) {
    csvpath = paste(targetpath, "Larva", as.character(k), "_all.csv", sep = "")
    LarvaLodge_End <- read.csv (csvpath, sep = ",")

    Growth_Data <- Growth_median (LarvaLodge_End, binwindow)
    Growth_Data <- Growth(LarvaLodge_End, binwindow)
    Growth_Table <- data.frame(1:length(Growth_Data))
    Growth_Table$ID <- as.numeric (1:length(Growth_Data))
    Growth_Table <- Growth_Table[-c(1)]
    Growth_Table$Area <- Growth_Data

    tiffpath = paste (targetpath, "Larva", as.character(k), "_growth.tiff")
    tiff(tiffpath, units = "in", height = 7, width = 12, res = 300)

    plot_Growth <- ggplot2::ggplot(Growth_Table, aes(ID, Area)) +
      geom_line(aes(x = ID, y = Area), colour = "red") +
      labs (y = "Size in pixel", x = "Time in h") +
      ggtitle ("Larval Growth")

    print(plot_Growth)
    dev.off()

    csvpath = paste(targetpath, "Larva", as.character(k), "_growth.csv",sep = "")
    write.csv (Growth_Table, csvpath)
    #return plot_Growth
  }
}

#' Calculate larval length
#'
#' Plot larval length
#'
#' @param larvalcount Number of objects to process
#' @param targetpath Where to load the data from
#' @param binwindow bin width
#' @export
plotLength <- function(larvalcount, targetpath, binwindow=180) {
  for (k in 1:larvalcount) {
    csvpath = paste(targetpath, "Larva", as.character(k), "_all.csv", sep = "")
    LarvaLodge_End <- read.csv(csvpath, sep = ",")

    Growth_Data_Major <- Length_median(LarvaLodge_End, binwindow)

    Growth_Table <- data.frame(1:length(Growth_Data))
    Growth_Table$ID <- as.numeric (1:length(Growth_Data))
    Growth_Table <- Growth_Table[-c(1)]
    Growth_Table$Area <- Growth_Data

    Growth_Data_Major$Length <- (Growth_Data_Majo$Major*10/300)

    tiffpath = paste (targetpath, "Larva", as.character(k), "_length.tiff")
    tiff(tiffpath, units = "in", height = 7, width = 12, res = 300)

    plot_Length <- ggplot2::ggplot(Growth_Table, aes(ID, Area)) +
      geom_line(aes(x = ID, y = Area), colour = "red") +
      labs (y = "Length in mm", x = "Time in h") +
      ggtitle ("Larval Length")

    print(plot_Length)
    dev.off()

    csvpath = paste(targetpath, "Larva", as.character(k), "_length.csv" , sep = "")
    write.csv (Growth_Table, csvpath)
  }
}

#' Calculate larval movement
#'
#' Plot larval movement
#'
#' @param larvalcount Number of objects to process
#' @param targetpath Where to load the data from
#' @param binwindow bin width
#' @export
plotMovement <- function(larvalcount, targetpath, binwindow=180) {
  for (k in 1:larvalcount) {
    csvpath = paste(targetpath, "Larva", as.character(k), "_all.csv", sep = "")
    LarvaLodge_End <- read.csv (csvpath, sep = ",")

    Movement_Data <- Movement(LarvaLodge_End, binwindow)

    Movement_Table <- data.frame(1:length(Movement_Data))
    Movement_Table$ID <- as.numeric (1:length(Movement_Data))
    Movement_Table <- Movement_Table[-c(1)]
    Movement_Table$Activity <- as.numeric (1:length(Movement_Data))
    Movement_Table$Activity <- Movement_Data

    tiffpath = paste (targetpath, "Larva", as.character(k), "_movement.tiff")
    tiff(tiffpath, units = "in", height = 7, width = 12, res = 300)

    plot_Movement <- ggplot2::ggplot(Movement_Table, aes(ID, Activity)) +
      geom_line(aes(x = ID, y = Activity, colour = "red")) +
      labs (y = "Movement in pixel", x = "Time in h") +
      ggtitle ("Larval Movement")

    print(plot_Movement)
    dev.off()

    csvpath = paste(targetpath, "Larva", as.character(k), "_movement.csv", sep = "")
    write.csv (Movement_Table,csvpath)
  }
}

#' Calculate distance
#'
#' Plot distance, run plotMovement first
#'
#' @param larvalcount Number of objects to process
#' @param targetpath Where to load the data from
#' @param binwindow bin width
#' @export
plotDistance <- function(larvalcount, targetpath, binwindow=180) {
  for (k in 1:larvalcount) {
    csvpath = paste(targetpath, "Larva", as.character(k), "_movement.csv",sep = "")

    LarvaLodge_End <- read.csv (csvpath, sep = ",")

    Distance <- Movement_Distance(LarvaLodge_End, 180)

    Distance_Table <- data.frame(1:length(Distance))
    Distance_Table$ID <- as.numeric (1:length(Distance))
    Distance_Table <- Distance_Table[-c(1)]
    Distance_Table$Activity <- as.numeric (1:length(Distance))
    Distance_Table$Activity <- Distance

    tiffpath = paste (targetpath, "Larva", as.character(k), "_distance.tiff")
    tiff(tiffpath, units = "in", height = 7, width = 12, res = 300)

    plot_distance <- ggplot2::ggplot(Distance_Table, aes(ID, Activity)) +
      geom_line(aes(x = ID, y = Activity, colour = "red")) +
      labs (y = "Distance in pixel", x = "Time in h") +
      ggtitle ("Larval Movement Distance")

    print(plot_distance)
    dev.off()

    csvpath = paste(targetpath, "Larva", as.character(k), "_distance.csv",sep = "")
    write.csv (Distance_Table, csvpath)
  }
}

#' Calculate speed
#'
#' Plot speed
#'
#' @param larvalcount Number of objects to process
#' @param targetpath Where to load the data from
#' @param binwindow bin width
#' @export
plotSpeed <- function(larvalcount, targetpath, binwindow=180) {
  for (k in 1:larvalcount) {
    csvpath = paste(targetpath, "Larva", as.character(k), "_movement.csv", sep = "")

    LarvaLodge_End <- read.csv (csvpath, sep = ",")

    Speed <- Movement_Speed(LarvaLodge_End, binwindow)

    Speed_Table <- data.frame(1:length(Speed))
    Speed_Table$ID <- as.numeric (1:length(Speed))
    Speed_Table <- Speed_Table[-c(1)]
    Speed_Table$Activity <- as.numeric (1:length(Speed))
    Speed_Table$Activity <- Speed

    tiffpath = paste (targetpath, "Larva", as.character(k), "_Speed.tiff")
    tiff(tiffpath, units = "in", height = 7, width = 12, res = 300)

    plot_Speed <- ggplot(Speed_Table, aes(ID, Activity)) +
      geom_line(aes(x = ID, y = Activity, colour = "red")) +
      labs (y = "Speed in pixel", x = "Time in h") +
      ggtitle ("Larval Movement Speed")

    print(plot_Speed)
    dev.off()

    csvpath = paste(targetpath, "Larva", as.character(k), "_Speed.csv", sep = "")
    write.csv (Speed_Table, csvpath)
  }
}

#' Create all plots
#'
#' Create all plots and save all output
#'
#' @param larvalcount Number of objects to process
#' @param targetpath Where to load the data from
#' @param binwindow bin width
#' @export
plotAll <- function(larvalcount, targetpath, binwindow=180) {
  plotGrowth(larvalcount, targetpath, binwindow=180)
  plotLength(larvalcount, targetpath, binwindow=180)
  plotMovement(larvalcount, targetpath, binwindow=180)
  plotDistance(larvalcount, targetpath, binwindow=180)
  plotSpeed(larvalcount, targetpath, binwindow=180)
}
