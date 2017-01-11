##hallo Bart

##dit is het script waarin we onze code kunnen schrijven, 
##Mvg, Stijn

#####THE RULES OF LEAP YEARS#####
##leap years can be divided by 4 and give a round number
##leap years can NOT be divided by 100 and give a round number
##leap years can be divded by 400 and give a round number



#leapyear

#function:

is.leap <- function(x)
###check if the class is numeric###
  { 
  
  if (!is.numeric(x)) {
    leap <- warning('argument of class numeric expected')
  } 

      if (x < 1582) {
        leap <- sprintf(paste(x, 'is out of the valid range')) 
                    } 
###check if it can be divided by 4###
    else{ 
    if((x/4)%%1 != 0){
      leap <- FALSE
    }
      else
        {
        if ((x/100)%%1 == 0 & (x/400)%%1 != 0)
        {
         leap <- FALSE
        }
        else 
        {
          leap <- TRUE
        }
        
      }
      } 
  
  return(leap)
  
  }
