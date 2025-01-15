df <- read_csv('clustering_raw_data.csv')
vars <- setdiff(names(df),'ElectDist')

pageWithSidebar(
  headerPanel('Distict k-means clustering'),
  sidebarPanel(
    selectInput('xcol', 'X Variable', vars),
    selectInput('ycol', 'Y Variable', vars, selected = vars[[2]]),
    numericInput('clusters', 'Cluster count', 3, min = 1, max = 9)
  ),
  mainPanel(
    plotOutput('plot1')
  )
)