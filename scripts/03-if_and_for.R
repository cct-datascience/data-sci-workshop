### Format of if ###
if (conditional statement that would be) {
  do something 
}

### Example of if ###
x <- 4
if (x > 5) {
  x <- x ^ 5
}


### Another example ###
veg_type <- "forb"
volume <- 16

if (veg_type == "tree") {
  mass <- 2 * volume ^ 0.9
} else if (veg_type == "grass") {
   mass <- 0.5 *volume ^ 0.9
} else {
  mass <-NA
}


### Function and if together ####
get_mass <- function(veg_type) {
if (veg_type == "tree") {
  mass <- 2 * volume ^ 0.9
} else if (veg_type == "grass") {
  mass <- 0.5 *volume ^ 0.9
} else {
  mass <-NA
}
  return(mass)
}

### Exercise ####
age_class = "seedling"
if (age_class == "sapling") {
  y <- 10
} else if (age_class == "seedling") {
  y <- 5
}

y

### Example of ifelse ###
length <- 5
ifelse(length ==5, "correct", "incorrect")

