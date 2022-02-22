# Write first function
# Calcuating volume of a shrub
shrub_vol <- function(l, w, h) {
  area <- l * w
  vol <- area * h
  return(volume)
}

shrub_vol <- function(l, w, h = 1) {
  area <- l * w
  vol <- area * h
  return(volume)
} # h = 1 is a default argument value; can be overridden



get_mass_from_length <- function(a, length, b) {
  mass <- a * length ^ b
  return(mass)
}

get_mass_from_length(0.73, 16, 3.63)

get_mass_from_length(214.44, 26, 1.46)
