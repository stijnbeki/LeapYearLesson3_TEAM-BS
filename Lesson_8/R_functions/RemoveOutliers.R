RemoveOutliers = function(D_ata)
{ 
  mean <- cellStats(x = D_ata, stat = 'mean')
  std_dev4 <- 4*(cellStats(x = D_ata, stat = 'sd'))
  lowerbound <- mean - std_dev4
  upperbound <- mean + std_dev4
  D_ata[D_ata > upperbound] <- NA
  D_ata[D_ata < lowerbound] <- NA
  
  return(D_ata)
    }