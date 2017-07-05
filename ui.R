
shinyUI(dashboardPage(
  dashboardHeader(title="My Shiny Dashboard"),
  dashboardSidebar(
    sidebarUserPanel("NEAL DRAKOS",
                     image= "http://cdn.newsapi.com.au/image/v1/external?url=http%3A%2F%2Fvideomam.news.com.au.s3.amazonaws.com%2Fgenerated%2Fprod%2F05%2F06%2F2015%2F29717%2Fimage1024x768.jpg%3Fcount%3D5&width=650&api_key=kq7wnrk4eun47vz9c5xuj3mc"),
    sidebarMenu(
      menuItem('Homepage', tabName='Welcome', icon=icon("home")),
      menuItem("Map", tabName = "map", icon = icon("globe")),
      menuItem("Timeline", tabName = "scatter", icon = icon("life-buoy")),
      menuItem("Activity Graph", tabName = "graph", icon = icon("area-chart")),
      menuItem("Fatal Activity", tabName='outliers', icon = icon("anchor")))
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
              br(),
              h5('Check the map or scroll the table for your country of interest', align='left'),

              fluidRow(background='light-blue',
                tabBox(width=11, height= 250, 
                  title = "A Global View",
                  
                  tabPanel("World Map", htmlOutput('map', width='90%')),
                  tabPanel("World Table", htmlOutput('table')),
                  tabPanel('USA Location Map', leafletOutput('usa_attack'))))),
              
      
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
              h3("The Type of Activity at the Time of Attack:", align='left'),
              fluidRow(column(width=12),
                       column(width=12),
                       (plotOutput('activity'))),
              br(),
              br(),
              br(),
              h4("The Nature of Incident:"),
              fluidRow(plotOutput('Type_attack'))),
              
              
      
              
      tabItem(tabName= 'outliers',
              h1('The Most Dangerous Activities'),
              fluidRow(plotOutput('Fatal_Activity')),
              br(),
              fluidRow(
                box(width=11,
                    h1("Death by..."),
                     actionButton('click', label='next'),
                    h2(textOutput('text')),
                    background = 'navy',
                    br(),
                    (imageOutput('img'))))
                
                )
              )
      )))








