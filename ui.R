
shinyUI(dashboardPage(
  dashboardHeader(title="My Shiny Dashboard"),
  dashboardSidebar(
    sidebarUserPanel("NEAL DRAKOS",
                     image= "http://cdn.newsapi.com.au/image/v1/external?url=http%3A%2F%2Fvideomam.news.com.au.s3.amazonaws.com%2Fgenerated%2Fprod%2F05%2F06%2F2015%2F29717%2Fimage1024x768.jpg%3Fcount%3D5&width=650&api_key=kq7wnrk4eun47vz9c5xuj3mc"),
    sidebarMenu(
      menuItem('Homepage', tabName='Welcome', icon=icon("home")),
      menuItem("Map", tabName = "map", icon = icon("globe")),
      menuItem("Class", tabName = "scatter", icon = icon("life-buoy")),
      menuItem("Graph", tabName = "graph", icon = icon("area-chart")),
      menuItem("Activity", tabName='outliers', icon = icon("anchor")))
  ),
    
  dashboardBody(
    tabItems( 
      tabItem(tabName = "Welcome",
              h1("A Look at Gloabl Shark Attacks", align="center"),
              h2("From: 1900 - 2016", align="center"),
              img(src= "https://imgix.ranker.com/list_img_v2/8982/2148982/original/the-most-horrifying-shark-attacks-ever-recorded-u1?w=817&h=427&fm=jpg&q=50&fit=crop",
                  width="90%"),
              br(),
              br(),
              h3("Project Background:"),
              p('The dataset was discovered on Kaggle and contains a total of 5,992 shark attacks ever recorded. For the
                purpose of illustration and relevance, this study only focuses on the shark attacks reported in the 20th century
                through 2016. Additionally, the majority of attacks in the dataset were recorded within the above time period, bringing the
                total number of observations under this subset to 5,324.')),
              
              
      tabItem(tabName = "map",
              h2("All Global Shark Attacks reported from 1900-2016", align='center'),
              h3("by Country", align='center'),
              br(),
              h5('Check the map or scroll the table for your country of interest', align='center'),
              br(),
              fluidRow(
                column(3,
                       htmlOutput('map', align='left'),height=300),
                column(9,
                       htmlOutput('table', align='right'), height=500)),

              br(),
              br(),
              h3('Top 10 Chart:'),
              fluidRow(plotOutput('graph'))),
                       
              
      
      
      tabItem(tabName= "scatter",
              h1('A Look at the Number of Attacks:'),
              h4("Are shark attacks increasing?"),
              selectizeInput(inputId = 'attack_type',
                             label = 'Select the type of Attack',
                             choices),
              fluidRow(plotOutput("scatter_all")
              ),
              br(),
              br(),
              h3("Could warming ocean temperatures contribute to this?"),
              fluidRow(plotOutput('ocean_temp'))),
      
      tabItem(tabName= 'graph',
              fluidRow(column(width=12),
                       column(width=12),
                       (plotOutput('activity'))),
              br(),
              br(),
              fluidRow((plotOutput('Type_attack')))),
      
              
      tabItem(tabName= 'outliers',
              fluidRow((plotOutput('Fatal_Activity'))),
              (textOutput("text1")),
              actionButton("go", label='Outliers')
              

    )
            
          
                     )
))
)








