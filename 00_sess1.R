rm(list=ls())
library(mlogit)
library(tidyverse)


# I read until Section 2 of Berry & Haile (2021). 
# I've bought their arguments for why LATE doesn't cut it for demand estimation 
# (Can't hold the shocks fixed even with randomization; 
# so, SOO or FE are cursed by dimensionality).
# Then I read Section 3 but felt unsatisfied. 
# I want to see it for myself before I believe it...

# So starting with Croissant (2020)

#Section 2----

##Train dataset----
data("Train", package='mlogit')
#Just because choiceid is 1 doesn't mean its the same choice for all persons. 
#I check this with a call to distinct.
#So better to treat them as distinct choice situations
Train$choiceid <- 1:nrow(Train)
# View(Train)

# Data is in the "wide" format but we want it "long" (i.e) dplyr::pivot_longer()
Tr <- dfidx(Train, shape = 'wide', choice = 'choice', varying = 4:11, 
            sep='_', idx = list(c('choiceid', 'id')), 
            idnames = c("chid", 'alt'))

#Scaling unitsl; euros and hours
Tr$price <- Tr$price / 100 * 2.20371
Tr$time <- Tr$time / 60
# Tr |> View()

##ModeCanada dataset----
data("ModeCanada", package='mlogit')
# ModeCanada |> View()
#I think this dfidx thing is just some kind of annotation/metadata.
#This is the same thing as the dataframework I often create?
MC <- dfidx(ModeCanada, subset = noalt == 4, 
            xalt.levels = c('train', 'air', 'bus', 'car'))
# MC |> View()

#Really useful notes on jargon and notation in 2.2.
#Good for noobs like me to know at the outset and not get stuck later.

library(Formula)
# f <- Formula(choice ~ cost | income | ivt)
# ls()
#Funny. There is an error. But the object still exists?!
#I am not going to declare the formula separately to avoid this nonsense.

#Interestingly not mentioning xalt.levels leads to a different model.matrix
#Wonder why...
# MC <- dfidx(ModeCanada, subset = noalt == 4, 
#             xalt.levels = c('train', 'air', 'bus', 'car'))
MC <- dfidx(ModeCanada, subset = noalt == 4, pkg='mlogit')
mf <- model.frame(MC, Formula(choice ~ cost | income | ivt))
head(model.matrix(mf))
