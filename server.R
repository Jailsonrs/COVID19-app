        library("glue")
        source("src/R/libs.R")
        source("src/R/MyGgthemes.R")
        library(shiny)
        library(tidyverse)
        library(DT)
        library(shiny)
        library(viridis)
        library("scales")
        library("highcharter")
        options(shiny.maxRequestSize = 500*1024^2)

        tema <- theme(
          plot.title = element_text(size = 12)
          )

        ##prepro <- data.table::fread("data/raw/HIST_PAINEL_COVIDBR_23mai2020csv.csv",drop=c(1:3))
        ##colnames(prepro)
        ##prepro$data <- as.Date(prepro$data)
        ##saveRDS(prepro,"data/preprocessed/dados.RDS")
        prepro <- readRDS("data/preprocessed/dados.RDS")

        function(input, output, session){

          filteredData <- reactive({prepro})
          
          filtered_df <- reactive({
            res <- filteredData() %>% 
            filter(regiao == input$REG, is.na(codmun))
            res
          })

          filtered_df0 <- reactive({
            resultado <- filtered_df() %>% filter(estado == input$UF)
            resultado
          })

          newChoices <- reactive({
            unique(filtered_df()$estado)
          })

          observe({
            updateSelectInput(session, "UF",choices = newChoices(),selected="CE")
          })
          
          output$KPIdados <- renderPlotly({
            ggplot(filtered_df0(),aes(data, casosAcumulado, group = estado,colour=estado))+
            geom_line()+
            labs(x = "Data",y="Quantidade de Casos (Cumulativo)")+
            scale_x_date(date_labels = "%d %b %Y", date_breaks = "2 day")+
            tema2 -> gp
            gp <- ggplotly(gp)
             ##gp <- layout(gp, margin=list(t = 100),autosize = F)
            gp

          })
          
          filtered_df2 <- reactive({
           res2 <- filteredData() %>% filter(regiao == "Brasil")
           res2
         })

          output$graphinput  <- renderPlotly({
            ggplot(filtered_df2(),aes((data), casosAcumulado, group = 1))+
            geom_line(colour = "steelblue")+tema2+
            scale_y_continuous(breaks = seq(0, 300000, 50000))+
            scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
            labs(x = "Data", y = "Quantidade de Casos (Cumulativo)")
          })


          output$qtdObt <- renderText({

            paste(format(round((max(filtered_df2()$obitosAcumulado)/max(filtered_df2()$casosAcumulado))*100, 2), 
              digits = 2, 
              big.mark = ",",
              small.mark = ",",
              decimal.mark = ","),"%")
          })

          output$qtdRecup <- renderText({
            format(max(na.omit(as.double(filtered_df2()$Recuperadosnovos))),digits=10,big.mark=".", small.mark=",")  
          })

          output$incid <- renderText({
            format(round((max(filtered_df2()$casosAcumulado)/max(filtered_df2()$populacaoTCU2019))*100000, 6), 
              digits = 6,
              big.mark = ",",
              small.mark = ",",
              decimal.mark=",")
          })

          output$mortdd <-  renderText({
            format(round((max(filtered_df2()$obitosAcumulado)/max(filtered_df2()$populacaoTCU2019))*100000, 2),
             digits = 3,
             big.mark = ",",
             small.mark = ",",
             decimal.mark=",")
          })

          output$graphinput2 <- renderPlotly({
            ggplot(filtered_df2(),aes((data), log(obitosAcumulado), group = 1))+
            geom_line(colour = "steelblue")+tema2+
            scale_y_continuous(breaks = seq(0, 10, 2))+
            scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
            theme(axis.text.x = element_text(angle = 45))+
            labs(title="", x = "Data", y = "Quantidade de Óbitos (Cumulativo)")
          })

          filtered_df3 <- reactive({
            res3 <- filteredData()  %>% filter(is.na(codmun), regiao != "Brasil")
            res3
          })

          output$graphinput3 <- renderPlotly({

            ggplot(filtered_df3(),aes((data), casosAcumulado, colour = estado, 
              group=estado))+
            geom_line(size = 0.5)+tema2+geom_point(size = 0.5)+
            scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
            theme(axis.text.x = element_text(angle = 45))+
            labs(x = "Data", y = "Quantidade de Casos (Cumulativo)")

          })

          output$graphinput4 <- renderPlotly({
            # highchart2() %>% 
              #hc_title(text = "Not so slow chart ;)") %>% 
              ##hc_subtitle(text = "Thanks boost module") %>% 
              #hc_chart(zoomType = "x", animation = FALSE, type = "line") %>% 
              # hc_plotOptions(series = 
              #   list(allowForce= TRUE,
              #        turboThreshold = 1000,
              #        usePreAllocated = TRUE,
              #        marker=list(enabled=FALSE))) %>% 
              # hc_xAxis(type = "datetime", dateTimeLabelFormats = list(day = '%d of %b')) %>%
              # hc_add_series(data = filtered_df3(), 
              #               mapping = hcaes(x = (data), y = log(casosAcumulado,10), group = estado),type="line")

            ggplot(filtered_df3(),aes((data), log(casosAcumulado), 
              colour = estado,
              group = estado),text=sprintf("Data: %s<br>Log Qtd de casos: %s", data, casosAcumulado))+
            geom_line(size = 0.3)+tema2+geom_point(size = 0.5)+
            scale_x_date(date_labels = "%d %b %Y", date_breaks = "5 day")+
            theme(axis.text.x = element_text(angle = 45), legend.position="bottom")+          
            labs(x = "Data", y = "Log da Quantidade de Casos (Cumulativo)", group="Estado",colour="none")

          })


          filtered_df4 <- reactive({
            filteredData() %>% filter(is.na(codmun)) %>% 
              mutate(incidencia100k = (casosAcumulado/populacaoTCU2019)*100000,
                     morte100k = (obitosAcumulado/populacaoTCU2019)*100000) %>%
              filter(data == max(data)) %>%
              group_by(estado, morte100k) %>% 
              select(estado, municipio,data, incidencia100k,morte100k) ->res4
              res4
          })
    ## Ranking mortalidade
          output$graphinput5 <- renderPlotly({
            filtered_df4() %>% 
             ggplot(aes(reorder(estado, morte100k,max), 
                         morte100k, fill = morte100k))+
              geom_col(width=0.5, alpha=0.8, position = position_dodge(width=1))+
              tema2+coord_flip()+
              geom_text(aes(label = round(morte100k, 2)),colour="black",nudge_y = 1.2,size=2.6)+
              scale_fill_viridis(direction = -1, begin = 0, end = 0.6)+
              theme(axis.text.x = element_text(angle = 0), legend.position = "none")+
              labs(fill = "Incidência",y = "Óbitos por 100 mil Habitantes", x = "Estado")

              
            })      


          ##------------------------##
          
          ## Arquivo de entrada 2017-3
          
          ##------------------------##
          
          ##CASO CONTRARIO RETORNA O CAMINHO DO ARQUIVO E SALVA NO
          ##OBJETO REATIVO "arquivo"
          #   return(read_delim(infile$datapath,
          #                     ";", escape_double = FALSE, trim_ws = TRUE))
          # }
          # })
          
          
          
          
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
          
          ##    toggle(id = "rpan2", condition = input$checkbox,anim = TRUE, animType = "slide", time = 0.5,
          ## selector = NULL)
          ##    })
          
        }




