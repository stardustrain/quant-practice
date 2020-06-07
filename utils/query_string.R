GetQueryList <- function(queryString) {
  queryList <- queryString %>%
    strsplit(., split = '&') %>%
    unlist %>%
    purrr::map(., function(x) {
      splitedQueryString <- unlist(strsplit(x, split = '='))
      res <- list()
      res[[ splitedQueryString[1] ]] = splitedQueryString[2]
      return(res)
    }) %>%
    flatten
  
  return(queryList)
}

GetQueryString <- function(queryList) {
  queryString <- names(queryList) %>%
    purrr::map(., function(x) {
      return(c(paste0(x, '=', queryList[[ x ]])))
    }) %>%
    purrr::reduce(., function(acc, val) {
      return(if (acc == '') val else (paste0(acc, '&', val)))
    }, .init = '')

  return(paste0('?', queryString))
}
