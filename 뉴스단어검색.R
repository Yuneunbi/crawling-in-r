rm(list=ls())

library(rvest)
# install.packages('httr')
library(httr)

# 서울신문 기ㅈ
# url <- 'http://search.seoul.co.kr/index.php?scope=title&sort=&cpCode=seoul;nownews&period=&sDate=&eDate=&keyword=%EC%84%9C%EC%9A%B8%EC%8B%9C&iCategory=&pCategory=undefined&pageNum=2'
# word = "겨울"
temp_data = NULL
final_data = NULL

find.w <- function(word){
  
  

  for(i in 1:10){
   
    
    query = toupper(paste0('%',paste0(unlist(iconv(word, to = 'EUC-KR',toRaw = T)),collapse='%')))
    url <- paste0('http://search.seoul.co.kr/index.php?scope=title&sort=&cpCode=seoul;nownews&period=&sDate=&eDate=&keyword=',query,'&iCategory=&pCategory=undefined&pageNum=',i)
    
    body = read_html(url) %>% html_nodes('div.contentS div#list_area dl.article')
    title =  body %>% html_nodes('a') %>% html_text()
    title <-  title[nchar(title) != 0]
    time = body %>% html_nodes('span#date') %>% html_text()
    temp_data = cbind(title,time)
    final_data = rbind(final_data,temp_data)
  }
  final_data <- as.data.frame(final_data, stringsAsFactors=F)
  final_data$time <- gsub('\\||\\s|서울(\\w*)','',final_data$time)
  # \\| : |
  # \\s : 빈 문자열 
  # 서울\\w* : 서울이라는 단어뒤에 오는 문자
 
  return(final_data)
}

seoul=find.w("서울시")
winter <- find.w("겨울")
mc <- find.w("유재석")

