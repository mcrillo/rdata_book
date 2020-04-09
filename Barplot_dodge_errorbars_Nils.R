### Author: Nils Hintz
### Date: 06/April/2020

library(ggplot2)
library(plyr)

# Problem: dodged barplot with individuall errorbars --------------------


# I build up some very simple dataset, which is usefull for ecologist:
#with treatment, replicate annotation and a response (e.g. measured variable/nutrient)

treatment <- c('high','high','high', 'low','low','low', 'median','median','median')
replicate_no <- rep(1:3,3)
response <- c('1','2','4','2','3','5','7','9','10','9','9','10','4','3','1','6','8','7')
timepoint <- c(1,1,1,1,1,1,1,1,1,2,2,2,2,2,2,2,2,2)

dataset <- data.frame(timepoint,treatment, replicate_no, response) 
dataset$response <- as.numeric(dataset$response)
dataset$timepoint <- as.factor(dataset$timepoint)

#allready now there are lots of datapoints, for a better illustration you want to average your replicates
#geom_bar would do this by itself if you want to. But it does not calculate standard deviation and errorbars
#and often  you need averaged values for other statitical tests.

dataset<-ddply(dataset,c("timepoint","treatment"), summarise,
               mean_resp = mean(response,na.rm=TRUE),
               sd_resp   = sd(response, na.rm=TRUE))

#lets plot our simplified dataset
ggplot(data = dataset, aes(x = timepoint, y=mean_resp, fill= treatment)) + #here the aesthetics are in the ggplot function itself! Hence subordinated, which is necessary if you want to assign individual colors with scale_color_manual()
  geom_bar(stat="identity",  position = "dodge")


#but we want an information to our data variabiliy = SD. Usually done as Errorbars
ggplot(data = dataset, aes(x = timepoint, y=mean_resp, fill= treatment)) + #here the aesthetics are in the ggplot function itself! Hence subordinated, which si necessary if you want to assign individual colors with scale_color_manual()
  geom_bar(stat="identity",  position = "dodge")+
  geom_errorbar(aes(ymin=mean_resp-sd_resp, ymax=mean_resp+sd_resp), width=0.5)

#you can see, due to the position="dodge" within geom_bar, our Bars are pretty distributed. However this does not apply for the Errorbars.
#here the position_dodge() function helps out.

ggplot(data = dataset, aes(x = timepoint, y=mean_resp, fill= treatment)) + #here the aesthetics are in the ggplot function itself! Hence subordinated, which si necessary if you want to assign individual colors with scale_color_manual()
  geom_bar(stat="identity",  position = "dodge")+
  geom_errorbar(aes(ymin=mean_resp-sd_resp, ymax=mean_resp+sd_resp), width=0.5,
                position=position_dodge(0.9)) #0.9 is like the optimal dodging distance for errorbars. Try other values and see what happens

#for more informations visit: https://ggplot2.tidyverse.org/reference/position_dodge.html
#There are even more beautiful examples
