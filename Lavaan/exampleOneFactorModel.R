# Install these two packages if necessary
# install.packages("lavaan") 
# install.packages("semPlot")
# initialise lavaan and semPlot
require(lavaan)
require(semPlot)

# file.choose() # Use to find working directory
# Use to set working directory
setwd("REPLACE WITH YOUR FILEPATH")

# Specify variables in model
model <- 'g =~ Ravens + Vocab + DSpan + Arith + WordSum'

# Read in data from text file
a=read.table("data.txt", sep='\t', header=T) # head(a); View(a)

# fit model named “model” to data in variable “a”
fit = sem(model, data=a)

#Plot the path diagram
semPaths(fit, "std", edge.label.cex=1, curvePivot=TRUE, layout="tree")

# print summary statistics and goodness of fit
summary(fit, standardized=TRUE, rsq=T)
fitMeasures(fit)

# Optional: display model in Onyx (if installed)
library(onyxR)
onyx(fit)
