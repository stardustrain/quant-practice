library(httr)
library(rvest)
library(readr)
library(stringr)

source('./utils/constants.R')

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

.CompareColumns <- function(sector, ind) {
  ticker <- merge(sector, ind,
                  by = intersect(names(sector), names(ind)),
                  all = FALSE)

  ticker <- ticker[order(-ticker['시가총액.원.']), ]
  ticker <- ticker[!grepl('스팩', ticker[, '종목명']), ]
  ticker <- ticker[str_sub(ticker[, '종목코드'], -1, -1) == 0, ]

  return(ticker)
}

RequestMarketData <- function(otpRequestBody, filename) {
  tryCatch({
    data <- purrr::compose(
      .GetOTP,
      .GetData,
    .dir='forward')(otpRequestBody)
    .CreateCSV(data, filename)
    },
    error = function(e) print(e),
    finally = print('done')
  )
}

CreateTickerTable <- function() {
  tryCatch({
    sector <- .ReadCSV(paste0(FILE_PATH, 'krx_sector.csv'))
    ind <- .ReadCSV(paste0(FILE_PATH, 'krx_ind.csv'))
    
    ticker <- .CompareColumns(sector, ind)
    rownames(ticker) = NULL

    .CreateCSV(ticker, 'ticker')
  }, error = function(e) print(e))
}
