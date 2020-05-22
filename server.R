##------------------------##
##------------------------##
#setwd("~/COVID/SHINY/")fd
library("glue")
source("src/R/libs.R")
source("src/R/MyGgthemes.R")
library(shiny)
##library(shinyWidgets)
library(tidyverse)
library(DT)
library(shiny)
##install.packages("rsconnect")
##source("./src/R/kpi1.R")
options(shiny.maxRequestSize = 500*1024^2)
##------------------------##
tema <- theme(
  plot.title=element_text(size=12)
)
prepro <- readRDS("data/preprocessed/RDS/Prepro.RDS")
prepro <- as.data.frame(prepro)

# df <- economics %>%
# select(date, psavert, uempmed) %>%
# gather(key = "variable", value = "value", -date)

## SHINY SERVER FUNCTION 
##------------------------##
function(input, output,session){
  
  filteredData <- reactive({prepro})
  
  filtered_df <- reactive({
    
    res <- filteredData() %>% filter(regiao == input$REG, estado == input$UF, is.na(Município))
    # res <- res %>% filter(projected_grade >= input$projected)
    # res <- res %>% filter(age >= input$age[1] & age <= input$age[2])
    # res <- res %>% filter(ethnicity %in% input$ethnicity | is.null(input$ethnicity))
    # 
    res
    
  })
  
  output$table666 <- renderDataTable({
    res <- filtered_df() 
    res
    
  })
  
  output$KPIdados <- renderPlotly({
    #   ##if(is.null(arquivo())){return(NULL)}
    #
    
    ggplot(filtered_df(),aes(as.Date(data),casosAcumulado, group=1))+
      geom_line(colour="steelblue")+
      scale_y_continuous(limits = c(0,50000), breaks = seq(0,50000,2000))+
      scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
      tema2+theme(legend.position = "none")+tema2+theme(legend.position = "none")+
      labs(x="Data",y="Quantidade de Casos (Cumulativo)")-> gp
    gp<-ggplotly(gp)
    
    # config(collaborate=FALSE,
    #  cloud=FALSE,
    #  displaylogo=FALSE,
    #  modeBarButtonsToRemove=c(
    #    "select2d",
    #    "sendDataToCloud",
    #    "pan2d",
    #    "resetScale2d",
    #    "hoverClosestCartesian",
    #    "hoverCompareCartesian",
    #    "lasso2d",
    #    "zoomIn2d",
    #    "zoomOut2d")
    #  )
    # 
     ##gp <- layout(gp, margin=list(t = 100),autosize = F)
    
     gp
  })
  

filtered_df2 <- reactive({
     res2 <- filteredData() %>% filter(regiao == "Brasil")
     res2
})
output$graphinput  <- renderPlotly({


      ggplot(filtered_df2(),aes(as.Date(data), casosAcumulado, group = 1))+
      geom_line(colour = "steelblue")+tema2+
      scale_y_continuous(breaks = seq(0, 300000, 20000))+
      scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
      theme(axis.text.x = element_text(angle = 45))+
      labs(x = "Data", y = "Quantidade de Casos (Cumulativo)")



})


output$graphinput1 <- renderPlotly({
      ggplot(filtered_df2(),aes(as.Date(data), obitosAcumulado, group = 1))+
      geom_line(colour = "steelblue")+tema2+
      scale_y_continuous(breaks = seq(0, 32000, 2000))+
      scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
      theme(axis.text.x = element_text(angle = 45))+
      labs( x = "Data", y = "Quantidade de Óbitos (Cumulativo)")
})
  
  
output$qtdObt <- renderText({
  
  paste(round((max(filtered_df2()$obitosAcumulado)/max(filtered_df2()$casosAcumulado))*100,3),"%")
  
  
})


output$qtdRecup <- renderText({

  max(na.omit(as.double(filtered_df2()$Recuperadosnovos)))
  
})

output$graphinput2 <- renderPlotly({
      ggplot(filtered_df2(),aes(as.Date(data), obitosAcumulado, group = 1))+
      geom_line(colour = "steelblue")+tema2+
      scale_y_continuous(breaks = seq(0, 32000, 2000))+
      scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
      theme(axis.text.x = element_text(angle = 45))+
      labs(title="", x = "Data", y = "Quantidade de Óbitos (Cumulativo)")
})



filtered_df3 <- reactive({
  res3 <- filteredData()  %>% filter(is.na(Município),regiao != "Brasil")
  res3
})

output$graphinput3 <- renderPlotly({
  
  ggplot(filtered_df3(),aes(as.Date(data), casosAcumulado,colour=estado,group=estado))+
  geom_line(size=0.5)+tema2+geom_point(size=0.5)+
  scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
      theme(axis.text.x = element_text(angle = 45))+
      labs(x = "Data", y = "Quantidade de Casos (Cumulativo)")

})

output$graphinput4 <- renderPlotly({
  
  ggplot(filtered_df3(),aes(as.Date(data), log(casosAcumulado),colour=estado,group=estado))+
  geom_line(size=0.3)+tema2+geom_point(size=0.5)+
  scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
      theme(axis.text.x = element_text(angle = 45))+
      labs(x = "Data", y = "Log da Quantidade de Casos (Cumulativo)")

})

  ##------------------------##
  
  ## Arquivo de entrada 2017-3
  
  ##------------------------##
  
  ## OBTENDO CAMINHO DO ARQUIVO APÓS A LEITURA
  
  # arquivo <- reactive({    
  #   infile <- input$file1
  #   if (is.null(infile)) {
  #     ##RETORNA NULL SE O ARQ NAO FOI CARREGADO
  #     return(NULL)}
  #   else{
  #     
  ##CASO CONTRARIO RETORNA O CAMINHO DO ARQUIVO E SALVA NO
  ##OBJETO REATIVO "arquivo"
  #   return(read_delim(infile$datapath,
  #                     ";", escape_double = FALSE, trim_ws = TRUE))
  # }
  # })
  
  
  ##------------------------##
  
  ## Arquivo de saída - Regras
  
  ##------------------------##
  
  # TabRegras <- reactive({
  #   if(is.null(arquivo())){return(NULL)}
  #   Alg(arquivo(), input$conf, input$sup)
  # })
  # 
  
  # output$VarsInput <- renderUI({
  #   selectInput(
  #     "cartAdd","Pesquise o produto desejado",
  #     choices=unique(TabRegras()[,1]),
  #     multiple = FALSE,
  #     selectize=TRUE
  #     )
  # 
  # 
  # })
  # 
  #   output$VarsInput2 <- renderUI({
  #     selectInput("recprod2", "selecioe  o produto recomendado:",
  #       choices =TabRegras()[,4], selected = c("teste"))
  #   })
  # # 
  # observe({
  #   escolhas = subset(TabRegras(),as.character(TabRegras()$NomeProduto)==factor(input$cartAdd))[,4]
  #   updateSelectInput(session,"recprod2",
  #     choices=escolhas$`Nome Produto recomendado`)
  # })
  
  ##-----------------------------------------------------------------------##
  ##-----------------------------------------------------------------------##
  ############################ SESSÃO DE KPI's ##############################
  ##-----------------------------------------------------------------------##
  # 
  # 
  ##gp <- layout(gp, margin=list(t = 100),autosize = F)
  
  
  ##-----------------------------------------------------------------------##
  
  
  
  ########################  TABELA DE RECOMENDAÇÃO ##########################
  
  ##-----------------------------------------------------------------------##
  
  
  # output$table2 <- DT::renderDataTable({
  #   datatable(
  #     TabRegras(),
  #     filter="top",
  #     extensions = c('Buttons'), 
  #     width="1500px",
  #     options = list( dom = 'Bfrtip',
  #       buttons = c('copy', 'csv', 'excel', 'pdf', 'print'),
  #       pageLength=dim(TabRegras())[1],              
  #       columnDefs = list(list(width = '500px', targets = c(2,3))),
  #                     ##deferRender = TRUE,
  #       scrollY = 400
  #                     ##lengthMenu = c(500, 1000, 1500, 3000,5000,10000,500000)))
  #       ))})
  # 
  # 
  
  
  # output$qtd <- renderText({
  # 
  #   if(is.null(TabRegras())){
  #     return(NULL)
  #   }
  #   format(length(unique(arquivo()$ORCAMENTO)))
  # })
  # 
  #   output$qtdRegras <- renderText({
  #     if(is.null(TabRegras())){
  #       return(NULL)
  #     }
  #     else{
  #       format(length((TabRegras()$Produto)))
  #     }
  #   })  
  
  objeto <- reactive({ input$dest_order })
  
  arquivoCompras <- reactive({ input$dest_order })
  output$order <- renderText({arquivoCompras()})
  ##observe({
  
  ##    toggle(id = "rpan2", condition = input$checkbox,anim = TRUE, animType = "slide", time = 0.5,
  ## selector = NULL)
  ##    })
  produtoSelect <- reactive({input$cartAdd})
  output$textoselecao <- renderText({as.character(produtoSelect())
  })
  
  produtoCruzado <- reactive({
    Mydf=data.frame(df.nomeProduto=produtoSelect())
    Mydf <- left_join(Mydf,Produtos_categoria,by=c(`df.nomeProduto`="PRODUTO"))
  })
  
  observeEvent(input$`btn-add-1`,{shinyjs::html("prod2",sprintf("<div id=\"%s\" class=\"product\"> 
                                                                <div class=\"product-image\">
                                                                <img src=%s>
                                                                </div>
                                                                <div class=\"product-details\">
                                                                <div class=\"product-title\">%s</div>
                                                                <p class=\"product-description\">
                                                                </p>
                                                                </div>
                                                                <div class=\"product-price\">
                                                                12.99
                                                                </div>
                                                                <div class=\"product-quantity\">
                                                                
                                                                <input type=\"number\" value=\"2\" min=\"1\">
                                                                </div>
                                                                <div class=\"product-removal\">
                                                                <button id=\"btn-remove\" style=\"width:100px;\" class=\"remove-product\">Remover</button>
                                                                </div>
                                                                <div class=\"product-line-price\">
                                                                25.98
                                                                </div>
                                                                </div>",input$cartAdd,paste0("/imagens",images[1]), input$cartAdd),add=TRUE)})
  
  
  observeEvent(input$`rm-prod-1` ,{
    shinyjs::toggle(input$cartAdd)
  }
  )
  
  
  
  produtos<-reactive({
    TabRegras() %>%  group_by(`COD_PRODUTO_RECOMENDADO`) %>% 
      dplyr::summarise(frequencia=n()) %>% 
      arrange(desc(frequencia)) 
    
    dataplot %>% mutate(linha=seq(1,nrow(dataplot),by=1))%>% filter(linha <= 10) %>% 
      mutate(freq=(frequencia/sum(frequencia))*100,
             freq_acu=(cumsum(frequencia)/sum(frequencia))*100)
    
    
  })
  
  
}




