# Data manipulation with dplyr and tidyr

# Load libraries 
library(readr)
library(dplyr)
library(udunits2) # for unit conversions
library(tidyr)

# Read in csv
surveys <- readr::read_csv("data-sci-workshop/data_raw/portal_data_joined.csv") # :: means a function is coming from a particular library
# (read.csv tries to guess columns, tries to ). Read_csv gives you a tibble, not a dataframe (a tibble just plays well in the tidyverse)
str(surveys) # str is structure. Like to check what I am reading in

# Restrict rows with filter()
filter(surveys, genus == "Neotoma") # 

# Restrict columns with select()
select(surveys, record_id, species_id, weight) # the last three are columns, you can just type them out in dplyr but not elsewhere. They are just separated by columns
select(surveys, -record_id, -species_id) # to remove only certain columns put a minus sign in front of the columns

# Liking together functions with piping (you can pipe outside of dplyr but it is different)
surveys_1995 <- surveys %>% 
  filter(year == 1995) %>% # you pipe the tibble into the function and then pipe it again
  select(-record_id, -species_id, -day)

# Making a new calculated column with mutate()
# mutate: left hand size is new col name, right hand side is what you want column to be
# you can't do 
surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight/1000, 
         weight_lb = udunits2::ud.convert(weight, "g", "lb")) # both mutate lines are redundant

# CHALLENGE QUESTION
surveys %>%
  select(species_id, hindfoot_length) %>%
  mutate(hindfoot_cm = hindfoot_length/10) %>% 
  select(-hindfoot_length) %>%
  filter(!is.na(hindfoot_cm), hindfoot_cm < 3)

# Split-apply-combine with group_by() and summarize()
# group_by() says what columns should be grouped together
# summarize is like mutate, but mutate keeps the same number of rows. Summarize generates a new tibble with 
# new dimensions
surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE),
            sd_weight = sd(weight, na.rm = TRUE))

# Or if you get annoyed by na.rm = TRUE
# You can add more columns in group_by!
# desc is a dplyR, allows you to arrange in descending order
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            sd_weight = sd(weight),
            max_weight = max(weight)) %>%
  arrange(desc(max_weight))

# A few options for counting ===========================
surveys %>%
  count(sex, species_id)
# count does group-by and summarize all in one

# Use count instead of trying to understand output from table (harder to work with)
table(surveys$sex, surveys$species_id)

# Use n() to also count
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            sd_weight = sd(weight),
            max_weight = max(weight),
            n = n()) %>%
  arrange(desc(max_weight))

# Reshaping the data ===========================
# We want tabular data to look like:
# Earch row is its own observation

# Reshaping data with pivot_wider() and pivot_longer()
surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))

# Note first argument of pivot_wider is tibble, but we are already piping it in there
# Use pivot_wider to make a simple table
surveys_wide <- surveys_gw %>%
  tidyr::pivot_wider(names_from = genus,
                     values_from = mean_weight)

# Now remake original tibble. You are making new columns so the new column names
# need to be in quotes. Also you need to remove plot_id
surveys_long <- surveys_wide %>% 
  tidyr::pivot_longer(-plot_id,
                      names_to = "genus",
                      values_to = "mean_weight")
# Note surveys_long will have more rows b/c there are more NAs made when making a rectangular 
# table

# CHALLENGE QUESTION
surveys_c <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(year, plot_id) %>%
  summarize(genera_count=n_distinct(genus)) %>%
  pivot_wider(names_from = year,
              values_from = genus)

# Exporting filtered data
# Goal: data set to plot change in species abundance over time
surveys_complete <- surveys %>%
  filter(!is.na(weight),
         !is.na(hindfoot_length),
         !is.na(sex))

# Most common species (automatically makes a column named n w/ count)
species_counts <- surveys_complete %>%
  count(species_id) %>%
  filter(n > 50)

# Only keep the most common species
# %in% 
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)

readr::write_csv(surveys_complete, file = "data_clean/surveys_complete.csv")

  
  
  
  
