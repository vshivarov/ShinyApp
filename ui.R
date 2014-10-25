library(shiny)
library(rCharts)

shinyUI(pageWithSidebar(
        headerPanel("Gene expression in acute leukemia"),
        sidebarPanel(
                selectInput("Disease", h4("Reference type of leukemia"),
                                   c("ALL" = "ALL",
                                     "AML" = "AML"), selected="ALL"),
                selectInput("Adjustment", label = h4("Adjustment method"), 
                            choices = list("BH" = "BH", "B" = "bonferroni",
                                           "FDR" = "fdr", "None"="none"), selected = "BH"),
                sliderInput("Cutoff", label = h4("P-value Cut-off"),                    
                    min = 0.01, max=0.05, step=0.01, value=0.01),
                selectInput("Sort", label = h4("Sorting parameter"), 
                            choices = list("logFoldChange" = "logFC", "AverageExpr" = "AveExpr",
                                           "Adjusted P-value" = "P", "None"="none"), selected = "P"),
                numericInput("gnum", 
                     label = h4("Number of genes"), 
                     value = 10),
                submitButton("Update View"),
                numericInput("gID", label = h4("Gene ID"), 
                          value = NULL),
                submitButton("Submit")
                ),
        mainPanel(
                tabsetPanel(type = "tabs",
                        tabPanel("Background", 
                                 includeText("back_golub.txt"),
                                 br()
                                 ),
                        tabPanel("Table",dataTableOutput('topTable')),
                        tabPanel("Heatmap",plotOutput('Heat')),
                        tabPanel("Gene",h4(textOutput("geneID")),
                        plotOutput('ExprPlot'))
                        )
        )
)
)