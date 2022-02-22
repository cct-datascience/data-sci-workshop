library(tidyverse)
library(udunits2)

surveys <- read.csv("data_raw/portal_data_joined.csv")
surveys <- as_tibble(surveys)

# Mutate
surveys %>% 
  select(-record_id, -month, -day, -plot_id, -taxa, -plot_type) %>% 
  mutate(weight_kg = weight / 1000,
         weight_lb = ud.convert(weight, "g", "lb"))

surveys %>% 
  mutate(hindfoot_cm = hindfoot_length / 10) %>% 
  select(species_id, hindfoot_cm) %>% 
  filter(hindfoot_cm > 3) %>% 
  filter(!is.na(hindfoot_cm))

surveys.gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>% 
  summarize(mean_weight = mean(weight))

# Pivot_longer, pivot_wider
surveys_wide <- surveys.gw %>% 
  pivot_wider(names_from = genus,
              values_from = mean_weight)

surveys_long <- surveys_wide %>% 
  pivot_longer(-plot_id,
               names_to = "genus",
               values_to = "mean_weight")

# 2/17/22
# Exporting filtered data
surveys_complete <- surveys %>% 
  filter(!is.na(weight), 
         !is.na(hindfoot_length),
         !is.na(sex))

# Most common species
species_count <- surveys_complete %>% 
  count(species_id) %>% 
  filter(n > 50)

surveys_complete <- surveys_complete %>% 
  filter(species_id %in% species_count$species_id)

write_csv(surveys_complete,
          file = "data_clean/surveys_complete.csv")
