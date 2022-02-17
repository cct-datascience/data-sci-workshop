# Data manipulation with dplyr and tidyr

# Load libraries
library(readr)
library(dplyr)
library(udunits2) # for converting units
library(tidyr)

# Read in csv
surveys <- readr::read_csv("data_raw/portal_data_joined.csv")
str(surveys)

# Restrict rows with filter()
dplyr::filter(surveys, genus == "Neotoma")

# Restrict columns with select()
dplyr::select(surveys, record_id, species_id, weight)

select(surveys, -record_id, -species_id, -day)

# Linking together functions with piping
surveys_1995 <- surveys %>%
  filter(year == 1995) %>%
  select(-record_id, -species_id, -day)

# Making a new calculated column with mutate()
surveys %>%
  select(-record_id, -month, -day, -plot_id, -taxa, -plot_type) %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight/1000,
         weight_lb = ud.convert(weight_kg, "kg", "lb"))

# Split-apply-combine with group_by() and summarize()
surveys %>%
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            sd_weight = sd(weight),
            max_weight = max(weight),
            n = n()) %>%
  arrange(desc(max_weight))

# A few options for counting
surveys %>%
  count(sex, species_id)

# Reshaping data with pivot_wider() and pivot_longer()
surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))


surveys_wide <- surveys_gw %>%
  tidyr::pivot_wider(names_from = genus,
                     values_from = mean_weight)

surveys_long <- surveys_wide %>%
  tidyr::pivot_longer(-plot_id,
                      names_to = "genus",
                      values_to = "mean_weight")

# Exporting filtered data
# Goal: data set to plot change in species abundance over time
surveys_complete <- surveys %>%
  filter(!is.na(weight),
         !is.na(hindfoot_length),
         !is.na(sex))

# Most common species
species_counts <- surveys_complete %>%
  count(species_id) %>%
  filter(n > 50)

# Only keep the  most common species
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)

readr::write_csv(surveys_complete, file = "data_clean/surveys_complete.csv")
