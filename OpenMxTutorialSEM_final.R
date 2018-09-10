#-------------initialise and load data--------------
#install openmx if need be
#if it asks install from source y or n, try y, if that doesn't work, rerun and select n
#install.packages("OpenMx")
#install.packages("Onyx")

#initialise openmx
#note that using require is designed for use inside other functions (unlike library()) ie it errors differently
require(OpenMx)

#example data set taken from the Open Mx User guide with renamed variables
#Note replace the filepath with your own filepath where the data are stored
#run file.choose() in the console to find your data
setwd("REPLACE WITH YOUR FILEPATH")
OneFactorData <- read.csv('demoOneFactor.csv', header = TRUE)
View(OneFactorData)

#--------------create variables, paths and residuals--------------
#set up variables that contain lists of the manifest and latent variable names
manifests <- c("Ravens","Vocab","DSpan", "Arith", "WordSum")
latents <- c("g")

#paths between latents to manifests
g_FreePaths <- mxPath(from="g", to=c("Ravens","Vocab","DSpan", "Arith", "WordSum"), arrows=1)

#Note you could also fix a path to be one to scale the latent to that manifest variable 
#but then take WordSum out of the previous free paths variable 
#and add this fixed path variable to the model later on where you add the free paths variable
#g_FixedPaths <- mxPath(from="g", to="WordSum", arrows=1, free=FALSE, values=1.0)

#add a residual to each manifest variable i.e. error
residuals <- mxPath(from=manifests, arrows = 2, labels = c("e1", "e2", "e3", "e4", "e5"))

#constraint latent variance to be 1
g_variance <- mxPath(from="g", arrows = 2, free = FALSE, values = 1.0)

#--------------build model--------------
#build model
#mXData tells it where to get the data and whether it's raw or cov data (recommended), or cor matrix (not recommended)
factorOneFactorModel <- mxModel(name = "Intelligence model",type ="RAM",
                            manifestVars = manifests, latentVars = latents,
                            g_FreePaths, g_variance, residuals,
                            mxData(observed=cov(OneFactorData), type="cov", numObs=500))

#run model and summarise model output
factorOneFactorModel <- mxRun(factorOneFactorModel)
summary(factorOneFactorModel)

#--------------OPTIONAL!! plot model in Onyx--------------
#require(onyxR)
#onyx(factorOneFactorModel)