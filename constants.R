library(httr)
library(rvest)
library(stringr)

.GetBizDay <- function() {
  url <- 'https://finance.naver.com/sise/sise_deposit.nhn'
  data <- GET(url)

  purrr::compose(
    function (x) read_html(x, encoding = 'EUC-KR'),
    function (x) html_nodes(x, xpath = '//*[@id="type_1"]/div/ul[2]/li/span'),
    html_text,
    function (x) str_match(x, ('[0-9]+.[0-9]+.[0-9]+')),
    function (x) str_replace_all(x, '\\.', '')
    , .dir='forward'
  )(data)
}

# TODAY = format(Sys.Date(), format='%Y%m%d')
TODAY = .GetBizDay()
GENERATE_OTP_URL = 'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'
DOWNLOAD_URL = 'http://file.krx.co.kr/download.jspx'
FILE_PATH = 'data/'
