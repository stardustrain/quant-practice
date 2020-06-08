# 연습용 naver 주식 crawler
library('httr')
library('rvest')
library('stringr')
library('data.table')

if(!exists('GetQueryString', mode = 'function')) source('./utils/query_string.R')

TARGET_PAGE_URL = 'https://finance.naver.com/sise/sise_market_sum.nhn'

.GetTargetPageHtml <- function(url) {
  GET(url) %>% read_html(., encoding = 'EUC-kR')
}

.GetLastPage <- function(pageHtml) {
  pageHtml %>%
    html_node('.pgRR') %>%
    html_node('a') %>%
    html_attr('href') %>%
    strsplit(., split = '=') %>%
    unlist %>%
    tail(., 1) %>%
    as.numeric
}

.GetTickerNumbers <- function(pageHtml) {
  (pageHtml %>%
    html_nodes('table'))[2] %>%
    html_node('tbody') %>%
    html_nodes('tr') %>%
    html_nodes('a') %>%
    html_attr('href') %>%
    str_extract(., '\\d+') %>%
    unique
}

.GetTableData <- function(pageHtml) {
  table <- (pageHtml %>%
    html_table(fill = TRUE))[[2]]

  unnecessaryColumn <- match('토론실', colnames(table))

  table[, unnecessaryColumn] <- NULL
  table <- na.omit(table)

  return(table)
}

.MergeTickerIntoTable <- function(pageHtml) {
  table <- .GetTableData(pageHtml)
  tickers <- .GetTickerNumbers(pageHtml)
  
  table$N <- tickers
  colnames(table)[1] <- '종목코드'
  rownames(table) <- NULL

  return(table)
}

.GenerateTickerData <- function(code) {
  tables <- list()
  url <- paste0(TARGET_PAGE_URL, GetQueryString(list(sosok = code)))
  pageHtml <- .GetTargetPageHtml(url)

  lastPage <- .GetLastPage(pageHtml)
  
  for (i in 1:lastPage) {
    targetPageUrl <- paste0(TARGET_PAGE_URL, GetQueryString(list(
      sosok = code,
      page = i
    )))
    targetPageHtml <- .GetTargetPageHtml(targetPageUrl)
    tables[[i]] <- .MergeTickerIntoTable(targetPageHtml)
    Sys.sleep(0.5)
  }
  
  return(rbindlist(tables))
}

GetTicketTable <- function() {
  tryCatch({
      tickerTables <- list()
      for (i in 0:1) {
        tickerTables[[ i + 1 ]] <- .GenerateTickerData(i)
      }
      
      return(rbindlist(tickerTables))
    },
    error = function(e) print(e)
  )
}

tickerTable <- GetTicketTable()
