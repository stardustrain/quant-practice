library(httr)
library(rvest)
library(stringr)

.GetBizDay <- function() {
  url <- 'https://finance.naver.com'
  data <- GET(url)

  purrr::compose(
    function (x) read_html(x, encoding = 'EUC-KR'),
    function (x) html_node(x, '#time'),
    html_text,
    function (x) str_match(x, ('[0-9]+.[0-9]+.[0-9]+')),
    function (x) str_replace_all(x, '\\.', ''),
    .dir='forward'
  )(data)
}

TODAY = .GetBizDay()
GENERATE_OTP_URL = 'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'
DOWNLOAD_URL = 'http://file.krx.co.kr/download.jspx'
FILE_PATH = 'data/'
