library(tidytext)
library(stringr)
library(xml2)
library(dplyr)
library(tibble)
library(scales)
library(tidyr)
library(wordcloud)
library(ggplot2)
#todo: add the file name for full comparison

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
tidy_file = found_df %>% 
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word) %>%
  mutate(proportion = n / sum(n))

#frequency <- tidy_file %>% 
#  group_by(lines) %>% 
#  count(word, sort = TRUE) %>% 
#  left_join(tidy_file %>% 
#              group_by(lines) %>% 
#            summarise(total = n())) %>%
#  mutate(freq = n/total)
#frequency
#frequency <- frequency %>% 
#  select(lines, word, freq) %>% 
#  spread(lines, freq) #%>%
  #arrange("/Users/iain.emsley/git/dhrepro/dhq//10/4/000269/000269.html", "/Users/iain.emsley/git/dhrepro/dhq//11/2/000289/000289.html")

#frequency

#graph of terms : requires the todo to be done
graph <- ggplot(tidy_file, aes(x=population, y=population)) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  geom_text(aes(label = word), check_overlap = TRUE, vjust = 1.5) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  labs(y = "Words", x = NULL)

#generate wordlcloud
cloud <- found_df %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words) %>%
  count(word, sort=TRUE) %>%
  with(wordcloud(word, n, max.words = 100))

#result.vec <- table(unlist(lapply(found, function(text) {
#pairs <- combn(unique(scan(text=text, what='', sep=' ', allowEscapes = TRUE, na.strings = TRUE)), m=2)
#interaction(pairs[1,], pairs[2,])
#})))