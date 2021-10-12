#블로그 타이틀 크롤링
blog <- c()
for (i in 1: 300) {
  GET(url = "https://section.blog.naver.com/ajax/SearchList.nhn",
      query = list("countPerPage" = "7",
                   "currentPage" = i,
                   "endDdfadfadfate" = "2020-12.31",
                   "keyword" = "예산집행내역",
                   "orderBy" = "sim",
                   "startDate" = "2020-01-01",
                   "type" = "post"),
      add_headers("referer" = "https://section.blog.naver.com/Search/Post.nh")) %>% httr::content(as = "text") %>% str_remove(pattern = '\\)\\]\\}\',') %>% fromJSON() -> naverBlog
  
  data <- naverBlog$result$searchList
  blog <- bind_rows(blog, data) 
  
  cat(i, "번째 페이지 크롤링 완료\n")
  Sys.sleep(time = 3)
}
