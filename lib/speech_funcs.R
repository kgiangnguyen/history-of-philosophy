word_count <- function(str){
  library(stringr)
  return(str_count(str, '\\w+'))
}

speech_links <- function(html.page, node.type=".ver12 a"){
  urls <- html.page %>% # feed `main.page` to the next step
    html_nodes(node.type) %>% # get the CSS nodes
    html_attr("href") # extract the URLs
  # Get link text
  links <- main.page %>% # feed `main.page` to the next step
    html_nodes(node.type) %>% # get the CSS nodes
    html_text() # extract the link text
  # Combine `links` and `urls` into a data.frame
  out <- data.frame(links = links, urls = urls, stringsAsFactors = FALSE)
  
  return(out)
  
}

plotsent_len <- function(In.list, InFile, InType, InTerm, President){
  
  #"anticipation" "joy"          "surprise"     "trust"       
  #"anger"        "disgust"      "fear"         "sadness"
  
  col.use=c("light grey", "darkgoldenrod1", "darkgoldenrod1", "darkgoldenrod1", "darkgoldenrod1",
            "red2", "chartreuse3", "blueviolet","dodgerblue3")
  
  In.list$topemotion=apply(select(In.list, 
                                    anticipation:sadness), 
                                 1, which.max)
  In.list$topemotion.v=apply(select(In.list,
                                    anticipation:sadness), 
                                   1, max)
  In.list$topemotion[In.list$topemotion.v<0.01]=0
  In.list$topemotion=In.list$topemotion+1
  
  temp=In.list$topemotion.v
  In.list$topemotion.v[temp<0.05]=1
  
  df=In.list%>%filter(File==InFile, 
                            type==InType, Term==InTerm)%>%
    select(sent.id, word.count, 
           topemotion, topemotion.v)
  
  ptcol.use=alpha(col.use[df$topemotion], sqrt(sqrt(df$topemotion.v)))
  
  plot(df$sent.id, df$word.count, 
       col=ptcol.use,
       type="h", #ylim=c(-10, max(In.list$word.count)),
       main=President)
}
  
smooth_topic <- function(x, y.mat){
  y.out=y.mat
  for(i in 1:ncol(y.mat)){
    y.out[,i]=pmax(smooth.spline(x, y.mat[,i])$y, 0)
  }
  return(y.out)
}

get_emotions <- function(df) {
  emotions <- data.frame()
  
  for(i in seq(0, floor(nrow(df)/100), 1)) {
    print(paste("i is:", i))
    if((i*100 + 100) <= nrow(df)) {
      start <- i*100 + 1
      end <- i*100 + 100
    }
    else {
      start <- i*100 + 1
      end <- nrow(df)
    }
    
    temp <- df[start:end, ]
    emotions <- rbind(emotions, get_nrc_sentiment(temp$sentence_str))
  }
}