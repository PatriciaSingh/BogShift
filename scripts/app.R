# Climate Research Dashboard
# A 3-year project dashboard for climate and ecological research

# Load required libraries
library(shiny)
library(shinythemes)

# Define UI
ui <-   fluidPage(
  tags$head(
    tags$style(HTML("
      @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap');
      
      * {
        font-family: 'Poppins', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
      }
      
      body {
        background: linear-gradient(135deg, #e8f5e8 0%, #f0fdf4 50%, #ecfdf5 100%);
        font-family: 'Poppins', sans-serif;
        font-weight: 400;
        line-height: 1.7;
      }
      
      .navbar-nav > li > a {
        padding: 12px 24px;
        border-radius: 50px !important;
        margin: 8px 6px;
        transition: all 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
        font-weight: 500;
        font-size: 14px;
        letter-spacing: 0.5px;
        color: #1f2937 !important;
        background: rgba(255,255,255,0.9);
        border: 1px solid rgba(45, 80, 22, 0.2);
      }
      
      .navbar-brand {
        font-size: 28px;
        font-weight: 700;
        letter-spacing: 2px;
        color: #1f2937 !important;
        text-shadow: none;
      }
      
      .well {
        background: rgba(255, 255, 255, 0.85);
        border: none;
        border-radius: 24px;
        box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
        backdrop-filter: blur(15px);
        border: 1px solid rgba(0, 0, 0, 0.05);
        padding: 35px;
        margin: 25px 0;
        transition: all 0.3s ease;
      }
      
      .well:hover {
        transform: translateY(-2px);
        box-shadow: 0 25px 50px rgba(0, 0, 0, 0.12);
      }
      
      h3 {
        color: #2d5016;
        font-weight: 600;
        margin-bottom: 24px;
        font-size: 32px;
        letter-spacing: -0.5px;
      }
      
      h4 {
        color: #4a7c59;
        font-weight: 500;
        margin-bottom: 18px;
        font-size: 22px;
        letter-spacing: -0.2px;
      }
      
      strong {
        color: #2d5016;
        font-weight: 600;
      }
      
      p {
        line-height: 1.8;
        color: #374151;
        margin-bottom: 18px;
        font-size: 16px;
        font-weight: 400;
      }
      
      .navbar-default {
        background: linear-gradient(135deg, #2d5016 0%, #4a7c59 50%, #8fbc8f 100%);
        border: none;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
        padding: 15px 0;
        backdrop-filter: blur(10px);
      }
      
      .navbar-default .navbar-brand {
        color: #1f2937 !important;
        text-shadow: none;
      }
      
      .navbar-default .navbar-nav > li > a:hover {
        background: rgba(255,255,255,1) !important;
        transform: translateY(-3px) scale(1.05);
        box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        color: #1f2937 !important;
        border: 1px solid rgba(45, 80, 22, 0.3);
      }
      
      .navbar-default .navbar-nav > .active > a {
        background: rgba(255,255,255,1) !important;
        color: #1f2937 !important;
        box-shadow: 0 4px 20px rgba(0,0,0,0.15);
        border: 1px solid rgba(45, 80, 22, 0.3);
        font-weight: 600;
      }
      
      .container-fluid {
        padding: 0 40px;
        max-width: 1400px;
        margin: 0 auto;
      }
      
      .navbar {
        border-radius: 0 0 20px 20px;
        margin-bottom: 30px;
      }
      
      html {
        scroll-behavior: smooth;
      }
    "))
  ),
),4f6 50%, #e5e7eb 100%);
}

body {
  font-family: 'Poppins', sans-serif;
  font-weight: 400;
  line-height: 1.7;
}
.well {
  background: rgba(255, 255, 255, 0.85);
  border: none;
  border-radius: 24px;
  box-shadow: 0 20px 40px rgba(0, 0, 0, 0.08);
  backdrop-filter: blur(15px);
  border: 1px solid rgba(0, 0, 0, 0.05);
  padding: 35px;
  margin: 25px 0;
  transition: all 0.3s ease;
}
.well:hover {
  transform: translateY(-2px);
  box-shadow: 0 25px 50px rgba(0, 0, 0, 0.12);
}

/* Theme 1: Forest Green */
  body.theme-1 h3 { color: #2d5016; }
      body.theme-1 h4 { color: #4a7c59; }
          body.theme-1 strong { color: #2d5016; }
              body.theme-1 .navbar-default {
                background: linear-gradient(135deg, #2d5016 0%, #4a7c59 50%, #8fbc8f 100%);
              }
            
            /* Theme 2: Ocean Blue */
              body.theme-2 h3 { color: #0f766e; }
                  body.theme-2 h4 { color: #0891b2; }
                      body.theme-2 strong { color: #0f766e; }
                          body.theme-2 .navbar-default {
                            background: linear-gradient(135deg, #0f766e 0%, #0891b2 50%, #06b6d4 100%);
                          }
                        
                        /* Theme 3: Purple */
                          body.theme-3 h3 { color: #7c3aed; }
                              body.theme-3 h4 { color: #8b5cf6; }
                                  body.theme-3 strong { color: #7c3aed; }
                                      body.theme-3 .navbar-default {
                                        background: linear-gradient(135deg, #7c3aed 0%, #8b5cf6 50%, #a78bfa 100%);
                                      }
                                    
                                    /* Theme 4: Warm Orange */
                                      body.theme-4 h3 { color: #ea580c; }
                                          body.theme-4 h4 { color: #f97316; }
                                              body.theme-4 strong { color: #ea580c; }
                                                  body.theme-4 .navbar-default {
                                                    background: linear-gradient(135deg, #ea580c 0%, #f97316 50%, #fb923c 100%);
                                                  }
                                                
                                                /* Theme 5: Cool Gray */
                                                  body.theme-5 h3 { color: #374151; }
                                                      body.theme-5 h4 { color: #4b5563; }
                                                          body.theme-5 strong { color: #374151; }
                                                              body.theme-5 .navbar-default {
                                                                background: linear-gradient(135deg, #374151 0%, #4b5563 50%, #6b7280 100%);
                                                              }
                                                            
                                                            h3 {
                                                              font-weight: 600;
                                                              margin-bottom: 24px;
                                                              font-size: 32px;
                                                              letter-spacing: -0.5px;
                                                            }
                                                            h4 {
                                                              font-weight: 500;
                                                              margin-bottom: 18px;
                                                              font-size: 22px;
                                                              letter-spacing: -0.2px;
                                                            }
                                                            p {
                                                              line-height: 1.8;
                                                              color: #374151;
                                                                margin-bottom: 18px;
                                                              font-size: 16px;
                                                              font-weight: 400;
                                                            }
                                                            .navbar-default {
                                                              border: none;
                                                              box-shadow: 0 8px 32px rgba(0, 0, 0, 0.15);
                                                              padding: 15px 0;
                                                              backdrop-filter: blur(10px);
                                                            }
                                                            .navbar-default .navbar-brand {
                                                              color: white !important;
                                                              text-shadow: 2px 2px 12px rgba(0,0,0,0.3);
                                                            }
                                                            .navbar-default .navbar-nav > li > a {
                                                              color: rgba(255,255,255,0.95) !important;
                                                              background: rgba(255,255,255,0.15);
                                                              border: 1px solid rgba(255,255,255,0.2);
                                                              backdrop-filter: blur(10px);
                                                            }
                                                            .navbar-default .navbar-nav > li > a:hover {
                                                              background: rgba(255,255,255,0.25) !important;
                                                              transform: translateY(-3px) scale(1.05);
                                                              box-shadow: 0 8px 25px rgba(0,0,0,0.15);
                                                              color: white !important;
                                                              border: 1px solid rgba(255,255,255,0.4);
                                                            }
                                                            .navbar-default .navbar-nav > .active > a {
                                                              background: rgba(255,255,255,0.3) !important;
                                                              color: white !important;
                                                              box-shadow: 0 4px 20px rgba(0,0,0,0.15);
                                                              border: 1px solid rgba(255,255,255,0.4);
                                                            }
                                                            .container-fluid {
                                                              padding: 0 40px;
                                                              max-width: 1400px;
                                                              margin: 0 auto;
                                                            }
                                                            .navbar {
                                                              border-radius: 0 0 20px 20px;
                                                              margin-bottom: 30px;
                                                            }
                                                            
                                                            html {
                                                              scroll-behavior: smooth;
                                                            }
                                                            "))
  ),
  
  navbarPage(
    title = "BogShift",
    id = "navbar",
    theme = shinytheme("cosmo"),
    
    tabPanel("Project Overview", value = "overview"),
    tabPanel("WP1: Building Dataset", value = "wp1_dataset"), 
    tabPanel("WP2: Historical vs Current Climate", value = "wp2_climate"),
    tabPanel("WP3: Niche Truncation", value = "wp3_niche"),
    tabPanel("WP4: Final Maps & Results", value = "wp4_maps")
  ),
  
  
  # Conditional panels based on navbar selection
  conditionalPanel(
    condition = "input.navbar == 'overview'",
    fluidRow(
      column(12,
        wellPanel(
          h3("Project Overview"),
          h4("Abstract & Aims"),
          p("Climate change and human-induced landscape alterations are causing significant ecosystem shifts, challenging biodiversity conservation. Ombrotrophic peatlands, crucial for carbon storage, face degradation threats. Restoring them is vital for carbon neutrality and biodiversity. Limited resources hinder conservation, requiring optimal area identification."),
          
          p("This project employs ecological niche modelling (ENM) to predict future bog distribution shifts under climate change scenarios in holarctic regions. Enhancing ENM assumptions aims to improve accuracy. Outcomes, presented through a web application, will guide bog conservation efforts."),
          
          p("The project comprises four work packages: evaluating the historical climate's impact on bog distribution, assessing bog niches, studying climate change effects on bog habitat types, and developing a web application for model implementation and decision-making. The project provides valuable tools for practitioners in nature conservation and restoration."),
          
          h4("Project Goals"),
          p(strong("Refining future projections of ombrotrophic peatlands' habitat loss and range shifts by challenging conventional ecological niche modelling assumptions. The resulting optimal areas implemented in the web application will guide peatland protection and restoration efforts."))
        )
      )
    )
  ),
  
  conditionalPanel(
    condition = "input.navbar == 'wp1_dataset'",
    fluidRow(
      column(12,
        wellPanel(
          h3("WP1: Building Dataset"),
          p("Content for data collection and dataset building will go here.")
        )
      )
    )
  ),
  
  conditionalPanel(
    condition = "input.navbar == 'wp2_climate'",
    fluidRow(
      column(12,
        wellPanel(
          h3("WP2: Historical vs Current Climate"),
          p("Content for climate analysis will go here.")
        )
      )
    )
  ),
  
  conditionalPanel(
    condition = "input.navbar == 'wp3_niche'",
    fluidRow(
      column(12,
        wellPanel(
          h3("WP3: Niche Truncation"),
          p("Content for niche truncation analysis will go here.")
        )
      )
    )
  ),
  
  conditionalPanel(
    condition = "input.navbar == 'wp4_maps'",
    fluidRow(
      column(12,
        wellPanel(
          h3("WP4: Final Maps & Results"),
          p("Content for final results and maps will go here.")
        )
      )
    )
  )
)

# Define Server
server <- function(input, output, session) {
  # Server logic can be added here as needed
}

# Run the application
shinyApp(ui = ui, server = server)