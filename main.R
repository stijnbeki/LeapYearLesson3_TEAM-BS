#Team BS - Bart Middelburg & Stijn Beernink
#11-01-2017
#LESSON_3

##clean working directory
rm(list=ls())

####THE RULES OF LEAP YEARS
##1-Check if the input(x) is numeric, otherwise give warning
##2-Check if the input(x) is smaller than <1582, because since this year the modern day gregorian calendre was used.

##3-leap years can be divided by 4 and give a round number
##4-leap years can NOT be divided by 100 and give a round number
##5-leap years can be divded by 400 and give a round number

####The functions####

source('R/is.leap.R')     ###This is the first script we made for this assignment, it has a lot of "if" and "ELSE" commands
source('R/is.leapAD.R')   ###This is our newest more advance script, this calculates exactly the same in less code.



####EXAMPLES#### SCRIPT 1
is.leap(1500)
is.leap(2000)
is.leap(2001)
is.leap(2004)
is.leap(2100)
is.leap("Jon")


####EXAMPLES####SCRIPT 2
is.leapAD(1500)
is.leapAD(2000)
is.leapAD(2001)
is.leapAD(2004)
is.leapAD(2100)
is.leapAD("Jon")
