#Team BS - Bart Middelburg & Stijn Beernink
#11-01-2017
#LESSON_3

####THE RULES OF LEAP YEARS
##1-Check if the input(x) is numeric, otherwise give warning
##2-Check if the input(x) is smaller than <1582, because since this year the modern day gregorian calendre was used.

##3-leap years can be divided by 4 and give a round number
##4-leap years can NOT be divided by 100 and give a round number
##5-leap years can be divded by 400 and give a round number
####

#!
####INFO ABOUT THIS R SCRIPT####

#the leap year function will only give TRUE or FALSE ouput. TRUE for leap years, FALSE for NOT leap years.
#This script contains 2 Leap-year functions who both work fine, 
  #-the first one we made at first with only If and Else commands
  #-the second one is made with less statements (more advanced)
#!



#RUN FROM HERE#

##clean working directory
rm(list=ls())

###############################################################################SCRIPT_1#

###name of the leap year function:

is.leap <- function(x)

  ### 1- check if the class is numeric###
  { 
  
  if (!is.numeric(x)) {
    leap <- warning('argument of class numeric expected')
    } 

    else
      {
      ### 2- Check if it is not before 1582
      if (x < 1582) 
          {
          leap <- sprintf(paste(x, 'is out of the valid range')) 
          } 
        
        ### 3- check if it can be divided by 4, if NOT ---> FALSE
        else
              { 
              if((x/4)%%1 != 0)
              {
              leap <- FALSE
              }
          
          ### 4&5- check if: it can be divided by 100, and can not be divided by 400 --> FALSE      
          else
                  {
                  if ((x/100)%%1 == 0 & (x/400)%%1 != 0)
                  {
                  leap <- FALSE
                  }
                    
                    ### The rest ---> TRUE
                    else 
                        {
                        leap <- TRUE
                        }
        
      }
    } }
  
  return(leap)
  
  }


####EXAMPLES####
is.leap(1500)

is.leap(2000)

is.leap(2001)

is.leap(2004)

is.leap(2100)

is.leap("Jon")



##################################################################################SCRIPT 2#

is.leapAD=function(year){
  
  if (!is.numeric(year)) 
  {
    warning('argument of class numeric expected')
  } 
  
  else
  {
    if (year < 1582) 
    {
      sprintf(paste(year, 'is out of the valid range')) 
    } 
    
    else{
      {
        return(((year %% 4 == 0) & (year %% 100 != 0)) | (year %% 400 == 0))
      }
    }}
}


####EXAMPLES####
is.leapAD(1500)

is.leapAD(2000)

is.leapAD(2001)

is.leapAD(2004)

is.leapAD(2100)

is.leapAD("Jon")

