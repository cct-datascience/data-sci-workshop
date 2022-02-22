#Data manipulation with dplyr and tidyr

#Load libraries
library(readr)
library(dplyr)
library(udunits2) #for converting
library(tidyr)

#Read in
surveys <- readr::read_csv("data_raw/portal_data_joined.csv")
str(surveys)

# Restrict rows with filter()
filter(surveys, genus == "Neotoma")
filter(surveys, year == 1977)

# Restrict columns with select()
select(surveys,record_id, species_id, weight)
select(surveys,-record_id, -species_id, -day)

# Linking together functions piping
surveys %>%
  filter(year == 1995) %>%
  select(-record_id, -species_id, -day) %>%
  head(2)

# Making a new calculated columns with mutate()
surveys %>%
  select(-record_id, -month, -day, -plot_id, -taxa, -plot_type) %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight/1000,
         weight_lb = ud.convert(weight,"kg","lb"))

# Challenge 1
species <- surveys %>%
  filter(!is.na(hindfoot_length)) %>%
  mutate(hindfoot_cm = ud.convert(hindfoot_length,"mm","cm")) %>%
  filter(hindfoot_cm < 3) %>%
  select(species_id,hindfoot_cm)

# Split-apply-combine with group_by() and summarize()
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
          sd_weight = sd(weight),
          max_weight = max(weight)) %>%
  arrange(desc(max_weight))

# Count options
#Using dyplr function
surveys %>%
  count(sex, species_id)

#Using R base function
table(surveys$sex)
table(surveys$sex, surveys$species_id)

# Reshaping data with pivot_wider() and pivot_longer()
surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))

surveys_wide <- surveys_gw %>%
  tidyr:: pivot_wider(names_from = genus,
                      values_from = mean_weight)

surveys_long <- surveys_wide %>%
  tidyr::pivot_longer(-plot_id,
                      names_to = "genus",
                      values_to = "mean_weight")

# Challenge 2
surveys_year <- surveys %>%
  group_by(plot_id, year) %>%
  summarize(genera_count = n_distinct(genus))

surveys_year_wide <- surveys_year %>%
  tidyr:: pivot_wider(names_from = year,
                      values_from = genera_count)

# Alternate way of Challenge 2
surveys %>%
group_by(plot_id, year) %>%
summarize(genera_count = n_distinct(genus))%>%
tidyr:: pivot_wider(names_from = year,
                      values_from = genera_count)

# Exploring filtered data
# Goal: data set to plot change in species in abundance over time
surveys_complete <- surveys %>%
  filter(!is.na(weight), 
         !is.na(hindfoot_length),
         !is.na(sex))

# Most common species
species_counts <- surveys_complete %>%
  count(species_id) %>%
  filter(n >50)

# Only keep the most common species
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)
  
readr:: write_csv(surveys_complete, file = "data_clean/surveys_complete.csv")

