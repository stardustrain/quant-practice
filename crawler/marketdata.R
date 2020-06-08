source('./utils/constants.R')
if (!exists('RequestMarketData', mode='function')) source('./utils/crawler_helper.R')

GetMarketData <- function() {
  otpRequestBody <- list(
    name = 'fileDown',
    filetype= 'csv',
    url = 'MKD/03/0303/03030103/mkd03030103',
    tp_cd = 'ALL',
    lang = 'ko',
    pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp',
    date = TODAY
  )
  
  RequestMarketData(otpRequestBody, 'krx_sector')
}
