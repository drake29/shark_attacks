library(ggplot2)

shinyServer <- function(input, output) {
  output$map = renderGvis({
    gvisGeoChart(Country_attacks, locationvar="Country", 
                 colorvar="Number_of_Attacks",
                 options=list(projection="kavrayskiy-vii",
                              width=500,
                              height=500))
    
  })
  
  output$table = renderGvis({
    gvisTable(Country_attacks, options = list(page='enable'))
    
    })
  
  output$graph = renderPlot({
    ggplot(top_10, aes(x= Country, y= Number_of_Attacks)) + geom_col() +
      ggtitle("Top 10 Shark Attacks by Country") + theme_solarized() + scale_fill_solarized()
    
  })
  
  data = sharks 
  
  output$downloadData = downloadHandler(
       filename = function() {
         paste('data-', Sys.Date(), '.csv', sep='')
       },
       content = function(con) {
         write.csv(data, con)
       }
     )
  url = a("EPA:Sea Surface Temperatures", href="https://www.epa.gov/climate-indicators/climate-change-indicators-sea-surface-temperature")
  output$epa <- renderUI({
    tagList("URL link:", url)
  })
  
  output$activity = renderPlot({
    ggplot(act, aes(Activity, Attacked_activity)) + geom_col(aes(fill=Activity)) + ggtitle("Attacks by Activity") +
      theme_stata() + scale_fill_stata()
    
  })
  
  output$Type_attack = renderPlot({
    r = ggplot(type_attack, aes(x =Type, y=count, fill=Type)) + geom_col()
    r + coord_flip() + ggtitle("Nature of Attack")
    r + theme_economist() + scale_fill_economist()
    
  })
  
  output$Fatal_Activity = renderPlot({
   g= ggplot(fatal_act, aes(x=Activity, y= Most_fatal, fill=Activity)) + geom_col()
   g + coord_flip() + ggtitle('Fatal Attacks by Type of Activity')
   g + theme_economist() + scale_fill_economist()
   
   
  })

  output$usa_attack = renderLeaflet({
    leaflet(geo_location) %>% 
      setView(-100, 37.8, 2) %>% 
      addTiles() %>% 
      addCircles(lng = ~lon, lat= ~lat, weight=1, popup= ~Location)
  })
  
  
  scatter_input = reactive({
    
    switch(input$attack_type,
           "All Attacks"= all_year,
           "Fatal Attacks"= all_fatal,
           "Non-Fatal Attacks"= all_nonfatal
    )  }
  )

  output$scatter_all = renderPlot({
    attack_type = scatter_input()
    ggplot(attack_type, aes(x=Year, y=num_Attacks)) + geom_point() + geom_smooth() +
      ggtitle("Fatal vs. Non-Fatal Attacks")
  })
  
  output$ocean_temp = renderPlot({
    ggplot(temp_attacks, aes(x=Year, y=Temp_Anomoly)) + geom_point() + geom_smooth() +
      ggtitle("Average Global Sea Surface Temperature")
  })
  
  outlier = reactive({
    switch(input$click,
           '1' = "Attempting to kill a shark with explosives",
           '2'= "Washing horses",
           '3' = 'Suicide',
           '4'= 'Defecating in water beneath the docks',
           '5'= 'Surfing on air mattress',
           '6'= 'Dynamite fishing',
           '7' = 'Escaping From Alcatraz',
           '8' = 'Bathing with sister',
           '9' = 'Sleeping in Anchored Boat',
           '10' = 'Thanks for Visiting!')
  })
  
  output$text = renderPrint({
    outlier()
    
  
    
  })
  
    
  output$img = renderImage({
    filename= normalizePath(file.path('./images',
                                      paste('image', input$click, '.jpg', sep='')))
    list(src = filename,
         width= 615,
         height=350)
    
    
  }, deleteFile = FALSE)

  
}

  


