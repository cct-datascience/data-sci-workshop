# Data manipulation with dplyr and tidyr 

##### Load libraries #####
library(readr)
library(dplyr)
library(udunits2)
library(tidyr)

##### Red in csv #####
surveys <- readr::read_csv("data_raw/portal_data_joined.csv")
str(surveys)

# Restrict rows with filter()
filter(surveys,taxa == "Rodent" )
filter(surveys, genus == "Neotoma")

# Restrict columns with select()
select(surveys, record_id, species_id, weight)

select(surveys, -record_id, -species_id, -weight)


# Linking together functions with piping
surveys %>%
  filter(year == 1995) %>%
  select(-record_id, -species_id, -day) %>%
  head(5)                # It'll only show me the first 5 records

# You can assign that outcome to an object
surveys_1995 <- surveys %>%
  filter (year == 1995) %>%
  select (-species_id, -record_id, -day) %>%
  head(5)

# Making a new calculated column with mutate()
surveys %>%
  select(-record_id, -month, -day, -plot_id, -taxa, -plot_type) %>%
  mutate(weight_kg = weight/1000,
         weight_lb = ud.convert(weight, "g", "lb")) 
# It supposes I looked at the data and I know that weight is in grams. I want it
# to be expressed in lb

surveys %>%
  filter(!is.na(weight)) %>%
  mutate(weight_kg = weight/1000,
         weight_lb = ud.convert(weight_kg, "g", "lb"))

#new_df <- surveys %>%
#  filter(species_id) %>%
#  mutate(hindfoot = ud.convert(hindfoot_length, "mm", "cm"))

#new_df <- surveys %>%
#  select(species_id) %>%
#  mutate(hindfoot_cm = ud.convert(hindfoot_length, "mm", "cm"))

surveys %>%                                      # Rich's
  select(species_id, hindfoot_length) %>%
  mutate(hindfoot_cm = hindfoot_length/10) %>%
  select(-hindfoot_length) %>%
  filter(!is.na(hindfoot_cm)) %>%
  filter(hindfoot_cm <3)

surveys %>%                                      # Mine
  mutate(hindfoot_cm = ud.convert(hindfoot_length, "mm", "cm")) %>%
  filter (!is.na(hindfoot_cm), hindfoot_cm <3) %>%
  select (species_id, hindfoot_cm)


# Split-apply-combine with group_by() and summarize()
surveys %>%
  group_by(sex) %>%
  summarize(mean_weight = mean(weight, na.rm = TRUE),
            sd_weight = sd(weight, na.rm = TRUE))

surveys %>%
  filter (!is.na(weight)) %>%
  group_by (sex, species_id) %>%
  summarize (mean_weight = mean(weight),
             sd_weight = sd (weight),
             max_weight = max(weight)) %>%
  arrange(desc(max_weight))

surveys %>% 
  filter(!is.na(weight)) %>%
  group_by(sex, species_id) %>%
  summarize(mean_weight = mean(weight),
            sd_weight = sd(weight),
            max_weight = max (weight),
            n = n()) %>%
  arrange(desc(max_weight))

# A few options for counting 
surveys %>%
  count(sex, species_id)


##### Reshaping data with pivot_wider() and pivot_longer() #####
surveys_gw <- surveys %>%
  filter(!is.na(weight)) %>%
  group_by(plot_id, genus) %>%
  summarize(mean_weight = mean(weight))

View(surveys_gw)

surveys_wide <- surveys_gw %>%
  pivot_wider(names_from = genus,
              values_from = mean_weight)
View(surveys_wide)  

surveys_long <- surveys_wide %>%
  pivot_longer(-plot_id,
               names_to = "genus",
               values_to =  "mean_weight")
View(surveys_long)


##### Exporting filtered data #####
# Goal: data set to plot change in species abundance over time 
surveys_complete <- surveys %>%
  filter(!is.na(weight),
         !is.na(hindfoot_length),
         !is.na(sex))

# Most common species
species_count <- surveys_complete %>%
  count(species_id)

# Now I want the species that have at least 50 observations
species_count <- surveys_complete %>%
  filter(species_id >50) %>%
  count(species_id)

species_counts <- surveys_complete %>%
  count(species_id) %>%
  filter(n > 50)

# Only keep the most common species
surveys_complete <- surveys_complete %>%
  filter(species_id %in% species_counts$species_id)

# Create a new csv and save it in a repo folder
write_csv(surveys_complete, file = "data_clean/surveys_complete.csv")
