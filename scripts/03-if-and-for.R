# If statements
x <- 6
if(x > 5) {
  x <- x ^ 5
}

veg_type <- "tree"
volume <- 16
if(veg_type == "tree") {
  mass <- 2 * volume ^ 0.9
} else if(veg_type == "grass") {
  mass <- 0.5 * volume ^ 0.9
} else {
  mass <- NA
}


age_class <- "seedling"
if(age_class == "sapling") {
  y <- 10
} else if(age_class == "seedling") {
  y <- 5
}


# For loops
volumes <- c(1.5, 3, 8)
for(volume in volumes) {
  print(2.6 * volume ^ 0.9)
}

for(i in 1:length(volumes)) {
  mass <- 2.6 * volumes[i] ^ 0.9
  print(mass)
}

for(i in 1:length(volumes)) {
  mass <- 2.6 * volumes[i] ^ 0.9
  masses <- mass
  print(masses)
}

masses <- c()
masses <- c(length = length(volumes))
for(i in 1:length(volumes)) {
  mass <- 2.6 * volumes[i] ^ 0.9
  masses <- mass
  print(masses)
}


masses2 <- c()
for(volume in volumes) {
  mass <- 2.6 * volume ^ 0.9
  masses2 <- c(masses2, mass)
}

radius <- c(1.3, 2.1, 3.5)
areas <- c(length = length(radius))
for(i in 1:length(radius)) {
  areas[i] <- pi * radius[i] ^ 2
}
areas


# Download data
download.file("http://www.datacarpentry.org/semester-biology/data/locations.zip
", "data_raw/locations.zip", mode = "wb")
unzip("data_raw/locations.zip", exdir = "data_raw")

data_files <- list.files(path = "data_raw",
                         pattern = "locations-*",
                         full.names = TRUE)
for(data_file in data_files) {
  data <- read.csv(data_file)
  count <- nrow(data)
  print(count)
}
