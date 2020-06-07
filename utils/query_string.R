GetQueryList <- function(queryString) {
  queryList <- queryString %>%
    strsplit(., split = '&') %>%
    unlist %>%
    purrr::map(., function(x) {
      res <- unlist(strsplit(x, split = '='))
      a <- list()
      a[[ res[1] ]] = res[2]
      return(a)
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
