## Pack

packages <- c("tidyverse", "readxl")

lapply(packages, require, character.only = TRUE)

bd_election_08_panch1 <- read_excel("vote/BD_Election.xlsx", sheet = "Panch1")

View(bd_election_08_panch1)

# Function to extract the first number

first_digit <- function(x) {
  as.numeric(substr(gsub("^(0+|\\D)*", "", as.character(x)), 1, 1))
}

first_digit(345)

fd_panc1_al <- first_digit(bd_election_08_panch1$Mojaharul_boat)

table(fd_panc1_al)

barplot(table(fd_panc1_al))

# At once

table()

table(first_digit(bd_election_08_panch1$Jamir_Uddin_paddy))
barplot(table(first_digit(bd_election_08_panch1$Jamir_Uddin_paddy)))

## Merge all candidate

panch1_all_symbols <- bd_election_08_panch1 %>% 
  select(center, paddy, boat, handfan, kula, kaste) %>%
  pivot_longer(
    cols = -center,
    names_to = "symbol",
    values_to = "count"
  ) %>%
  mutate(constituency = "Panch1")
View(panch1_all_symbols)


table(first_digit(panch1_all_symbols$count))
round(prop.table(table(first_digit(panch1_all_symbols$count))) * 100, 2)
barplot(table(first_digit(panch1_all_symbols$count)))

