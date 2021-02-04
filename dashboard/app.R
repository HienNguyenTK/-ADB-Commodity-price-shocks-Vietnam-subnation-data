#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#



#```{r setup, warning = FALSE, error = FALSE, message = FALSE, echo = FALSE}
#knitr::opts_chunk$set(echo = TRUE)
if(!require(magrittr)) install.packages("magrittr", repos = "http://cran.us.r-project.org")
if(!require(rvest)) install.packages("rvest", repos = "http://cran.us.r-project.org")
if(!require(readxl)) install.packages("readxl", repos = "http://cran.us.r-project.org")
if(!require(dplyr)) install.packages("dplyr", repos = "http://cran.us.r-project.org")
if(!require(maps)) install.packages("maps", repos = "http://cran.us.r-project.org")
if(!require(ggplot2)) install.packages("ggplot2", repos = "http://cran.us.r-project.org")
if(!require(reshape2)) install.packages("reshape2", repos = "http://cran.us.r-project.org")
if(!require(shiny)) install.packages("shiny", repos = "http://cran.us.r-project.org")
if(!require(ggiraph)) install.packages("ggiraph", repos = "http://cran.us.r-project.org")
if(!require(RColorBrewer)) install.packages("RColorBrewer", repos = "http://cran.us.r-project.org")
#```



## Import the clean data
load("datadb.Rda")  #data to be used: Region, DataType, Shock, Variable, Period, Value
datadb[] <- lapply(datadb, as.character)
datadb$Value <- as.numeric(datadb$Value)


## Import VNM map data
load("VNM_data.Rda") #VNM map by province/region: long, lat, Province, Region



## Create table of historical data (left)
hisdata_long <- datadb[which(datadb$DataType=='Historical'),c(1,4,5,6)]
library(tidyr)
hisdata_wide <- spread(hisdata_long, Variable, Value)


## Create df for plotting map
df <- datadb[which(datadb$DataType == "Impulse responses" | datadb$DataType == "Cumulative impulse responses"),]
df$Period <- as.numeric(substring(df$Period, first = 2))
attach(df)
df <- df[order(Region, DataType, Shock, Variable, Period),]
detach(df)


## create table of variance data (right)
vardata <- datadb[which(datadb$DataType == "Variance decomposition"),]



## Creating an interactive world map (center)
#Next, it's time to define the function that we'll use for building our VNM maps. The inputs to this function are the merged data frame, the VNM_data containing geographical coordinates, and the data type, period, and indicator the user will select in the R Shiny app. We first define our own theme, *my_theme()* for setting the aesthetics of the plot. Next, we select only the data that the user has selected to view, resulting in *plotdf*. We keep only the rows for which the Region has been specified. We then add the data the user wants to see to the geographical world data. Finally, we plot the VNM map. The most important part of this plot is that contained in the *geom_polygon_interactive()* function from the *ggiraph* package. This function draws the world map in white with grey lines, fills it up according to the value of the data selected (either Unemployment, Inflation, Unemployment responses, Unemployment cumulative responses, Inflation responses, Inflation cumulative responses) in a red-to-blue color scheme set using the *brewer.pal()* function from the *RColorBrewer* package, and interactively shows at the tooltip the Region and value when hovering over the plot.

#```{r, warning = FALSE, message = FALSE}
VNMMaps <- function(df, VNM_data, shock, variable, data_type, period){
    
    # Function for setting the aesthetics of the plot
    my_theme <- function () { 
        theme_bw() + theme(axis.title = element_blank(),
                           axis.text = element_blank(),
                           axis.ticks = element_blank(),
                           panel.grid.major = element_blank(), 
                           panel.grid.minor = element_blank(),
                           panel.background = element_blank(), 
                           legend.position = "bottom",
                           panel.border = element_blank(), 
                           strip.background = element_rect(fill = 'white', colour = 'white'))
    }
    
    # Select only the data that the user has selected to view
    plotdf <- df[df$Shock == shock & df$Variable == variable & df$DataType == data_type & df$Period == period,]
    plotdf <- plotdf[!is.na(plotdf$Region), ]
    
    # Add the data the user wants to see to the geographical VNM_data
    VNM_data['Shock'] <- rep(shock, nrow(VNM_data))
    VNM_data['Variable'] <- rep(variable, nrow(VNM_data))
    VNM_data['DataType'] <- rep(data_type, nrow(VNM_data))
    VNM_data['Period'] <- rep(period, nrow(VNM_data))
    VNM_data['Value'] <- plotdf$Value[match(VNM_data$Region, plotdf$Region)]
    
    # Create caption with the data source to show underneath the map
    #capt <- paste0("Source: Authors calculation")
    
    # Specify the plot for the world map
    library(RColorBrewer)
    library(ggiraph)
    g <- ggplot() + 
        geom_polygon_interactive(data = VNM_data, color = 'gray70', size = 0.1,
                                 aes(x = long, y = lat, fill = Value, group = group,
                                     tooltip = sprintf("%s<br/>%s", Region, round(Value,2)))) + 
        scale_fill_gradientn(colours = brewer.pal(5, "RdBu"), na.value = 'white') + 
        #labs(fill = variable, color = variable, title = NULL, x = NULL, y = NULL, caption = capt) + 
        labs(fill = variable, color = variable, title = NULL, x = NULL, y = NULL, caption = NULL) + 
        my_theme()
    
    return(g)
}
#```



