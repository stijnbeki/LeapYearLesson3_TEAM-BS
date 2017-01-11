is.leapyear=function(year){
  
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
