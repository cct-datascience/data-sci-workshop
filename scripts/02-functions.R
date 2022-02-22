### writing functions

# components or form of a function
function_name <- function(inputs) {
  output_value <- do_something(inputs)
  return(output_value)
}

# write our own function, we will calculate the volume of a shrub
calc_shrub_vol <- function(length, width, height) {
  area <- length * width
  volume <- area * height
  return(volume)
}

  # practice using function
  calc_shrub_vol(2, 3.5, 4)


# you can set defaults for functions (such as height =1, so you only have to type in L and W and specify H when necessary)
calc_shrub_vol2 <- function(length, width, height = 1) {
  area <- length * width
  volume <- area * height
  return(volume)
}


# practice problem
mass = a * length^b

get_mass_from_length_theropoda <- function(length){
  mass <- 0.73 * length ^ 3.63
  return(mass)
}

  # use function to calc mass of dino that is 16m long
  get_mass_from_length_theropoda(16) #17150.56
  # create new function
  get_mass_from_length <- function(a, length, b) {
    mass <- a * length ^ b
    return(mass)
  }
      # use new function to calc (a=214.44, b=1.46, length = 26)
      get_mass_from_length(214.44, 26, 1.46) #24955.54






