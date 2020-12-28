library(httr)
library(XML)
library(psych)
library(readxl)

db = read_xlsx("../Desktop/backup/KISTI/Research/GIQ 전자정부 IT기술/GiqData_madeByJslee_ver03.xlsx")
idx = db$country
idx = gsub(" ","-",idx)
idxLen = length(idx)

rndSpnd = list()
for (i in 1:idxLen) {
  url = paste0('https://knoema.com/atlas/',idx[i],'/RandD-expenditure')
  html = htmlParse(GET(url))
  
  dataList = readHTMLTable(html)
  df = as.data.frame(dataList, stringsAsFactors = F)
  
  if (length(df)!=0) {
    initYear = which(df$NULL.Date==2013)
    if (length(initYear)!=0) {
      dfVal = as.numeric(as.character(df$NULL.Value[1:initYear]))
      rndSpnd[[i]] = cbind(idx[i], round(geometric.mean(dfVal),2))
    }
  }
  cat(paste("iteration:",i,"/",idxLen,"\n"))
}

write.csv(do.call(rbind, rndSpnd), "C://Users/user/Desktop/backup/KISTI/Research/GIQ 전자정부 IT기술/rndSpendings.csv",row.names=F)
