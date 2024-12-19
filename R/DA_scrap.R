


# Download all files that make up the _Diccionario de Autoridades_.
# They have divide into 69422 files 
# The trick is to analize the URL that the on line app gives for
# every entry. It is a very long string. And somewhere within that string,
# there is a DocId= followed by a five digit number.
# The trickiest part was to guess the upper limit. I can't remember how I
# guess it, but I reached the last number was 69422. This number was the only
# part that has to change to collect (harvest) all files.
# This instuction builds the series of numbersas between 0 and 69422

file_index <- 1:69422

# But computers are computers. They are very good handling numbers as numbers, but not
# when they see them as character. Computers are so silly that after 1 does not came 2
# but 10. So we have to pad the number with leading zeroes in such a way that 2 goes
# after 1. So, as or las number is five digits long, all numbers must have four, three,
# two and one leading zeroes. Something that can be done easily with this command:

file_index <- stringr::str_pad(1:69422, 5, pad = "0")

# The numbers stored in file_index have to be added in the middle (more or less) of the long string we have
# divided inyto two sections: urla before the number, and urlb after the number.

urla <- "http://web.frl.es/dtSearch/dtisapi6.dll?cmd=getdoc&DocId="
urlb <- "&Index=C%3a%5cinetpub%5cwwwroot%5cDA%5fINDEX&HitCount=1&hits=1+&SearchForm=%2fDA%5fform%2ehtml"

# To test if it works, we can use this little loop, that with do all the job for us:

  for (i in 1:10){
    download.file(paste(urla,
                        file_index[i],
                        urlb,
                        sep = ""),
                  paste(file_index[i],
                        ".html",
                        sep = ""))
  }

# It does, so let us download to our computer all the material…

for (i in 1:length(file_index)){
  download.file(paste(urla,
                      file_index[i],
                      urlb,
                      sep = ""),
                paste(file_index[i],
                      ".html",
                      sep = ""))
}





library(rvest)
pages_entrada <- list.files("60001-69422/")
pages <- paste("60001-69422/", pages_entrada, sep = "")
pages_entrada <- gsub(".html", "", pages_entrada)
for(i in 1:length(pages)){
  page_2_scrap <- read_html(pages[i])
  file_name <- page_2_scrap %>%
    html_node("base") %>%
    html_attr("href")
  file_name <- gsub("http://web.frl.es/DA_DATOS/TOMO_.*?_HTML/", "", file_name)
  file_name <- gsub(".html", "", file_name)
  file_name <- paste(file_name, "_", pages_entrada[i], ".txt", sep = "")
  entry_text <- page_2_scrap %>%
    html_node('div[class="def"]') %>%
    html_text2()
  entry_text <- gsub("Diccionario de Autoridades - Tomo [IV]+ \\(17\\d+\\)\\n\\n", "", entry_text)
  writeLines(entry_text,
             paste("DA_output_files", file_name, sep = "/"))
}


# Without dowloading the files

for(i in 1:10){
  page_2_scrap <- read_html(paste(urla,
                            file_index[i],
                            urlb,
                            sep = ""))
  file_name <- page_2_scrap %>%
    html_node("base") %>%
    html_attr("href")
  file_name <- gsub("http://apps.rae.es/DA_DATOS/TOMO_.*?_HTML/", "", file_name)
  file_name <- gsub("html", "txt", file_name)
  file_name <- gsub("html", "txt", file_name)
  entry_text <- page_2_scrap %>%
    html_node('div[class="def"]') %>%
    html_text2()
  entry_text <- gsub("Diccionario de Autoridades - Tomo [IV]+ \\(17\\d+\\)\\n\\n", "", entry_text)
  writeLines(entry_text, file_name)
}
