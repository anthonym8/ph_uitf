# clear working directory
rm(list=ls())

# Load libraries
library(dplyr)
library(readr)

# Pull data from web
uitf_file_url <- "http://www.uitf.com.ph/excel_matrix.php?sort=&sortby=bank&sortorder=asc&class_id=&currency="
uitf_dir_file <- "Datasets/uitf_matrix.xls"
if(!file.exists(uitf_dir_file)) {
    download.file(url = uitf_file_url, 
                  destfile = uitf_dir_file)
}

# Load data
uitf_matrix <- read_tsv(uitf_dir_file, trim_ws = FALSE)
error_lines <- uitf_matrix[[1]] %>% 
    as.numeric() %>% 
    is.na() %>% 
    which()

# load raw text data
uitf_linedata <- read_lines(uitf_dir_file, skip=1) %>% 
    data_frame(Line = .) %>%
    filter(Line != "")

# remove erroneous line breaks and save modifed file
uitf_linedata$Line[error_lines - 1] <- paste(uitf_linedata$Line[error_lines - 1], uitf_linedata$Line[error_lines])
uitf_linedata[-error_lines, ] %>% 
    as.matrix() %>% 
    write_lines("Datasets/modified_file.tsv")

# load modified tsv file
uitf_matrix <- read_tsv("./Datasets/modified_file.tsv", 
                        col_names=names(uitf_matrix) # use column names of previously read file
                        )

# clean up
rm(uitf_linedata, error_lines, uitf_dir_file, uitf_file_url)


