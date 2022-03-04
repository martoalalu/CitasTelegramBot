#install.packages(c("janitor", "XML", "RCurl", "rlist", "tidyverse", "telegram.bot"))

library(XML)
library(RCurl)
library(rlist)
library(tidyverse)
library(janitor)
library(telegram.bot)

url <- getURL("https://www.cgeonline.com.ar/informacion/apertura-de-citas.html",.encoding = 'UTF-8',.opts = list(ssl.verifypeer = FALSE) )

tables <- readHTMLTable(url)

df <- tables$`NULL`

#Pasaportes
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

#Nacimientos
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


#Citas
link_citas <- "Dejo el link para chequear por si les pinta: https://www.cgeonline.com.ar/informacion/apertura-de-citas.html"

#Bot
bot <- Bot(token = "1917827697:AAFjdGbFQQV_kPYFvcCO012duyDrGLxfWHY")

#print(bot$getMe())
#updates <- bot$getUpdates()
#chat_id <- updates[[1L]]$from_chat_id()

chat_id <- -671579379 ##Del chat grupal de consulado


bot$sendMessage(chat_id = chat_id, 
                text = texto_pasaporte)

bot$sendMessage(chat_id = chat_id, 
                text = texto_nacimientos)

bot$sendMessage(chat_id = chat_id, 
                text = link_citas)



##MEJORADO

#if (is.na(proxima_pas)) {
#  bot$sendMessage(chat_id = chat_id, 
#                  text = paste("La ultima apertura de citas para pasporte fue hace", ultima_pas, "dias. Y la proxima no se sabe aun..."))
#} else {
  
#  bot$sendMessage(chat_id = chat_id, 
#                  text = paste("ATENCION!!! HAY CITAS DISPONIBLES PARA TRAMITAR TU PASAPORTE!!
#                               Ingresa a https://www.cgeonline.com.ar/tramites/citas/modificar/modificar-cita-consulado.html y agenda!"),
#  bot$senPhoto(chat_id = chat_id, 
#                  photo = "https://www.intermundial.es/blog/wp-content/uploads/2017/07/11-preguntas-que-debes-saber-sobre-el-pasaporte-espa%C3%B1ol.jpg"))
#}

