# 데이터 불러오기
data<- read_xlsx("/content/drive/MyDrive/data/예산편성현황.xlsx")

# 사용할 컬럼 추출
data<- data[c(1,5,6,8,15)]
colnames(data)<- c('회계연도','분야명','부문명','단위사업명','국회확정금액')
data$국회확정금액<- as.numeric(data$국회확정금액)
head(data,3)

data_select1<- data %>% filter(분야명 == "교육" | 분야명 == "교통및물류" | 분야명 == "국방" |
                     분야명 ==  "보건" | 분야명 == "산업·중소기업및에너지") %>%
        filter(회계연도 == "2020" | 회계연도 == "2021")
        
#select_all : 분야별 전체 확정금액 합계 추출 
select_all<- data_select1 %>% 
    group_by(분야명) %>% 
    summarise(sum_value = sum(국회확정금액))  %>%
    mutate(perc = sum_value/sum(sum_value)) %>%
    arrange(perc) %>%
    mutate(labels = scales:: percent(perc)) 
    
data_select2<- data %>% filter(분야명 == "교육" | 분야명 == "교통및물류" | 분야명 == "국방" |
                     분야명 ==  "보건" | 분야명 == "산업·중소기업및에너지") %>%
        filter(회계연도 != "2007" & 회계연도 != "2008"  & 회계연도 != "2009"  & 회계연도 != "2010")

year_value = data_select2 %>% 
    group_by(회계연도, 분야명)%>% 
    summarise(sum_value = sum(국회확정금액)) %>%
    arrange(desc(분야명))
    
