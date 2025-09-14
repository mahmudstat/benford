# The goal is to see when empirically normal data tend to follow benford 

# Generate a normal data

ndt1 <- rnorm(100, 50, 5)

first_digit <- function(x) {
  as.numeric(substr(gsub("^(0+|\\D)*", "", as.character(x)), 1, 1))
}

table(first_digit(ndt1)) 


# Function to check first digit benford
check_ben_fd <- function(x) table(first_digit(x)) 

ndt2 <- rnorm(100, 50, 10)

check_ben_fd(rnorm(100, 50, 10))

check_ben_fd(rnorm(100, 50, 20))

check_ben_fd(rnorm(100, 50, 30))

check_ben_fd(rnorm(200, 50, 10))

check_ben_fd(rnorm(1000, 500, 500))

ndt2 <- rnorm(1000, 500, 500)
plot(as.data.frame(prop.table(table(first_digit(rnorm(1000, 500, 5000))))))


plot(as.data.frame(prop.table(table(first_digit(rnorm(1000, 500, 2000))))))

# rnorm(1000, 500, 2000) gives better than rnorm(1000, 500, 5000) 


plot(as.data.frame(prop.table(table(first_digit(rnorm(1000, 1000, 5000))))))

