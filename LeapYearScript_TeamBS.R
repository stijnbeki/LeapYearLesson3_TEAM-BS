##hallo Bart

##dit is het script waarin we onze code kunnen schrijven, 
##Mvg, Stijn

#####THE RULES OF LEAP YEARS#####
##leap years can be divided by 4 and give a round number
##leap years can NOT be divided by 100 and give a round number
##leap years can be divded by 400 and give a round number



#leapyear

#function:

leap <- function(x)
###check if the class is numeric###
  { 
  if (!is.numeric(x)) {
    leap <- sprintf('Object of class numeric expected for x')
  } 

###check if it can be divided by 4###
    else{ 
    if(leap_year <- (x/4)%%1 != 0){
      leap <- sprintf(paste(x, 'is not a leap year'))
    }
      else{
        
      }
###If it cannot be divided by 4 = NOT a leap year, otherwise check for /100 and /400.
      
      
      
      } 
  
  
  
  
  
  
  return(leap)
  
  
  
  }

leap('piet')
