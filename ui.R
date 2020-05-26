source("./src/R/libs.R")
options(spinner.size=0.5)
prepro <- data.table::fread("data/raw/HIST_PAINEL_COVIDBR_23mai2020csv.csv", 
                            select=c("regiao","estado"))
##---------------------------------------------------##---------------------------------------------------
##---------------------------------------------------##---------------------------------------------------
htmlTemplate("index.html",
             button = actionButton(inputId = "btn-add-1", "Adicionar item"),
             FileInputjrs = fileInput("file1", "Carregue o arquivo",
                                      multiple = TRUE,
                                      accept = c("text/csv",
                                                 "text/comma-separated-values,text/plain",
                                                 ".csv")),
             Regiao = selectInput(inputId = "REG","Regiao", unique(prepro$regiao),multiple=TRUE, selected="Nordeste"),
             Estado = selectInput(inputId = "UF","Unidade Federativa",unique(prepro$estado),multiple=TRUE, selected = "CE"),
      
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             ##tab1 = withSpinner(DT::dataTableOutput("table1"), type=6,color="#00b300"),
             tab2 = withSpinner(dataTableOutput("table666"), type=6,color="#00b300"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             kpi1 = withSpinner(plotlyOutput("grafico1", height = "350px"), type=6,color="#00b300"),
             kpi2 = withSpinner(plotlyOutput("grafico2", height = "350px"), type=6,color="#00b300"),
             kpi4 = withSpinner(plotlyOutput("graphinput", height = "350px",width = "100%"), type=6,color="#00b300"),
             kpi5 = withSpinner(plotlyOutput("graphinput2", height = "350px",width = "100%"), type=6,color="#00b300"),
             kpi7 = withSpinner(plotlyOutput("graphinput3", height = "320px",width = "100%"), type=6,color="#00b300"),
             kpi8 = withSpinner(plotlyOutput("graphinput4", height = "320px",width = "100%"), type=6,color="#00b300"),
             kpi9 = withSpinner(plotlyOutput("graphinput5", height = "600px",width = "100%"), type=6,color="#00b300"),
             kpi6 = withSpinner(plotlyOutput("KPIdados", height = "350px"), type=6,color="#00b300"),
             ##kpi2 = withSpinner(plotlyOutput("reativos", height = "299px"), type=6,color="#00b300"),
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             info = textOutput("qtdObt"),
             info2 = textOutput("qtdRecup"),
             info3 = textOutput("incid"),
             info4 = textOutput("mortdd"),
             
             ##---------------------------------------------------##---------------------------------------------------
             ##---------------------------------------------------##---------------------------------------------------
             menuitem1 = icon("shopping-bag"),
             menuitem2 = icon("shopping-cart"),
             menuitem3 = icon("question-circle"),
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

