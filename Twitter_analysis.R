library(rtweet)
library(tidyverse)
library(ggplot2)

#Connect to Twitter API (This token information shall be secret)
twitter_token <- create_token(
  app = "****",
  consumer_key = "****",
  consumer_secret = "****",
  access_token = "****",
  access_secret = "****",
  set_renv = TRUE
)

#Mengambil tweet dari akun @jokowi 
# (nilai n = 3200 menunjukkan jumlah maksimal tweets yang bisa diambil oleh Twitter)
jokowi <- get_timeline("@jokowi", n = 3200)

#Membuang retweet
jokowi_organic_tweet <- jokowi[jokowi$is_retweet == FALSE,]

#Membuang tweet reply
jokowi_organic_tweet <- subset(jokowi_organic_tweet, is.na(jokowi_organic_tweet$reply_to_status_id))
view(jokowi_organic_tweet)

#Analisa engagement akun twitter @jokowi (Like dan Retweet)
# 1.Melihat tweet Jokowi dengan urutan yang paling banyak di Likes
likes <- jokowi_organic_tweet %>% arrange(-favorite_count)

# 2.Melihat tweet @jokowi yang paling banyak di retweet (descending)
retweet <- jokowi_organic_tweet %>% arrange(-retweet_count)

#Analisa ratio reply/likes/organic tweets
#Mebuat dataframe hanya retweet
jokowi_retweet <- jokowi[jokowi$is_retweet == "TRUE", ]
view(jokowi_retweet)

#Membuat dataframe hanya reply
jokowi_reply <- subset(jokowi, !is.na(jokowi$reply_to_status_id))

#Membuat data jumlah masing2 (organic, retweet, reply)
n_jkw_organic <- nrow(jokowi_organic_tweet)
n_reply <- nrow(jokowi_reply)
n_retweet <- nrow(jokowi_retweet)

analisis <- data.frame(
  Kategori = c("Organic", "Retweet", "Reply"),
  Jumlah = c(n_jkw_organic,n_retweet,n_reply)
)
#Menampilkan barplot Perbandingan Jumlah Organic vs Retweet vs Reply Tweet
library(ggplot2)
ggplot(data = analisis) + geom_bar(mapping = aes(x = Kategori, y = Jumlah, fill = Kategori), stat = "identity")

#Membersihkan tweet dari berbagai hal yang tak diinginkan (link url dan tanda baca)
jokowi_organic_tweet$text <- gsub("https\\S*", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("@\\S*", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("amp", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("[\r\n]", "", jokowi_organic_tweet$text)
jokowi_organic_tweet$text <- gsub("[[:punct:]]", "", jokowi_organic_tweet$text)

#Menghilangkan kata sambung, kata panggil dll (list dibuat sendiri)
library(tidytext)
library(tm)
library(tidyverse)
tweets <- jokowi_organic_tweet %>% select(text)
tweets <- lapply(tweets, tolower)
x = readLines('C://Users/LENOVO/Desktop/STEM/stopwords.txt') #List yang mengandung kata-kata sambung/panggilan yang dibuat sendiri
y = tweets$text
y = removeWords(y,x) %>% str_squish()
tweets$text_new <- y
tweets <- as_tibble(tweets)
tweets <- tweets %>% select(text_new) %>%
  unnest_tokens(word, text_new)


#Melakukan plot yang menghasilkan 15 kata unik yang sering di-Tweet oleh akun @jokowi
tweets %>% 
  count(word, sort = TRUE) %>%
  top_n(15) %>%
  mutate(word = reorder(word, n)) %>%
  ggplot() + 
  geom_bar(mapping = aes(x = reorder(word,n), y = n), stat = "identity", fill = "blue") + coord_flip() +
  labs(x = "Kata unik", y = "Jumlah Tweet", title = "Kata yang sering di-Tweet oleh Presiden Jokowi", subtitle = "*Kata-kata sambung telah dihilangkan")

#Membuat wordcloud yang berisi kata-kata unik dari tweet @jokowi
library(wordcloud)
library(RColorBrewer)
set.seed(1234)
wordcloud(tweets$word, min.freq = 1, max.words = 150, random.order = FALSE, rot.per=0.35, colors = brewer.pal(8,"Dark2"))
