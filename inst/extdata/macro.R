

#%let a <- 1
#%let b <- %sysfunc(&a + 1)

#%if (&b > &a)
x <- TRUE
#%else
x <- FALSE
#%end

y <- 0

#%do idx = 1 %to 3
y <- y + 1
#%end

