library(xml2)
library(ggplot2)

#args = commandArgs(trailingOnly=TRUE)

# need to find the html files.
xml_files = list.files(path="/Users/iain.emsley/git/dhrepro/dhq", pattern=".html", recursive = TRUE, full.names=TRUE)

found=list()

for (i in xml_files) 
{ 
  tmp <- read_html(i);

  if (grepl("github", tmp, ignore.case = TRUE))
  { 
    found <- c(i,found);
  } 
}
unfound <- unique(unlist(found, use.names = FALSE))
print(length(unfound) / length(xml_files))

vec = vector();
xmlfiles = vector();
#get a count list of volume names 
for (fn1 in xml_files) {
  s <- strsplit(fn1, '/');
  tmppaste = strtoi(gsub(" ","",paste(s[[1]][7],s[[1]][8])));
  xmlfiles <- c(xmlfiles, tmppaste);
}
#get a count list of volume numbers where the item occurs
for (fn in unfound) {
  s <- strsplit(fn, '/');
  tmppaste = strtoi(gsub(" ","",paste(s[[1]][7],s[[1]][8])));
  vec <- c(vec, tmppaste);
}

t1 = table(unlist(xmlfiles))
t2 = table(unlist(vec))

d1 = as.data.frame(t1)
d2 = as.data.frame(t2)

df = merge.data.frame(d1, d2, by="Var1", all.x = TRUE)

g <- ggplot(data=df, aes(df$Var1)) + geom_line(aes(y=df$Freq.x, color="Published"), group=1)  + geom_point(aes(y=df$Freq.y, color="Items"), group=1)
g <- g + xlab("Journal Issue")
g <- g + ylab("Occurences")

ggsave("/Users/iain.emsley/git/dhrepro/images/github.png")