## Building an R Shiny app

#Now we have our data and VNM mapping function ready and specified, we can start building our R Shiny app. Please have a look at the [Getting Started guide](https://shiny.rstudio.com/tutorial/) to get familiar with Shiny app first. We can build our app by specifying the UI and server. In the UI, we include a fixed user input selection where the user can choose whether they want to see the unemployment, inflation, unemployment or inflation responses or cumulative responses. We further include dynamic inputs for the period and indicators the user wants to see. As mentioned before, these are dynamic because the choices shown will depend on the selections made by the user on previous inputs. We then use the *ggiraph* package to output our interactive VNM map. We use the *sidebarLayout* to be able to show the input selections on the left side and the VNM map on its right side. Everything that depends on the inputs by the user needs to be specified in the server function, which is here not only the VNM map creation but also the second and third input choices, as these depend on the previous inputs made by the user. For example, when we run the app later we'll see that when the user selects the unemployment data for the first input for data type, the second input will only show "Actual value", and the third indicator input will only show period. Same as the user selects the inflation data. When the user selects the unemployment responses data, the second input will show all the global commodity price shocks, and the third indicator will show different period.

#```{r, warning = FALSE, message = FALSE}
library(shiny)
library(shinyWidgets)
library(ggiraph)
shinyApp(
    
    # Define the UI
    ui = fluidPage(
        
        # App title
        titlePanel("VietNam: Regional Impacts of Global Commodity-Price Shocks"),
        #setBackgroundColor("beige"),
        
        br(),
        
        # Table of historical data
        #column(4, HTML(paste("Table 1. Historical data", "Source: Asian Development Bank", sep = "<br/>")),
        column(4, strong("Table 1. Historical data"),
               p(span("Source: Asian Development Bank", style = "color:blue")),
               
               selectInput(inputId = "region",
                           label = "Select region",
                           choices = list("Central Highlands" = "Central Highlands", "Mekong River Delta" = "Mekong River Delta", "North & South Central Coast" = "North & South Central Coast",
                                          "Northern Midlands & Mountains" = "Northern Midlands & Mountains", "Red River Delta" = "Red River Delta", "South East" = "South East")),
               
               tableOutput('datatable')),
        
        # Main panel for displaying map and table
        column(4, strong("Figure 1. Impulse responses to global commodity-price shocks"),
               
               # Hide errors
               tags$style(type = "text/css",
                          ".shiny-output-error { visibility: hidden; }",
                          ".shiny-output-error:before { visibility: hidden; }"),
               
               br(),
               br(),
               
               # Output: interactive world map
               girafeOutput("distPlot"),
               p(span("Note: Impulse responses are estimated from region-specific Structural Vector Autoregressions using Cholesky decomposition method. Source: Authors calculation.", style = "color:blue")),

               br(),
               br(),
               
               # Outputs: interactive table of estimated responses
               strong(textOutput('esttext')),
               
               tableOutput('esttable')
               
        ),
        
        
        # Sidebar layout with input and output definitions
        column(4, 
               # First input: Type of shock
               selectInput(inputId = "shock",
                           label = "Choose the shock",
                           choices = list("Global energy price" = "Global energy price", "Global agriculture price" = "Global agriculture price", "Global beverage price" = "Global beverage price",
                                          "Global food price" = "Global food price", "Global vegetable oil and meal price" = "Global vegetable oil and meal price", "Global cereal price" = "Global cereal price",
                                          "Global other food price" = "Global other food price","Global raw material price" = "Global raw material price","Global timber price" = "Global timber price",
                                          "Global other raw material price" = "Global other raw material price", "Global metal price" = "Global metal price")),
   
               # Second input (choices depend on the choice for the first input)
               uiOutput("secondSelection"),
               
               # Third input (choices depend on the choice for the first and second input)
               uiOutput("thirdSelection"),
               
               # Fourth input (choices depend on the choice for the first, second and third input)
               uiOutput("fourthSelection"),
               
               br(),
               br(),
               br(),
               br(),
               
               # Outputs: Table of variance decomposition
               strong(textOutput('vartext')),
               
               plotOutput("varplot")
               #tableOutput('vartable')
        )
    ),
    
    # Define the server
    server = function(input, output) {
        # Create Table
        output$datatable <- renderTable({
            hisdata_wide[which(hisdata_wide$Region == input$region), ]
            })
        
        # Create the interactive world map
        output$distPlot <- renderGirafe({
            ggiraph(code = print(VNMMaps(df, VNM_data, input$shock, input$variable, input$data_type, input$period)))
        })
        
        # Change the choices for the second selection on the basis of the input to the first selection
        output$secondSelection <- renderUI({
            radioButtons("variable", "Choose the variable",
                         c("Inflation" = "Inflation",
                           "Unemployment" = "Unemployment"))
            
            #choice_second <- as.list(unique(df$Variable[which(df$Shock == input$shock)]))
            #selectInput(inputId = "variable", choices = choice_second,
                        #label = "Choose the variable")
        })
        
        # Change the choices for the third selection on the basis of the input to the first and second selections
        output$thirdSelection <- renderUI({
            radioButtons("data_type", "Choose the type of response",
                         c("Impulse responses" = "Impulse responses",
                           "Cumulative impulse responses" = "Cumulative impulse responses"))
            
            #choice_third <- as.list(unique(df$DataType[which(df$Shock == input$shock & df$Variable == input$variable)]))
            #selectInput(inputId = "data_type", choices = choice_third,
                        #label = "Choose the type of response")
        })
        
        # Change the choices for the fourth selection on the basis of the input to the first,  second, and third selections
        output$fourthSelection <- renderUI({
            sliderInput("period", "Choose the period following the shock",
                        min = 1, max = 21, value = 1)
            
            #choice_fourth <- as.list(unique(df$Period[which(df$Shock == input$shock & df$Variable == input$variable & df$DataType == input$data_type)]))
           # selectInput(inputId = "period", choices = choice_fourth,
                        #label = "Choose the period following the shock")
        })
        
        # Create Table of Variance decomposition
        output$esttext <- renderText({paste0("Table 2. ",input$data_type, " of ", input$variable, " to ", input$shock, " shock")
        })
        
        # Create Table of Responses
        output$esttable <- renderTable({
            df[which(df$Shock == input$shock & df$Variable == input$variable & df$DataType == input$data_type & df$Period == input$period), c(1,6)]
        })
        
        # Create Table of Variance decomposition
        output$vartext <- renderText({paste0("Figure 2. 5-year cumulative variance of ", input$variable, " shared by ", input$shock, " shock")
        })
         
        #Create Output as plotvar
        #plotdata <- reactive({
            #test <- vardata[which(vardata$Shock == input$shock & vardata$Variable == input$variable),]
        #})
            
        output$varplot <- renderPlot({
            p <- ggplot(vardata[which(vardata$Shock == input$shock & vardata$Variable == input$variable),], aes(x = Region, y = Value)) +
                geom_bar(stat = "identity", fill = "blue") +
                geom_text(aes(label=round(Value,2)), vjust = -0.3) +
                theme_minimal() +
                theme(axis.title.x=element_blank(),
                    axis.text.x = element_text(size = 10, angle = 45)) +
                labs(y = "%")
            print(p)
        
        #output$vartable <- renderTable({
            #vardata[which(vardata$Shock == input$shock & vardata$Variable == input$variable), c(1,6)]
       # })
    })
    
    options = list(height = 1000)
    }    
)
#```

#Finally, we can run our app by either clicking "Run App" in the top of our RStudio IDE, or by running
#```{r, eval = FALSE}
#shinyApp(ui = ui, server = server)
#```

#Now try selecting different inputs and see how the input choices change when doing so. Also, don't forget to try hovering over the world map to see different data values for different countries interactively!