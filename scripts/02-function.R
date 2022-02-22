### Form of a function ####

function_name <- function(inputs) {
  output_value <- do_something(inputs)
  return(output_value)
}

### Write our own functions ###
calc_shrub_vol <- function(lenght, width, height) {
  area <- lenght * width
  volume <- area * height
  return(volume)
}

shrub_vol <- calc_shrub_vol(2,3.5, 4)

calc_shrub_vol <- function(lenght, width, height=1) {
  area <- lenght * width
  volume <- area * height
  return(volume)
}

calc_shrub_vol(3,10)
calc_shrub_vol(3,10, height =2)

### Exercise ###
get_mass_from_length_theropoda <- function(length){
  mass <- 0.73 * length ^ 3.63
  return(mass)
}

mass_spino <- get_mass_from_length_theropoda(16)

get_mass_from_length <- function(a,length, b){
  mass <- a * length ^ b
  return(mass)
}

mass_saur <- get_mass_from_length(a=214.44, length=26, b= 1.46)


