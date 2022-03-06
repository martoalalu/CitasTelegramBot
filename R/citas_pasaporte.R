library(XML)
library(RCurl)
library(rlist)
#library(tidyverse)
library(janitor)
library(telegram.bot)

#bot <- Bot(token = token)
bot <- Bot(token = Sys.getenv("token")

#bot <- Bot(token = "1917827697:AAFjdGbFQQV_kPYFvcCO012duyDrGLxfWHY")

CHAT_ID <-Sys.getenv("CHAT_ID")
#CHAT_ID <- -671579379 #TEST
#CHAT_ID <- -503564772 #PROD

url <- getURL("https://www.cgeonline.com.ar/informacion/apertura-de-citas.html",.encoding = 'UTF-8',.opts = list(ssl.verifypeer = FALSE) )

tables <- readHTMLTable(url)

df <- tables$`NULL`

df <- clean_names(df)

ultima_pas <- as.character(difftime(Sys.Date(), as.Date(as.character(df[df$servicio=='Pasaportesrenovación y primera vez',][2]),format = "%d/%m/%Y"),units = c("days")))
#proxima_pas <- as.Date(as.character(df[df$servicio=='Pasaportesrenovación y primera vez',][3]),format = "%d/%m/%Y")




if (df[df$servicio=='Pasaportesrenovación y primera vez',][3]=="fecha por confirmar") {
  
  bot$sendMessage(chat_id = CHAT_ID, 
                  text = paste("\xF0\x9F\x98\x94 Todavia no hay nuevas citas disponibles para pasaporte.\nLa ultima fue hace", ultima_pas, "dias"))
  
 # bot$sendMessage(chat_id = CHAT_ID, 
#                  text = "Dejo el link para chequear por si les pinta \xF0\x9F\x91\x87: https://www.cgeonline.com.ar/informacion/apertura-de-citas.html")
  
} else {
 
  bot$sendMessage(chat_id = CHAT_ID, 
                  text = paste("\xF0\x9F\x98\x83 \xF0\x9F\x87\xAA\xF0\x9F\x87\xB8 \xF0\x9F\x98\x83 \xF0\x9F\x87\xAA\xF0\x9F\x87\xB8 \xF0\x9F\x98\x83 \xF0\x9F\x87\xAA\xF0\x9F\x87\xB8 ATENCION! YA HAY FECHA DISPONIBLE PARA TURNOS DE PASAPORTE\n\n", as.character(df[df$servicio=='Pasaportesrenovación y primera vez',][3]), "\xF0\x9F\x87\xAA\xF0\x9F\x87\xB8"))
  
  bot$sendMessage(chat_id = CHAT_ID, 
                  text = "Ingresa aca para gestionar tu cita \xF0\x9F\x91\x87: https://www.cgeonline.com.ar/tramites/citas/modificar/modificar-cita-consulado.html")
}



ultimo_nacimiento <- as.character(difftime(Sys.Date(), as.Date(as.character(df[df$servicio=='Registro Civil-Nacimientos',][2]),format = "%d/%m/%Y"),units = c("days")))
#proximo_nacimiento <- as.Date(as.character(df[df$servicio=='Registro Civil-Nacimientos',][3]),format = "%d/%m/%Y")


if (df[df$servicio=='Registro Civil-Nacimientos',][3]=="fecha por confirmar") {
  
  bot$sendMessage(chat_id = CHAT_ID, 
                  text = paste("\xF0\x9F\x98\x94 Todavia no hay nuevas citas disponibles para nacimientos.\nLa ultima fue hace", ultimo_nacimiento, "dias"))
  
  #bot$sendMessage(chat_id = CHAT_ID, 
  #                text = "Dejo el link para chequear por si les pinta \xF0\x9F\x91\x87: https://www.cgeonline.com.ar/informacion/apertura-de-citas.html")
} else {
  
  bot$sendMessage(chat_id = CHAT_ID, 
                  text = paste("\xF0\x9F\x98\x83 \xF0\x9F\x87\xAA\xF0\x9F\x87\xB8 \xF0\x9F\x98\x83 \xF0\x9F\x87\xAA\xF0\x9F\x87\xB8 \xF0\x9F\x98\x83 \xF0\x9F\x87\xAA\xF0\x9F\x87\xB8 ATENCION! YA HAY FECHA DISPONIBLE PARA TURNOS DE NACIMIENTOS\n\n", as.character(df[df$servicio=='Registro Civil-Nacimientos',][3]),"\xF0\x9F\x87\xAA\xF0\x9F\x87\xB8"))
  
  bot$sendMessage(chat_id = CHAT_ID, 
                  text = paste("Ingresa aca para gestionar tu cita \xF0\x9F\x91\x87: https://www.cgeonline.com.ar/tramites/citas/modificar/modificar-cita-consulado.html"))
}

