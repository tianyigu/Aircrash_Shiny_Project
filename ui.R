library(shinythemes)
library(plotly)

shinyUI(
  navbarPage(
    tags$head(
      tags$style(HTML(".my_style_1{ margin-top: -20px; margin-left: -15px; margin-right: -15px;
                      background-image: url(http://dailypooper.com/uploads/original_photos/Article_Images/1912448032.aircrash.jpg);
                      background-size: 100% auto;background-repeat: no-repeat
                      }"))),
             title = "Aircrash Insight", 
    id ="main",
    
    theme = shinytheme("slate"), 
    tabPanel("HOME",
             class="my_style_1",
             fluidPage(
               fluidRow(
                 column(8,
                        "" ),
                 column(4,
                        br(),
                        br(),
                        br(),
                        h1("Aircrash Insight"))
                 
               ),
               fluidRow(
                 br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),""
               )
               
               
             )),
    tabPanel("TIMELINE",
             fluidRow(
               column(8,plotOutput('year')),
               column(4,br(),br(),br(),p(paste("There should be some description of plot")))
             ),
             fluidRow(
               column(4,br(),br(),br(),p(paste("There should be some description of plot"))),
               column(8,plotOutput('groyear'))
             ),
             fluidRow(
               column(8,plotOutput('grotime')),
               column(4,br(),br(),br(),p(paste("There should be some description of plot")))
             )),
                            
    tabPanel("TYPE OF CRASHED FLIGHT",              
              fluidRow(
                
                column(3,br(),br(),br(),p(paste(""))),
                column(9,plotOutput('grosize',height="250px",width = 800))
             ),
              fluidRow(
                column(3,
                    
                      br(),
                      sliderInput(inputId = "yearselect", h4("Select Years Range"), min = 1900, max = 2010, value = c(1900, 2010)),
                      br(),br(),
                      checkboxGroupInput(inputId ="checkbox", label = h4("Select Aircraft Manufacturer"), 
                              choices = list('All' = "All","Airbus" = "Airbus","Antonov" = "Antonov",'BAe' = 'BAe', 'Boeing'= 'Boeing', 'Cessna' = 'Cessna', 'CRJ'='CRJ', 'de Havilland'= 'de Havilland', 'Douglas'= 'Douglas','Embraer'='Embraer'), selected = ("All"))
                ),
                           
                          
                column(9,
                      h3(""),
                      plotOutput(outputId = "graph1", width=800 ),
                      br(),
                      plotOutput(outputId = "graph2",height="325px", width=800 ))
                      
                          
    
      )),
    
    tabPanel("AIRLINES",              
             fluidRow(
               plotlyOutput(outputId = "operate", width=1200, height =800),br(),
           
               br()),
             fluidRow(
               column(3,
               
               br(),br(),
               sliderInput(inputId = "yearselect1", h4("Select Years Range"), min = 1900, max = 2010, value = c(1900, 2010))),
               
               column(9,
                      h3(""),
                      br(),br(),
                      plotOutput(outputId = "graph3", width=800 )                        
    
    
    
    
    ))
  ))
  )
  
  
      








