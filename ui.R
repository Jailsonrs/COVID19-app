source("./src/R/libs.R")
options(spinner.size=0.5)
prepro <- readRDS("data/preprocessed/RDS/Prepro.RDS")
prepro <- as.data.frame(prepro)
##---------------------------------------------------##---------------------------------------------------
##---------------------------------------------------##---------------------------------------------------
htmlTemplate("index.html",
             button = actionButton(inputId = "btn-add-1", "Adicionar item"),
             FileInputjrs = fileInput("file1", "Carregue o arquivo",
                                      multiple = TRUE,
                                      accept = c("text/csv",
                                                 "text/comma-separated-values,text/plain",
                                                 ".csv")),
             Regiao = selectInput(inputId = "REG","Regiao", unique(prepro$regiao), selected="Nordeste"),
             Estado = selectInput(inputId = "UF","Unidade Federativa",unique(prepro$estado), selected = "CE"),
             
             textinpt = textInput("teste","teste","Entre com a busca"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             ##tab1 = withSpinner(DT::dataTableOutput("table1"), type=6,color="#00b300"),
             tab2 = withSpinner(dataTableOutput("table666"), type=6,color="#00b300"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             seletor = selectInput("seletor", "selecione", choices=unique(colnames(mtcars)), width ="40px"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             kpi1 = withSpinner(plotlyOutput("grafico1", height = "350px"), type=6,color="#00b300"),
             kpi2 = withSpinner(plotlyOutput("grafico2", height = "350px"), type=6,color="#00b300"),
             ##---------------------------------------------------##---------------------------------------------------
             ##superior
             kpi4 = withSpinner(plotlyOutput("graphinput", height = "350px",width = "100%"), type=6,color="#00b300"),
             kpi5 = withSpinner(plotlyOutput("graphinput2", height = "350px",width = "100%"), type=6,color="#00b300"),
             kpi7 = withSpinner(plotlyOutput("graphinput3", height = "320px",width = "100%"), type=6,color="#00b300"),
             kpi8 = withSpinner(plotlyOutput("graphinput4", height = "320px",width = "100%"), type=6,color="#00b300"),
             ##---------------------------------------------------##---------------------------------------------------
             kpi6 = withSpinner(plotlyOutput("KPIdados", height = "350px"), type=6,color="#00b300"),
             ##kpi2 = withSpinner(plotlyOutput("reativos", height = "299px"), type=6,color="#00b300"),
             kpi3 = withSpinner(plotlyOutput("reativoss", height = "299px"), type=6,color="#00b300"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             confianca_seletor=numericInput("conf","Confianca",value=0.5,step=0.001),
             suporte_seletor=numericInput("sup","Suporte",value=0.0001,step=0.001),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             info = textOutput("qtdObt",container=a),
             info2 = textOutput("qtdRecup",container=a),
             info3 = textOutput("incid",container=a), 
             info4 = textOutput("mortdd",container=a), 
             engrenagem = icon("cogs"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             menuitem1 = icon("shopping-bag"),
             menuitem2 = icon("shopping-cart"),
             menuitem3 = icon("question-circle"),
             colnamestab =  verbatimTextOutput("texto"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             entrada1=orderInput('source', 'Produtos Recomendados', items = NULL,
                                 as_source = TRUE, connect = 'dest'),
             
             saida1 = orderInput('dest', 'Adicionar', items = NULL, placeholder = 'Drag items here...'),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             ll = verbatimTextOutput('order') ,
             ll2 = verbatimTextOutput("textoselecao"),
             rmbt = actionButton("rm-prod-1","remova"),
             btnRecomend=actionButton("btnrecup","atualizar recomendacao"),
             produtosAdd =uiOutput("VarsInput") ,
             prodrecomendado2= uiOutput("VarsInput2"),
             desconto = numericInput("offR","Selecione a taxa de desconto sob o valor do produto (%)",value=5,step=1)
)
##---------------------------------------------------##---------------------------------------------------
##---------------------------------------------------##---------------------------------------------------

