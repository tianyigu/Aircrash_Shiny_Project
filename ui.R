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
    tabPanel("Home",
             class="my_style_1",
             fluidPage(
               fluidRow(
                 column(8,
                        "" ),
                 column(3,
                        br(),
                        br(),
                        br(),
                        h1("Aircrash Insight"),br(),
                        h4("If you can walk away from a landing, it's a good landing. If you use the airplane the next day, it's an outstanding landing."),
                        h4("--Chuck Yeager"))
                 
               ),
               fluidRow(
                 br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),br(),""
               )
               
               
             )),
    tabPanel("Time Line",
             fluidRow(
               column(8,plotOutput('year')),
               column(4,br(),br(),br(),h5("Overview of number of air crash over year "))
             ),
             fluidRow(
               column(4,br(),br(),br(),h5("After 1970, total amount of people die from air crash is decreasing. The death ratio went down from over 90% to around 65%.")),
               column(8,plotOutput('groyear'))
             ),
             fluidRow(
               column(8,plotOutput('grotime')),
               column(4,br(),br(),br(),h5("Number of aircrash are distinguish by day and night. Death ratio during night is higher than during day"))
             )),
                            
    tabPanel("Type of crashed airplane",              
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
    
    tabPanel("Airlines",              
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
  ),
    tabPanel("Data", 
             fluidRow(
               column(12,
                      dataTableOutput('table'))))
  )
  )
  









