setwd("/Users/jessicaguo/Documents/projects/methods_comparison")

library(dplyr)
library(ggplot2)

# Load Manual data
manual.data <- read.csv("data/trial1/wp.csv")
str(manual.data)

se <- function(x) {sd(x, na.rm = T)/sqrt(length(x))}

sum_WP <- d %>%
  mutate(datetime=as.POSIXct(strptime(datetime, "%m/%d/%Y %H:%M")), 
         date=as.POSIXct(paste0(date," 00:00"), 
                         format="%m/%d/%Y %H:%M")) %>%
  group_by(date) %>%
  summarize(m = mean(negWP, na.rm = T), 
            se = se(negWP),
            sd = sd(negWP))

# Load Automated data
auto_data <- read.csv("data/trial1/psychrometer_append/clean3/new_1b_3.csv")
str(auto_data)

# Plot Data
fig1 <- ggplot()+
  geom_point(filter(auto_data, values > 0.01), 
             aes(x = datetime, y = psy)) +
  geom_point(data = sum_WP, aes(x = date, y = m), 
             stat = "identity", size = 3, col = "red")+
  geom_errorbar(data = sum_WP, 
                aes(x = date, ymin = m - sd, ymax = m + sd), 
                stat = "identity", width = 5)

# Print the plot
fig1

