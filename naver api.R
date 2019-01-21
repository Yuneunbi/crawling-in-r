# 네이버 API로 단어 검색시 나오는 블로그 제목과 날짜 가져오기 

require(httr)
require(stringr)
library(jsonlite)

url <- 'https://openapi.naver.com/v1/search/blog.json'
query <- '강호동'
query <-  URLencode(enc2utf8(query))
# 검색어를 URL 인코딩으로 변환
id = id # api 아이디
secret = secret # api 비밀번호


display <- '30' # 검색 결과의 개수
start <- '1' # 문서의 시작점
query <- URLencode(enc2utf8(query))
result <- GET(paste0(url,"?query=",query,'&display=',display,'&start=',as.character(start)), add_headers("X-Naver-Client-Id"=id,"X-Naver-Client-Secret" = secret))
# GET : 해당 URL에서 주기로 한 정보 제공 
contents<- content(result, as = "parsed")

# content 가져오기
Title <- NULL
Date <- NULL
for(i in 1:length(contents$items)){
  item <- contents$items[[i]]
  title <- item$title
  title <- gsub('<b>|</b>|&quot;|&q','',title)
  Title <- rbind(Title,title)
  date <- item$postdate
  Date <- rbind(Date,date)
}
Title <- gsub('<b>|</b>|&quot;|&q','',Title)
Date <- substr(Date,5,11)

newsdata <- data.frame(Title=Title,Date=Date,stringsAsFactors=FALSE)
################

# 블로그에서 검색어의 결과 가지고 오는 함수 만들기

get_news <- function(id=id,secret=secret,query = query,display=display,start=start){
  
  url <- 'https://openapi.naver.com/v1/search/blog.json'
  query <-  URLencode(enc2utf8(query))
  result <- GET(paste0(url,"?query=",query,'&display=',display,'&start=',as.character(start)), add_headers("X-Naver-Client-Id"=id,"X-Naver-Client-Secret" = secret))
  contents<- content(result, as = "parsed")
  
  Title <- NULL
  Date <- NULL
  # Description 
  for(i in 1:length(contents$items)){
    item <- contents$items[[i]]
    title <- item$title
    title <- gsub('<b>|</b>|&quot;|&q','',title)
    Title <- rbind(Title,title)
    date <- item$postdate
    Date <- rbind(Date,date)
  }
  Title <- gsub('<b>|</b>|&quot;|&q','',Title)
  Date <- substr(Date,5,11)
  
  newsdata <- data.frame(Title=Title,Date=Date,stringsAsFactors=FALSE)
  return(newsdata)
  
}
# start = 1 

# 검색할 단어 
# query <- '손예진'

Data <- NULL
data <- get_news(id=id,secret = secret,query=query,display='100',start=1)
Data <- rbind(Data,data)

for(j in 1:9){
  data <- get_news(id=id,secret=secret,query=query,display = '100',start =(100*j+1))
  Data <- rbind(Data,data)
}
# 페이지 바꿔가며 데이터 수집

Data <- as.data.frame(Data,stringsAsFactors=FALSE)
Data$Title <- gsub('\\[.*?\\]|\\(.*?\\)|\\&.*?\\;','',Data$Title)
# 지저분한 단어들 제거 
Data$Title <- str_replace_all(Data$Title,'\\W',' ')
# 특수문자 제거

Data
