# sassy 

<!-- badges: start -->

[![sassy version](https://www.r-pkg.org/badges/version/sassy)](https://cran.r-project.org/package=sassy)
[![sassy lifecycle](https://img.shields.io/badge/lifecycle-maturing-blue.svg)](https://cran.r-project.org/package=sassy)
[![sassy downloads](https://cranlogs.r-pkg.org/badges/grand-total/sassy)](https://cran.r-project.org/package=sassy)
[![Travis build status](https://travis-ci.com/dbosak01/sassy.svg?branch=master)](https://travis-ci.com/dbosak01/sassy)

<!-- badges: end -->

### Introduction <img src="./man/images/cat3.png" align="right" height="138" />

For SAS® programmers, encountering R for the first time can be quite a shock.

* Where is the log?
* Where are my datasets?
* How do I do a data step?
* How do I create a format?
* How do I create a report?

All these basic concepts that were so familiar and easy for you are suddenly 
gone.  How can R possibly be a replacement for SAS®, when it can't even
create a decent log!

If you are in this state of shock, or have asked yourself any of the 
above questions, then the **sassy** system is for you!

The **sassy** system was designed to make R easier for SAS® programmers.
The system brings many familiar SAS® concepts to R.  With the **sassy**
system you can:

* Create a libname
* Create a format catalog
* Do a data step
* Write a report in a few lines of code
* And more!

And all of the above activities can be recorded in a traceable log!  

The **sassy** system totally changes the flow of the typical R script. 
It greatly simplifies the script, significantly reduces the number of lines of code, 
and generally makes the flow more similar to a SAS® program. 

### Installation

The easiest way to install the **sassy** system is to run the following 
command from your R console:

    install.packages("sassy")


Then put the following line at the top of your script:

    library(sassy)


That's it!

The above commands will install and load a set of packages that will allow you
to think about programming in R very much the same way you thought about
programming in SAS®.  

It is not *identical* to SAS®.  R is, after all, 
a very different language.  R is functional, vector-based, and runs
entirely in memory.  As a result, the syntax of **sassy** functions will be 
different than their corresponding SAS® functions.  

The **sassy** functions 
will, however, have a similar feel.  Overall, you will find 
programming with the **sassy** system much more comfortable than programming
in **Base R** or **tidyverse** alone.

### Getting Help

If you need help with the **sassy** family of packages, the best place 
to turn to is the [r-sassy](http://www.r-sassy.org) web site.  
This web site offers many examples, and full
documentation on every function.  

If you need additional help, please turn 
to [stackoverflow.com](https://stackoverflow.com).  The stackoverflow 
community will be very willing to answer your questions.  

### Next Steps

Next, you should read the [Get started](http://sassy.r-sassy.org/articles/sassy.html)
page, and look at some examples.  From these pages, you will be able to 
link into each of the packages included in the **sassy** system, and explore them
in depth.  

Have fun!
