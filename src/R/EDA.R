##-----------------------------------------------------------------------------##
#fazer join com a chave populacao$estado
rm(list=ls())
gc(reset=TRUE)
library(data.table)
library(ggplot2)
library(dplyr)
library(magrittr)
library(tidyr)
library(viridis)
library(lubridate)
library(purrr)
source("../SRC/MyGgthemes.R")

options(warning = FALSE, warnings = -1, warn =-1)
setwd("~/COVID/")

dadosBr <- readxl::read_excel("DATA/RAW/MAIN/HIST_PAINEL_COVIDBR_20mai2020.xlsx")
dadosBr <- dadosBr[!is.na(dadosBr$populacaoTCU2019),]
dadosBr$populacaoTCU2019 <- as.double(dadosBr$populacaoTCU2019)
dadosMun <- readxl::read_excel("DATA/RAW/AUXILIARY/A221833189_28_143_208.xlsx")
dadosMun$CodUF<-substr(dadosMun$Município,1,2)
dadosBr %<>% mutate(chave = paste(coduf, populacaoTCU2019))
dadosMun %<>% mutate(chave = paste(CodUF, População_estimada))
dadosBr <- left_join(dadosBr, dadosMun, 
                     by=c("chave" = "chave")) 

##-----------------------------------------------------------------------------##
##-----------------------------------------------------------------------------##
dadosBr <- dadosBr[c("regiao","Município", "estado", "municipio", "coduf", "codmun", "codRegiaoSaude", 
                     "nomeRegiaoSaude", "data", "semanaEpi", "populacaoTCU2019", "casosAcumulado", 
                     "obitosAcumulado", "Recuperadosnovos", "emAcompanhamentoNovos")]

##as_tibble(dadosBr) %>% nest(-estado) -> teste
#obter os dados temporais para o maximo de cada data

##-----------------------------------------------------------------------------##
#Prerpocessamento
Saltos <- function(x){
  i=1; saltos = numeric(length(x))
  while(x[i]-x[i+1] >= 0  && i < length(x)){
    x[i]-x[i+1] -> saltos[i]
    i = i+1 
  }
  return(saltos)
}

Prepro <- function(dataset){
  dataset$semanaEpi <- as.numeric(dataset$semanaEpi)
  dataset$populacaoTCU2019 <-as.numeric(dataset$populacaoTCU2019)
  dataset$casosAcumulado <-as.numeric(dataset$casosAcumulado)
  dataset$obitosAcumulado <-as.numeric(dataset$obitosAcumulado)
  dataset %<>% mutate(taxaObito = obitosAcumulado/casosAcumulado)
  return(dataset)
}
##-----------------------------------------------------------------------------##
##-----------------------------------------------------------------------------##
Prepro(dadosBr) -> prepro



prepro %>% filter(regiao == "Brasil") %>% ggplot(aes(as.Date(data),casosAcumulado,group=1))+
geom_line(colour="steelblue")+tema2+scale_y_continuous(breaks=seq(0,300000,20000))+
scale_x_date(date_labels = "%d %b %Y",date_breaks = "5 day")+
theme(axis.text.x = element_text(angle=45))

# prepro %>% filter(regiao=="Nordeste",estado=="CE", !is.na(Município)) %>% 
#   ggplot(aes(.$data, taxaObito,colour=Município,group=Município))+
#   geom_line()+
#   scale_y_continuous(limits = c(0,0.09), breaks = seq(0,1,0.009))+
#   tema2+labs(title="Taxa de Mortalidade COVID19 ao longo do 
#              \ntempo para todo o Brasil")+theme(legend.position = "none")

##-----------------------------------------------------------------------------##
##-----------------------------------------------------------------------------##