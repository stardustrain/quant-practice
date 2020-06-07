library(httr)
library(rvest)
library(readr)
library(stringr)

source('./constants.R')

.GetOTP <- function(otpRequestBody) {
  otp <- POST(GENERATE_OTP_URL, query = otpRequestBody) %>%
    read_html() %>%
    html_text()

  return(otp)
}

.GetData <- function(otp) {
  data <- POST(DOWNLOAD_URL, query = list(code = otp), add_headers(referer = GENERATE_OTP_URL)) %>%
    read_html() %>%
    html_text() %>%
    read_csv()
  
  return(data)
}

.CreateCSV <- function(data, filename) {
  ifelse(dir.exists('data'), FALSE, dir.create('data'))
  write.csv(data, paste0(FILE_PATH, filename, '.csv'))
}

.ReadCSV <- function(filepath) {
  read.csv(filepath, row.names = 1, stringsAsFactors = FALSE)
}

.CompareColumns <- function() {
  sector <- .ReadCSV(paste0(FILE_PATH, 'krx_sector.csv'))
  ind <- .ReadCSV(paste0(FILE_PATH, 'krx_ind.csv'))

  ticker <- merge(sector, ind,
                  by = intersect(names(sector), names(ind)),
                  all = FALSE)
  orderedTicker <- ticker[order(-ticker['시가총액.원.']), ]
  ticker[grepl('스팩', ticker[, '종목명']), '종목명']
}

RequestMarketData <- function(otpRequestBody, filename) {
  tryCatch({
    data <- purrr::compose(
      .GetOTP,
      .GetData
      , .dir='forward')(otpRequestBody)
    .CreateCSV(data, filename)
    },
    error = function(e) print(e),
    finally = print('done')
  )
}
