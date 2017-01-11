
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






