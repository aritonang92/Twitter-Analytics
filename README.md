# Analisa dasar mengenai Text Mining (Case study: Akun Twitter Presiden RI Joko Widodo)
Menganalisa Tweet yang diposting oleh Presiden RI Joko Widodo menggunakan Bahasa R (R languange).
Roadmap analisa adalah sebagai berikut : 

1. Melakukan retrieving data menggunakan Twitter API
2. Data Cleaning menggunakan library 'tm', 'stringr', dan 'tidyverse'. Memisahkan tweet sesuai jenisnya (Retweet, Reply dan Like), lalu dilakukan analisa engagement yang memberikan hasil perbandingan Retweet vs Reply va Like. Proses data cleaning selanjutnya adalah membuang kata non-alfabet seperti : Link (https), tanda baca (titik, koma dll), dan stopwords (atau kata-kata sambung seperti : dan, atau, ke, dll) - dalam hal ini kumpulan berbagai kata sambung tersebut kita rancang sendiri karena tidak tersedia dalam package bahasa R.
3. Tahap terakhir adalah melihat kata yang paling sering di-Tweet oleh Presiden Joko Widodo, visualisasi menggunakan barplot dan wordcloud, sehingga dari sini dapat memberikan sedikit wawasan terkait pesan/maksud yang sering diberikan oleh Presiden Joko Widodo. 
