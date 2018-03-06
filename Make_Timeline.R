#Мартынов А.А.  7 вариант

library('RCurl')
library('XML') 

searchURL <- "https://yandex.ru/yandsearch?text="

searchURL.Api <- "https://yandex.ru/search/xml?query="
search.settings <- c()

file.output <- './Timeline.csv'

search.queries <- c("пикачу %i",
                    "райчу %i",
                    "голем %i")
year.low <- 2000
year.high <- 2010
data <- data.frame()

for(year in year.low:year.high){
  print(paste("ПОИСК", year))
  
  for(query in search.queries){
    fileURL <- paste0(searchURL, sprintf(query, year))
    fileURL <- URLencode(fileURL)
    
    html <- getURL(fileURL, followLocation = T)
    doc <- htmlTreeParse(html, useInternalNodes = T)
    rootNode <- xmlRoot(doc)
    
    links <- xpathSApply(rootNode, '//a[contains(@class, "link organic__url")]',
                         xmlGetAttr, 'href')
    
    headers <- xpathSApply(rootNode, '//a[contains(@class, "link organic__url")]',
                           xmlValue)
    
    sources <- xpathSApply(rootNode, '//div[@class="path organic__path"]',
                           xmlValue)
    
    data.request <- data.frame(Year = year, Header = headers, Source = sources, URL = links)
    
    #append request data to data frame
    data <- rbind(data, data.request)
    
    # prevent yandex captcha service
    Sys.sleep(0.1)
  }
}

write.csv(data, file = file.output, row.names = F)

print('Конец')

