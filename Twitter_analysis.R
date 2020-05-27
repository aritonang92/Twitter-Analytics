library(rtweet)
library(tidyverse)
library(ggplot2)

#Retrieving data from TWITTER API
twitter_token <- create_token(
  app = "dhtamado",
  consumer_key = "C0AIGCi79i6FYaoxde5Btb8Ya",
  consumer_secret = "LgiTuPx133YPjxnUC7OLGrDi3FT2kksjENItKs1NSOLrXRRuaP",
  access_token = "61449429-m56kDNv8NBKYJy4rPoWJd6PJHXfyxdfYArDXIQlDB",
  access_secret = "wONWjKyc2SBWG1xKjlq2YmjbFWdrGUk5pxiMNBQYwuyAD",
  set_renv = TRUE
)

#Mengambil tweet dari akun pak jokowi
jokowi <- get_timeline("@jokowi", n = 3200)

#Membuang retweet
jokowi_organic_tweet <- jokowi[jokowi$is_retweet == FALSE,]

#Mmebuang tweet reply
jokowi_organic_tweet <- subset(jokowi_organic_tweet, is.na(jokowi_organic_tweet$reply_to_status_id))

#Analisa engagement akun twitter Jokowi
# 1.Melihat tweet Jokowi dengan urutan yang paling banyak di Likes
likes <- jokowi_organic_tweet %>% arrange(-favorite_count)
# 2.Melihat tweet Jokowi yang paling banyak di retweet (descending)
retweet <- jokowi_organic_tweet %>% arrange(-retweet_count)



#Analisa ratio reply/likes/organic tweets
#Mebuat dataframe  hanya retweet
jokowi_retweet <- jokowi[jokowi$is_retweet == "FALSE", ]

#Membuat dataframe hanya reply
jokowi_reply <- subset(jokowi, !is.na(jokowi$reply_to_status_id))

#membuat data jumlah masing2 (organic, retweet, reply)
n_jkw_organic <- nrow(jokowi_organic_tweet)
n_reply <- nrow(jokowi_reply)
n_retweet <- nrow(jokowi_retweet)

analisis <- data.frame(
  Kategori = c("Organic", "Retweet", "Reply"),
  Jumlah = c(n_jkw_organic,n_retweet,n_reply)
)
library(ggplot2)
ggplot(data = analisis) + geom_bar(mapping = aes(x = Kategori, y = Jumlah, fill = Kategori), stat = "identity")

#Membersihkan tweet dari berbagai hal yang tak diinginkan
jokowi_organic_tweet$text <- gsub("https\\S*", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("@\\S*", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("amp", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("[\r\n]", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("[[:punct:]]", "", jokowi_organic_tweet$text)
class(jokowi_organic_tweet$text)

library(tidytext)
library(tm)
library(tidyverse)
tweets <- jokowi_organic_tweet %>% select(text)
x = readLines('C://Users/LENOVO/Desktop/stopwords.txt')
y = tweets$text
y = removeWords(y,x)
tweets$text_new <- y
tweets$text_new

tweets <- tweets %>% 
  select(text_new) %>%
  unnest_tokens(word,text_new)
view(tweets)

tweets %>% # gives you a bar chart of the most frequent words found in the tweets
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot() + 
  geom_bar(mapping = aes(x = reorder(word,n), y = n), stat = "identity", fill = "blue") + coord_flip() +
  labs(x = "Kata unik", y = "Jumlah Tweet", title = "Kata yang sering di-Tweet oleh Presiden Jokowi", subtitle = "*Kata-kata sambung telah dihilangkan")
d <- as.data.frame(tweets)
as.data.frame(table(d)) %>% arrange(desc(Freq)) %>% view()

library(wordcloud)
library(RColorBrewer)
set.seed(1234)
wordcloud(tweets$word, min.freq = 1, max.words = 300, random.order = FALSE, rot.per=0.35, colors = brewer.pal(8,"Dark2"))
