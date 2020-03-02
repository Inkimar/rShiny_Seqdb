# https://db.rstudio.com/dbi/ , https://db.rstudio.com/databases/postgresql/ 
# https://www.datacareer.de/blog/connect-to-postgresql-with-r-a-step-by-step-exampl/efa
# https://www.r-bloggers.com/rpostgresql-and-schemas/
# tt <- read.csv("Downloads/specimens.csv", header = T) # read.table oxå.
getwd()
library(DBI)
# library(RPostgreSQL)
library(RPostgres)
# con <- dbConnect(RPostgres::Postgres())
db <- 'seqdb_prod'  #provide the name of your db
host_db <- 'localhost' #i.e. # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'  
db_port <- '5432'  # or any other port specified by the DBA
db_user <- 'postgres'  
db_password <- 'postgres'
db_schema <- 'seqdb' # hur kopplar jag mot detta schema ?
con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)  
# install.packages('RPostgreSQL')
dbListTables(con) 
dbWriteTable(con, "mtcars", mtcars) # Fungerar

collection_query <- dbSendQuery(con, 'SELECT * FROM seqdb.collectioninfos')
result <- dbFetch(collection_query)
result;
dbClearResult(collection_query)

## Using a view, only on local-database , hur kör jag 'where species 
# public_query <- dbSendQuery(con, 'SELECT * FROM seqdb.vw_public20200227A')
species <- "arctos"
species
public_query <- dbSendQuery(con, paste0("SELECT * FROM seqdb.vw_public20200227A WHERE species = '", species ,"'"))
public_result <- dbFetch(public_query)
public_result
dbClearResult(public_query)
saveRDS(public_result, "pr.RDS")
## For maps
install.packages("leaflet")
library(leaflet)

install.packages("dplyr")
library(dplyr)


# dark_all , light_all , light_only_labels
m <- leaflet(public_result) %>% addTiles('http://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png', 
                                         attribution='Map tiles by <a href="http://nrm.se">CGI</a>, <a href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a> &mdash; Map data &copy;
                              <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>')


m %>% addCircles(~decimallongitude, ~decimallatitude, popup="", weight = 3, radius=40, 
                 color="#ffa500", stroke = TRUE, fillOpacity = 0.8) %>% 
  addLegend("bottomright", colors= "#ffa500", labels="CGI Development", title="CGI @NRM")

