library(tidyverse)
library(sf)
library(leaflet)

jm_data <- read_csv("C:/Users/samtg/github/cc_election_cleaning/precinct_level_efa_nypd_noise_dec03.csv")
jm_short <- jm_data %>%
  select(!c(Shape_Leng,Shape_Area,geometry))
#drop data with high NA
jm_short <- jm_short%>%
  select_if(~ mean(is.na(.)) <= 0.15)
rio::export(jm_short,'clustering_raw_data.csv')
df <- read_csv('clustering_raw_data.csv')

eds <- read_sf('nyed_22a')
cc<- read_sf('city_council')
eds <- st_transform(eds, crs = 4326)
random_color <- function() {
  sample(c("red", "yellow", "green", "orange"), size = 1)
}

for (i in seq_along()) {
  country_boundaries$features[[i]]$style <- list(fillColor = random_color())
}


leaflet(eds) |> 
  addTiles() |> 
  setView(40, -74, zoom = 10) |> 
  addPolygons(
    fillColor = ~pal(cluster), 
    color = "white", 
    weight = 2, 
    opacity = 1, 
    fillOpacity = 0.7
  ) |> 
  addLegend(pal = pal, values = ~cluster, title = "District Clusters")

results <- read_csv("C:/Users/samtg/github/cc_election_cleaning/election_results_with_vote_sponsor_cluster_DEC04.csv")
colnames(results)
district_level <- results%>%
  filter(winner == TRUE)%>%
  select(!c("Precinct","vote","total_vote_precinct",  
            "vote_share", "ed_name", "winner", "rank" ,"candidate",              
            "matched_name" , "kmode_cluster" , "ElectDist_x",         
            "ML4", "ML6" , "ML5" ,                   
            "ML2" , "ML7" , "ML3" ,"ML1" ,  "district_cluster" , "ElectDist_y", "Shape_Leng" ,
            "Shape_Area", "geometry" ))%>%
  group_by(district)%>%
    summarise_if(is.numeric, mean, na.rm = TRUE)
rio::export(district_level,'district_level.csv')

colnames(df)
lookup<-c(non_hispanic_white = 'nhw21p',non_hipanic_black = 'nhb21p',
          non_hispanic_asian = 'nha21p',hispanic = 'h21p',biden_share_2020 ='pg20jrbp',
          trump_share_2020 = 'pg20djtp',female_headed_household = 'femHHH_ratio',
          median_household_income = 'mhhi21',ba_or_more_share = 'cvap21bapp',
          irish_ancestry = "rv21italp",italian_ancestry = "rv21irp", west_indian_share = "winda21p",
          percent_homeowners = "p21own",percent_renters = "p21rent",
          percent_oos_whites = 'white_transplant_ratio', percent_fb_blacks = "black_fb_ratio",
          percent_nys_born_blacks = "black_nys_ratio"
)
df <- rename(df, all_of(lookup))
