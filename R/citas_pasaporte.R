library(XML)
library(RCurl)
library(rlist)
library(tidyverse)
library(janitor)
library(telegram.bot)

url <- getURL("https://www.cgeonline.com.ar/informacion/apertura-de-citas.html",.encoding = 'UTF-8',.opts = list(ssl.verifypeer = FALSE) )

tables <- readHTMLTable(url)

df <- tables$`NULL`


pasaporte <- df %>%
  clean_names() %>% 
  filter(servicio == 'Pasaportesrenovación y primera vez') %>% 
  select(ultima_apertura, proxima_apertura)


ultima_pas <- as.character(difftime(Sys.Date(), as.Date(pasaporte$ultima_apertura[1],format = "%d/%m/%Y"),units = c("days")))

proxima_pas <- as.character(difftime(Sys.Date(), as.Date(pasaporte$proxima_apertura[1],format = "%d/%m/%Y"),units = c("days")))

if (is.na(proxima_pas)) {
proxima_pas <- "No se sabe"
} else {
proxima_pas <- Sys.Date()
}

texto_pasaporte <- paste("La ultima apertura de citas para pasporte fue hace", ultima_pas, "dias. Y la proxima", tolower(proxima_pas))

nacimientos <- df %>%
  clean_names() %>% 
  filter(servicio == 'Registro Civil-Nacimientos') %>% 
  select(ultima_apertura, proxima_apertura)

ultima_nac <- as.character(difftime(Sys.Date(), as.Date(nacimientos$ultima_apertura[1],format = "%d/%m/%Y"),units = c("days")))

proxima_nac <- as.character(difftime(Sys.Date(), as.Date(nacimientos$proxima_apertura[1],format = "%d/%m/%Y"),units = c("days")))

if (is.na(proxima_nac)) {
  proxima_nac <- "No se sabe"
} else {
  proxima_nac <- Sys.Date()
}

texto_nacimientos <- paste("La ultima apertura de citas para inscripcion de nacimientos fue hace", ultima_nac, "dias. Y la proxima", tolower(proxima_nac))


link_citas <- "Dejo el link para chequear por si les pinta: https://www.cgeonline.com.ar/informacion/apertura-de-citas.html"


bot <- Bot(token = "1917827697:AAFjdGbFQQV_kPYFvcCO012duyDrGLxfWHY")


chat_id <- -671579379 


bot$sendMessage(chat_id = chat_id, 
                text = texto_pasaporte)

bot$sendMessage(chat_id = chat_id, 
                text = texto_nacimientos)

bot$sendMessage(chat_id = chat_id, 
                text = link_citas)


