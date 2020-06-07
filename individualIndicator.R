source('./constants.R')
if (!exists('RequestMarketData', mode='function')) source('./utils/csv_creator.R')

GetIndividualData <- function() {
  otpRequestBody <- list(
    name = 'fileDown',
    filetype= 'csv',
    url = 'MKD/13/1302/13020401/mkd13020401',
    market_gubun = 'ALL',
    gubun = '1',
    pagePath = '/contents/MKD/13/1302/13020401/MKD13020401.jsp',
    schdate = TODAY
  )
  
  RequestMarketData(otpRequestBody, 'krx_ind')
}