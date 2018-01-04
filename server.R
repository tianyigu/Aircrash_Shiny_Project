source("helper.R")
source("circle.R")

library(plotly)
library(wordcloud)
library(wordcloud2)

#options(shiny.sanitize.errors = FALSE)
shinyServer(function(input, output) ({
  style =theme(plot.background = element_rect(fill = '#282B30', colour = '#282B30'),panel.background = element_rect(fill = "#282B30", colour = '#686868'),panel.grid.major = element_line(colour = '#686868'),panel.grid.minor = element_line(colour = '#686868'),axis.title = element_text(color = '#989898', size = 15), axis.text = element_text(color = '#989898', size = 10),plot.title = element_text(color = '#989898', size = 18,hjust = 0.5), legend.background = element_rect(fill = '#282B30', colour = '#282B30'),legend.text = element_text(color = '#989898', size = 10),legend.title = element_text(color = "#989898",size = 12) )
  
  ###########page2############
  output$year <- renderPlot({ggplot(date, aes(x=Date)) + 
      geom_histogram(binwidth = 0.25, color="#D58E24", fill="#D58E24")+ggtitle("Aircrash Count in Each Year")+style+ labs(x = "Years")+ labs(y = "Aircrash Count")
  }, height = 350) 
  output$groyear  <- renderPlot({ggplot(grodate2, aes(x=gr, y = Fatal)) + 
      geom_histogram(binwidth = 0.25, color="#8A958F", fill=rgb(0.2,0.7,0.1,0.4),stat = "identity" )+ 
      geom_line(aes(y = Ratio*20000),color="#D58E24",size = 1)+ scale_y_continuous(sec.axis = sec_axis(~./20000, name = "Death Ratio"))+ggtitle("Fatality Count and Death Raito Each Ten Years")+style+labs(x = "Years") }, height = 350)
  
  output$grotime<- renderPlot({ggplot(grotime, aes(x=Time, y = count)) + 
      geom_bar(stat = "identity" ,  color="#8A958F", fill=rgb(51/255,153/255,1,0.5),size = 0)+ 
      geom_line(aes(y = Ratio*200),color="#B9B13D",size = 0.6)+ scale_y_continuous(sec.axis = sec_axis(~./200, name = "Death Ratio"))+ggtitle("Aircrash Count and Death Raito by Time of Day")+style+labs(x = "Time of Day", y = "Aircrash Count")
  }, height = 350)
  #############page3##############
  output$grosize = renderPlot({ggplot(grosize, aes(x=reorder(gr,X) , y=Ratio)) + 
      geom_area(aes(group = 1),fill="#CF9CF2", alpha=.2,color = "#CF9CF2")+theme(axis.text.x = element_text(angle=45))+style+ggtitle("Aircraft Size VS Death Ratio")+labs(x = "Number of People Aboard (flight size)", y = "Death_ratio")},height = 250)

  #####reactive#####
  graph1df <- reactive({
    made1 %>%
      filter(Date >= input$yearselect[1] &
               Date <= input$yearselect[2] &
               !Type == "") %>% 
      group_by(Type) %>% 
      summarise(count1 = n(),Fatal = sum(Fatalities), Ratio = sum(Fatalities)/sum(Aboard)) %>% arrange(desc(count1)) %>%head(n=20)
    
  })
  graph2df = reactive({
    if (input$checkbox == "All"){
      made1 %>% filter(Date >= input$yearselect[1] & Date <= input$yearselect[2] )
    }else{
    made1 %>% filter(made %in% input$checkbox & Date >= input$yearselect[1] & Date <= input$yearselect[2] )}
      
  })
  graph3df <- reactive({
    made %>%
      filter(Date >= input$yearselect1[1] &
               Date <= input$yearselect1[2] &
               !Operator == "" &
               !grepl("Military", Operator)) %>% 
      group_by(Operator) %>% 
      summarise(count1 = n(),Fatal = sum(Fatalities), Ratio = sum(Fatalities)/sum(Aboard)) %>% arrange(desc(count1)) %>%head(n=20)
    
  })

  ####graph#####
  output$graph1 <- renderPlot({ggplot(graph1df(),aes(x = reorder(Type, -count1) , y=count1,fill = factor(Type))) + 
      geom_bar(stat = "identity" ,size = 0,alpha = 0.7)+ 
      style+theme(axis.text.x = element_text(angle=30,size = 7))+labs(x = "Airplane Model", y = "Aircash Count",title="Aircrash Count by Airplane Model")})
  output$graph2 <- renderPlot({ggplot(graph2df(), aes(Date, colour=made, fill=made))+ geom_area(stat = "bin",alpha=0.55)+style+labs(x = "Years", y = "Aircrash Count",title = "Area Map of Aircrash Count by Major Aircraft Manufacturer")
    
  })
  #######page4#######
  output$operate = renderPlotly({p})
  output$graph3 = renderPlot({ggplot(graph3df(),aes(x = reorder(Operator, -count1) , y=count1,fill = factor(Operator))) + 
      geom_bar(stat = "identity" ,  size = 0,alpha = 0.7)+ 
      style+theme(axis.text.x = element_text(angle=30,size = 7))+labs(x = "Airlines", y = "Aircrash Count",title = "Aircrash Count by Airlines")})
  
  #######PAGE5#########
  output$word = renderWordcloud2({wordcloud2(word_cloud, size=1.6,color="random-light",backgroundColor="#282B30")})
  
  
  #######PAGE6#########
  output$table = renderDataTable(data)
      
  
  
  
  




}))



