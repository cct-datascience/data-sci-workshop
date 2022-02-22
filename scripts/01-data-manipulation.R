# Data manipulation with dplyr and tidyr

# load libraries
library(readr)
library(dplyr)
library(udunits2) #for converting units
library(tidyr)


# read in data
surveys <- read_csv("data_raw/portal_data_joined.csv")
str(surveys)

# restrict rows with filter()
dplyr::filter(surveys, genus == "Neotoma")

# restrict or remove columns with select()
select(surveys, record_id, species_id, weight)
select(surveys, -record_id, -species_id, -day)


# linking functions with piping
  #filter and select simultaneously
  surveys %>%
    filter(year == 1995) %>%
    select(-record_id, -species_id, -day)

# making a new calculated column with mutate()
surveys %>%
  select(-record_id, -month, -day, -plot_id, -taxa, -plot_type) %>%
  filter(!is.na(weight)) %>% #removes lines without weight, so no need for na.rm
  mutate(weight_kg =  weight/1000, 
         weight_lb = ud.convert(weight, "g", "lb"))

# split-apply-combine with group_by() and summarize()
surveys %>%
  filter(!is.na(weight)) %>% 
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            sd_weight = sd(weight),
            max_weight = max(weight),
            n = n()) %>%
  arrange(desc(max_weight))

# counting
surveys %>%
  count(sex, species_id)  #no need for table, group_by, or summarize

# reshaping data with pivot_wider() and pivot_longer()
surveys_gw <- surveys %>%
  filter(is.na(weight)) %>%    #remove NA in weight column
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))

surveys_wide <- surveys_gw %>%
  tidyr::pivot_wider(names_from = genus,
                     values_from = mean_weight) # re-formatted so each plot had a row

  #un-do what we just did, can we get back?
  surveys_long <- surveys_wide %>% 
    tidyr::pivot_longer(-plot_id,
                        names_to = "genus",
                        values_to = "mean_weight")

# exporting filtered data (goal: format a dataset to plot change in species abundance over time)
surveys_complete <- surveys %>%
  filter(!is.na(weight), !is.na(hindfoot_length), !is.na(sex))

  # most common species
  species_counts <- surveys_complete %>%
    count(species_id) %>%
    filter(n > 50) #want to include only species with > 50 observations

  # add most common species dataframe to our data
  surveys_complete <- surveys_complete %>%
    filter(species_id %in% species_counts$species_id)

# write new csv and put it in new 'data clean' folder
readr::write_csv(surveys_complete, file = "data_clean/surveys_complete.csv")




  
  
  
  
  
  
  
  
  
  
  
  
  



