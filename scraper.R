if(!exists('GetMarketData', mode = 'function')) source('./marketdata.R')
if(!exists('GetIndividualData', mode = 'function')) source('./individualIndicator.R')

GetMarketData()
GetIndividualData()

url = 'https://finance.naver.com/news/news_list.nhn?mode=LSS2D&section_id=101&section_id2=258'
data = GET(url)

decode_fn = purrr::compose(
  function(x) read_html(x, encoding="EUC-KR"),
  function(x) html_nodes(x, 'dl'),
  function(x) html_nodes(x, '.articleSubject'),
  function(x) html_nodes(x, 'a'),
  function(x) { map(x, function(a) { list(html_attr(a, 'title'), html_attr(a, 'href')) }) },
.dir="forward")

title_with_links = decode_fn(data)

print(title_with_links)
