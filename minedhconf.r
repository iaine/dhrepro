library(ggplot2)

files <- list.files(path="/Users/iain.emsley/git/dhrepro/dhabstracts/raw", pattern = "*.txt", full.names = TRUE)

texts <- list()
my_lines <- list()
for (file in files){
  my_lines <- readLines(file, warn=FALSE) # read lines from file into a list
  
  for (line in my_lines) {
    if (grepl("github", line, ignore.case = TRUE))
    { 
      texts <- c(file,texts);
    }
  }
}

untextfiles <- list();
for (f1 in texts) {
  tmps <- strsplit(f1, '/');
  st <- tools::file_path_sans_ext(tmps[[1]][8]);
  tmppaste = strtoi(st);
  untextfiles <- c(untextfiles, tmppaste);
}


d2 = as.data.frame(table(unlist(untextfiles)))

#df = merge.data.frame(d1, d2, by="Var1", all.x = TRUE)

g <- ggplot(data=d2, aes(x=d2$Var1,y=d2$Freq), group=1) + geom_point()
g <- g + xlab("Conference Year")
g <- g + ylab("Occurences of Github")

ggsave("/Users/iain.emsley/git/images/dhcgithub.png")