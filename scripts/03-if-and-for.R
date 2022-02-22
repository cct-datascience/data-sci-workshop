### everything about control flow

## if statements
# format
if (conditional statement that would be true) {
  do something
}

# example of if
x <- 4
if (x > 5) {
  x <-  x ^ 5
}

# another example
veg_type <- "forb"
volume <- 16
if (veg_type == "tree") {
  mass <- 2 * volume ^ 0.9
} else if (veg_type == "grass") {
  mass <- 0.5 * volume ^ 0.9
} else {
  mass <- NA
}


# exercise: complete the following
age_class = "seedling"
if (age_class == "sapling") {
  y <- 10
} else if (age_class == "seedling") {
  y <- 5
}
y



#_______________________________________________________________
## for loops

#structure
for (item in list_of_items) {
  do something(item)
}

#examples
volumes <- c(1.5, 3, 8)
for (volume in volumes) {
  print(2.6 * volume ^ 0.9)
}

for (volume in volumes) {
  mass <- (2.6 * volume ^ 0.9)
  mass_lb <- mass * 2.2
  print(mass_lb)
}

#tell the loop to go through all items in the vector 'volume'
for (i in 1:length(volumes)) {
  mass <- 2.6 * volumes[i] ^ 0.9
  print(mass)
}

#save output into new object 'masses'
masses <- c(length=length(volumes)) # empty vector of correct length
masses <- c() # empty vector, will work just fine usually
for (i in 1:length(volumes)) {
  mass <- 2.6 * volumes[i] ^ 0.9
  masses[i] <- mass 
}

#each time you get a mass value, add it in to the vector (does the same thing as the one above but uses sequential value instead of item position in the vector)
masses_2 <- c()
for (volume in volumes) {
  mass <- 2.6 * volume ^ 0.9
  masses_2 <- c(masses_2, mass)
}



# fill-in-the-blank activity 
radius <- c(1.3, 2.1, 3.5)
areas <- vector(mode = "numeric", length = length(radius))
for (i in 1:length(radius)){
  areas[i] <- pi * radius[i] ^ 2
}
areas


# one more example, using files (got too many errors with the file reading, just watching along)
download.file("http://www.datacarpentry.org/semester-biology/data/locations.zip", 
              "data-sci-workshop/data_raw/locations.zip")
unzip("data-sci-workshop/data_raw/locations.zip", exdir = "data-sci-workshop/data_raw")

list.files(path = "data_raw", pattern = "data_raw/locations-*", full.names = TRUE)

for (data_file in data_files) {
  data <- read.csv.(data_file)
  count <- nrow(data)
  print(count)
}


















