#분야별 사용자 정의 팔레트 생성
all_palette <- c("Light Steel Blue","Gray 90","Dark Sea Green","Light Goldenrod","Sandy Brown")
edu_palette <- c("Light Sky Blue3","Slate Gray 1","Slate Gray3","Slate Gray 2")
army_palette <- c("Dark Sea Green3","Dark Sea Green4","Dark Sea Green1","Dark Sea Green2")
industry_palette <-c("Burlywood 1","Burlywood 2","Light Salmon 1","Light Salmon 2","Orange 1","Chocolate 1","Chocolate 2","Orange 2","Wheat 1","Wheat 2")
traffic_palette <-c("Gray 60","Gray 70","Gray 50","Gray 80","Gray 90")
traffic_palette2 <-c("Gray 60","Gray 80","Gray 70","Gray 50","Gray 90","Gray 100")
health_palette <-c("Light Goldenrod 3","Light Goldenrod 2","Light Goldenrod 1")

#산점도 사용자 정의 팔레트 생성
getPalette = colorRampPalette(brewer.pal(9, "Set2"))
colourCount = length(unique(head(education_detail,10)$단위사업명))

#분야별 연도에 따른 확정금액 추이 라인그래프 시각화
ggplot(year_value, aes(x=회계연도, y = sum_value, group = 분야명, color = 분야명)) + 
  geom_line(size = 1.3) + 
    labs(x="회계연도",
         y="확정금액", 
       title="분야별 연도에 따른 확정금액 추이")+ 
theme_bw()+
geom_point(size=2) +
scale_color_manual(values=all_palette)+
theme(plot.title = element_text(size=22),
      legend.title = element_text(size=13, 
                                      face="bold"),
      legend.text = element_text(size = 13, face = "bold"),
      ,axis.text.x= element_text(size=10,angle = 30, face = "bold"),
       axis.text.y= element_text(size=10, face = "bold"),
        axis.title=element_text(size=18)) 
        
#분야별 바차트 사용자 정의 함수
bar_chart_fun<- function(name, title,palette){
    select<- data_select2 %>% filter(분야명==name)

    colourCount = length(unique(select$회계연도))
    getPalette = colorRampPalette(brewer.pal(8, "Set2"))

    ggplot(select,aes(x=회계연도,y=국회확정금액,group=부문명))+
      geom_col(aes(fill=부문명),position="stack")+
      labs(title = title,
           x = '연도', y = '국회확정금액') +
      theme(axis.title=element_text(size=15),title=element_text(size=20)) +
      scale_fill_manual(values = palette)
}

#분야별 전체 확정 금액 파이차트 시각화
ggplot(select_all, aes(x = "", y = perc, fill = 분야명)) +
        geom_col() +  
        geom_label(aes(label = labels),
            position = position_stack(vjust = 0.5),
            show.legend = FALSE) +
    guides(fill = guide_legend(title = "분야명")) + 
    labs(x="", y = "", title = "분야별 확정금액 비율") +
    scale_fill_viridis_d() +
    coord_polar(theta = "y") + 
    scale_fill_manual(values = all_palette) +
    theme_void()+
    theme(legend.title = element_text(size=15, 
                                      face="bold"),
       legend.text =  element_text(size=12, 
                                      face="bold"),
       title = element_text(size=15, 
                                      face="bold"))
                                   
#분야별 파이 차트 사용자 정의 함수
pie_chart_fun<- function(name, title, palette = "OrRd") {
    
    df<- data_select1 %>% filter(분야명 == name) %>%
      group_by(부문명) %>% 
      summarise(sum_value = sum(국회확정금액))  %>%
      mutate(perc = sum_value/sum(sum_value)) %>%
      arrange(perc) %>%
      mutate(labels = scales:: percent(perc)) 

    ggplot(df, aes(x = "", y = perc, fill = 부문명)) +
        geom_col(color = "white", lwd = 0.5) +
        geom_label(aes(label = labels),
            position = position_stack(vjust = 0.5),
            show.legend = FALSE) +
    guides(fill = guide_legend(title = "부문명")) + 
    labs(x="", y = "", title = title) +
    scale_fill_viridis_d() +
    coord_polar(theta = "y") + 
    scale_fill_manual(values = palette) +
    theme_void()+
    theme(legend.title = element_text(size=15, 
                                      face="bold"),
       legend.text =  element_text(size=12, 
                                      face="bold"),
       title = element_text(size=15, 
                                      face="bold"))
}

#분야별 롤리팝차트 사용자 정의 함수
point_chart_fun<- function(df, title, x_angle = 25, x_size = 10){
    
 ggplot(df, aes(x=reorder(단위사업명,-sum_value), y=sum_value,color=단위사업명,label=sum_value)) + 
  geom_point(size=5) + 
  geom_segment(aes(x=단위사업명, 
                   xend=단위사업명, 
                   y=0, 
                   yend=sum_value)) + 
  labs(x=" ",
       y=" ", 
       title=title)+ 
  theme_bw()+
  theme(plot.title = element_text(size=15, face = "bold"),
        legend.title = element_text(size=15, 
                                      face="bold"),
        axis.text.x = element_text(size = x_size, angle = x_angle, hjust = 1, face = "bold"),
        axis.text.y= element_text(size=10, face = "bold"), 
        axis.title=element_text(size=15,face = "bold"))+
  geom_text_repel()+
  scale_colour_manual(values=getPalette(colourCount))
}
