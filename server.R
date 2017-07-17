library(shiny)
library(jsonlite)
library(lubridate)
library(dplyr)
library(data.table)
library(ggplot2)
options(scipen=99999999)

base_url <- 'https://www.cryptocompare.com'
response<- fromJSON(paste0(base_url, '/api/data/coinlist/'))
coin_list <- data.table::rbindlist(response$Data, fill=TRUE)
coin_list$TotalCoinSupply <- as.numeric(coin_list$TotalCoinSupply)
coin_list$TotalCoinsFreeFloat <- as.numeric(coin_list$TotalCoinsFreeFloat)
coin_list$TotalCoinsMined <- as.numeric(coin_list$TotalCoinsMined)
coin_list$PreMinedValue <- as.numeric(coin_list$PreMinedValue)

coin_list$SortOrder <- as.numeric(coin_list$SortOrder)
coin_list$Name <- paste0('<a href="',base_url,coin_list$Url,'">',coin_list$Name,"</a>" )
coin_list$`_` <- paste0("<img src='",base_url, coin_list$ImageUrl,"' style='width:30px;height:30px;'/>")

# saveRDS(coin_list, 'coin_list.rds')
# coin_list<- readRDS('coin_list.rds')

algorithms <- coin_list %>% 
 group_by(Algorithm) %>% 
 summarize(Coins=paste(Name, collapse=", "), 
           CoinCount=n()) %>% arrange(desc(CoinCount))

prooftype <- coin_list %>% 
 group_by(ProofType) %>% 
 summarize(Coins=paste(Name, collapse=", "), 
           CoinCount=n()) %>% arrange(desc(CoinCount))

shinyServer(function(input, output) {

 output$coin_table <- renderDataTable({
   coin_list %>% arrange(SortOrder) %>%
   select(`_`, Name, CoinName, Algorithm, ProofType, PreMinedValue, 
          TotalCoinSupply, TotalCoinsMined, TotalCoinsFreeFloat, Popularity=SortOrder)
   
 }, escape=FALSE, options = list(pageLength = 10))
 
 output$algorithms <- renderDataTable({
  algorithms
 }, escape=FALSE, options = list(pageLength = 10))
 
 output$prooftype <- renderDataTable({
  prooftype
 }, escape=FALSE, options = list(pageLength = 10))
 
 output$algorithms_chart <- renderPlot({
  algorithms %>% 
   arrange(desc(CoinCount)) %>%
   ggplot(aes(x=reorder(Algorithm, CoinCount), y=CoinCount)) + 
   geom_bar(stat="identity") +
   xlab("") + 
   theme_bw() +
   coord_flip() 
 })
 
 output$prooftype_chart <- renderPlot({
  prooftype %>% 
   arrange(desc(CoinCount)) %>%
   ggplot(aes(x=reorder(ProofType, CoinCount), y=CoinCount)) + 
   geom_bar(stat="identity") +
   xlab("") + 
   theme_bw() +
   coord_flip() 
 })
})
