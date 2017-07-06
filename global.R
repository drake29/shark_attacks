library(plyr)
library(dplyr)
library(ggplot2)
library(data.table)
library(googleVis)
library(shiny)
library(shinydashboard)
library(ggthemes)
library(ggmap)
library(leaflet)
library(rsconnect)

getwd
#library(Amelia)
sharks = fread(file = './attacks.csv')
temps = fread(file="./cleanocean_temps.csv")
colnames(temps)[2] = "Temp_Anomoly"
geo_location = read.csv('./geo_location1.csv')
#missmap(sharks, main = "Missing values vs observed")

#Insepcting data structure:
#dim(sharks)
#sapply(sharks, function(x) length(unique(x)))

#Inspecting Missingness:
#sapply(sharks,function(x) sum(is.na(x)))
#missmap(sharks, main = "Missing values vs observed")


#Reduce the area of study to the 20th Century-Present
start_year= 1900
end_year = 2017

shark.df = sharks %>%
  filter(Year>= start_year & Year < end_year) %>% 
  select(Date,Year,Type,Country,Location,Activity,Sex,Age,`Fatal (Y/N)`)

temp.df = temps %>% 
  filter(Year>= start_year & Year < end_year)


leaflet(geo_location) %>% 
  addTiles() %>% 
  addCircles(lng = ~lon, lat= ~lat, weight=1, popup= ~Location)



Country_attacks = shark.df %>% 
  group_by(Country) %>% 
  arrange(desc(Country)) %>% 
  summarise(Number_of_Attacks=n()) %>% 
  arrange(desc(Number_of_Attacks))
Country_attacks[1,1]="UNITED STATES" #Change 'USA' to 'United States' for googlevis plotting
Country_attacks[24,1]="COUNTRY NAME UNKNOWN"

all_year = shark.df %>%
  group_by(Year) %>% 
  summarise('num_Attacks'= n())

all_fatal = shark.df %>% 
  group_by(Year) %>% 
  filter(`Fatal (Y/N)` == 'Y') %>% 
  summarise('num_Attacks'=n())

all_nonfatal = shark.df %>% 
  group_by(Year) %>% 
  filter(`Fatal (Y/N)` == 'N') %>% 
  summarise('num_Attacks'=n())

temp_attacks = full_join(all_year, temp.df)

map_attacks = shark.df %>% 
  select(Year, Country) %>% 
  group_by(Country, Year) %>%
  arrange(desc(Year)) %>% 
  summarise(Yearly_attacks=n())

choices = c("All Attacks", "Fatal Attacks", 'Non-Fatal Attacks')

choices2 = as.numeric(c(1900:2016))


us_attacks = shark.df %>% 
  select(Country, Year, Activity) %>% 
  filter (Country == 'USA') %>% 
  group_by(Activity) %>% 
  summarise(Attacked_activity = n()) %>% 
  arrange(desc(Attacked_activity)) %>% 
  top_n(Attacked_activity, n= 10)
us_attacks[3,1]="Activity Not reported"

choices1 = us_attacks[ ,1]



Country_attacks1 = shark.df %>% 
  group_by(Country) %>% 
  arrange(desc(Country)) %>% 
  summarise(Number_of_Attacks=n()) %>% 
  arrange(desc(Number_of_Attacks)) %>% 
  summarise('top_10' = n())
Country_attacks[1,1]="UNITED STATES"


 type_attack = shark.df %>% 
   group_by(Type) %>% 
   summarise('count'= n())
 
 act = shark.df %>% 
   select(Country, Year, Activity) %>% 
   group_by(Activity) %>% 
   summarise(Attacked_activity = n()) %>% 
   arrange(desc(Attacked_activity)) %>% 
   top_n(Attacked_activity, n= 10)
 act[3,1] = "Activity Not Reported"
 
 fatal_act = shark.df %>% 
   filter(`Fatal (Y/N)` == 'Y') %>% 
   group_by(Activity) %>% 
   summarise('Most_fatal'=n()) %>% 
   arrange(desc(Most_fatal)) %>% 
   top_n(Most_fatal, n=8)
 fatal_act[2,1] = 'Activity Unknown'
 
 random_fatal = shark.df %>% 
   filter(`Fatal (Y/N)` == 'Y') %>% 
   group_by(Activity) %>% 
   summarise('Most_fatal'=n()) %>% 
   arrange(desc(Most_fatal))
 
 
special_cases = c("Attempting to kill a shark with explosives", "Suicide",
                  "Bathing with sister", "Defecating in water beneath the docks",
                  "Dynamite fishing", 'Surfing on air mattress', "Washing horses" )
 

r = ggplot(type_attack, aes(x =Type, y=count)) + geom_col(aes(fill=Type))
r + theme_economist() + scale_fill_economist()

top_10 = shark.df %>% 
  group_by(Country) %>% 
  arrange(desc(Country)) %>% 
  summarise(Number_of_Attacks=n()) %>% 
  arrange(desc(Number_of_Attacks)) %>% 
  top_n(Number_of_Attacks, n=10)
Country_attacks[1,1]="UNITED STATES"


vis = gvisGeoChart(Country_attacks, locationvar="Country", 
             colorvar="Number_of_Attacks",
             options=list(projection="kavrayskiy-vii",
                          width=500,
                          height=500))



#rsconnect::setAccountInfo(name='drake29', token='6AC01B15246C88A688F4B840261FCFD6', secret='kLYt9aOZPuxcYHITKSPqeF08KtT8oxX2djhVDkXe')

#rsconnect::deployApp('~/projects/shark_attacks')
 

  
