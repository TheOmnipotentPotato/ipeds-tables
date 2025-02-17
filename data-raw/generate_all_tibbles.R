library(usethis)
library(glue)
library(roxygen2)
library(tidyverse)
library(ipeds)
options("ipeds.download.dir" = "/Users/julianickodemus/Coding/R/ipedsData")
setwd("/Users/julianickodemus/Coding/R/ipedsData/ipedsTablesRPKG/ipedstables/data/")


available_ipeds <- ipeds::available_ipeds()




get_valid_years <- function() {
    valid_years <- tibble(available_ipeds) |>
        filter(downloaded == TRUE) |>
        summarise(year)
    valid_years
}

get_missing_years <- function() {
    missing_years <- tibble(available_ipeds) |>
        filter(downloaded == FALSE & (provisional == TRUE | final == TRUE)) |>
        summarise(year)
    missing_years
}



download_missing_years <- function(missing_years) {
    missing_years |> map(\(missing_year) ipeds::download_ipeds(missing_year, force = TRUE))
}

generate_tibble <- function(table_name, table_year) {
    ipeds_table <- tibble(ipeds::ipeds_survey(table_name, year = table_year))
    assign(glue("{table_name}"), ipeds_table)
    save(list = table_name, file = glue("{table_name}.Rda"))
}



pull_data_year <- function(data_year) {
    print(data_year)
    table_names <- names(ipeds::load_ipeds(data_year))
    table_names |> map(\(table_name) generate_tibble(table_name, data_year))
}

pull_all_data <- function(year_list) {
    year_list |> map(\(year) pull_data_year(year))
}


valid_years <- get_valid_years()
typeof(valid_years)
valid_years

pull_all_data(list(2007, 2008, 2009, 2010, 2011, 2012, 2013, 2014, 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023))
