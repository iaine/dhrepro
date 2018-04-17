library(tidyr)
library(plyr)

files = list.files(path="/Users/iain.emsley/git/dhrepro/dhq/", pattern=".html", recursive = TRUE, full.names=TRUE)

found = list()
f = list()
#found_df  = data_frame(lines=as.character(), text = as.character(),stringsAsFactors=FALSE)
for (i in files) 
{ 
  tmp <- read_html(i)
  if (grepl("reproducib(ility|le)", tmp, ignore.case = TRUE)) {
    g = xml_text(xml_find_all(tmp, './/p'))
    for (j in g) 
    {
      f <- c(i, f)
      found <- c(found, trimws(j))
    }
  }
}

found_df  = data_frame(lines=as.character(f), text = as.character(found))

dh_bigrams <- found_df %>%
  unnest_tokens(bigram, text, token = "ngrams", n = 2)

bigrams_separated <- dh_bigrams %>%
  separate(bigram, c("word1", "word2"), sep = " ")

bigrams_filtered <- bigrams_separated %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
bigram_counts <- bigrams_filtered %>% 
  count(word1, word2)

bigram_counts