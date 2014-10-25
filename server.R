library(shiny)
library(multtest)
data(golub)
library(limma)
library(rCharts)


shinyServer(function(input, output) {
        gol.fac<-factor(golub.cl, levels=c(0,1), labels=c("ALL","AML"))
        bluered <- colorRampPalette(c("blue","white","red"))(256)
        col.fac<-factor(gol.fac, levels=c("ALL","AML"), labels=c("red","blue"))
        col.fac<-as.character(col.fac)
        design<-model.matrix(~gol.fac)
        colnames(design)<-c("ALL","AML")
        fit<-lmFit(golub,design)
        fit2<-eBayes(fit)
        results <- reactive({
                cbind(
                        ID=as.character(rownames(topTable(fit2, coef =input$Disease,adjust=input$Adjustment, p.value=input$Cutoff, sort.by=input$Sort, number=input$gnum))),
                        topTable(fit2, coef =input$Disease,adjust=input$Adjustment, p.value=input$Cutoff, sort.by=input$Sort, number=input$gnum)
                        )
        })
        selectedData <- reactive({
                golub[input$gID, ]
        })
        
        heatMap<-reactive({
                heatmap(golub[as.numeric(rownames(topTable(fit2, coef =input$Disease,adjust=input$Adjustment, p.value=input$Cutoff, sort.by=input$Sort, number=input$gnum))), ], ColSideColors=col.fac,Rowv=NULL, Colv=NULL, labCol=F, labRow=rownames(topTable(fit2, coef =input$Disease,adjust=input$Adjustment, p.value=input$Cutoff, sort.by=input$Sort, number=input$gnum)),col=bluered)
        })
        output$topTable<-renderDataTable({
                results()}, options = list(
                        pageLength = 10)
        )
        
        output$Heat<-renderPlot({
                heatMap()           
        })
        output$geneID<-reactive({
                golub.gnames[input$gID,2]
        })
        output$ExprPlot <- renderPlot({
                boxplot(selectedData()~gol.fac, col=c("red","blue"), ylab="Expression", xlab="Leukemia Type")
        })
})