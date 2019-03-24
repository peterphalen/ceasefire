# For reasons that are unclear, Baltimore Open Data recently 
# erased all their data on crime pre-2014. Fortunately, I had backed 
# up a copy of the pre-2014 data. This script combines the back-up
# with the newer data

library(tidyverse)

setwd("/Users/peterphalen/Documents/ceasefire/")

bpd1 <- read_csv("pre2015_BPD_Part_1_Victim_Based_Crime_Data.csv")
bpd1$CrimeDate <- as.Date(bpd1$CrimeDate, format = "%m/%d/%Y")

bpd2 <- read_csv("post2015_BPD_Part_1_Victim_Based_Crime_Data.csv")
bpd2$CrimeDate <- as.Date(bpd2$CrimeDate, format = "%m/%d/%Y")

#------Verify that the overlap between datasets is roughly identical-----#
check1 <- subset(bpd1, Description == "SHOOTING" |
                (Description == "HOMICIDE" & Weapon == "FIREARM"))
check1 <- check1 %>% group_by(CrimeDate) %>% summarise(shootings = n())
check1 <- subset(check1, CrimeDate > as.Date("2016-01-01") & 
                   CrimeDate < as.Date("2018-01-01") )

check2 <- subset(bpd2, Description == "SHOOTING" |
                   (Description == "HOMICIDE" & Weapon == "FIREARM"))
check2 <- check2 %>% group_by(CrimeDate) %>% summarise(shootings = n())
check2<- subset(check2, CrimeDate > as.Date("2016-01-01") & 
                  CrimeDate < as.Date("2018-01-01") )

stopifnot(check1 == check2)
#------------------------------------------------------------------------#

bpd1 <- subset(bpd1, CrimeDate < as.Date("2019-01-01"))
bpd2 <- subset(bpd2, CrimeDate >= as.Date("2019-01-01"))

full.bpd <- rbind(bpd1, bpd2)

# enforce ordering by date, just in case
full.bpd <- full.bpd[order(full.bpd$CrimeDate),]

write_csv(full.bpd, "BPD_Part_1_Victim_Based_Crime_Data.csv")

