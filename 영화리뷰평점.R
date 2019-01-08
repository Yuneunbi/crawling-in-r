library(stringr)
# i=1
# 영화 '클래식' 네이버 리뷰
# url = paste0("http://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=35939&type=
#              after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject
#              =false&page=",i)
# line =readLines(url,encoding='UTF-8')
# title = str_detect(line,"<div class=\"score_reple\">")
# title = line[which(title)+1]
# title = gsub('\t|<.*?>|\\[wwd*?\\]|BEST','',title)
# title = str_trim(title)
# title
# final_data =NULL
# # rm("inx")
# 
# inx = str_detect(line,"<span class=\"st_off\">")
# score = line[inx]
# score = gsub("\t|<.*?>",'',score)
# score
# temp_data = cbind(score,title)
# final_data = rbind(final_data,temp_data)
# 
# rm(list=ls())


library(stringr)
final_data = NULL

for(i in 1:10){
  
  url = paste0("http://movie.naver.com/movie/bi/mi/pointWriteFormList.nhn?code=35939&type=
             after&isActualPointWriteExecute=false&isMileageSubscriptionAlready=false&isMileageSubscriptionReject
             =false&page=",i)
  url <- 'https://movie.naver.com/movie/bi/mi/review.nhn?code=35939&page=1'
  line = readLines(url,encoding = 'UTF-8') # utf-8 안하면 한글 이상하게 나오
  # line = readLines(url)
  
  title = str_detect(line,"<div class=\"score_reple\">")
  title = line[which(title)+1]
  title = gsub('\t|<.*?>|\\[wwd*?\\]|BEST','',title)
  title = str_trim(title)
  inx = str_detect(line,"<span class=\"st_off\">")
  score = line[inx]
  score = gsub("\t|<.*?>",'',score)
  
  temp_data = cbind(score,title)
  final_data = rbind(final_data,temp_data)
  final_data <- as.data.frame(final_data,stringsAsFactors = FALSE)
  final_data$score <- as.numeric(final_data$score)
}

final_data
# 영화 평점과 리뷰
mean(final_data$score)
# 평점 평균
