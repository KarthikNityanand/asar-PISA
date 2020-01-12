# UI
common = fluidRow(
  column(
    width = 12,
    column(width = 1),
    valueBoxOutput('over_n_country', width = 2),
    valueBoxOutput('over_region_study', width = 2),
    valueBoxOutput('over_region_score', width = 2),
    valueBoxOutput('over_oecd_study', width = 2),
    valueBoxOutput('over_oecd_score', width = 2),
    column(width = 1)
  )
)

p1 = fluidRow(# Overview of Time Spent Studying and Score
  common,
  fluidRow(
    column(
      width = 12,
      box(
        title = 'Settings',
        status = 'primary',
        width = 2,
        solidHeader = T,
        radioButtons(
          inputId = 'in_rb_result_main',
          label = 'Select',
          choices = c('Study Time', 'Score'),
          selected = 'Study Time'
        ),
        hr(),
        radioButtons(
          inputId = 'in_rb_region_main',
          label = 'Region',
          choices = c(
            'APAC',
            'EMER',
            'AMERICA'
          )
        )
      ),
      box(
        title = 'Country View',
        status = 'primary',
        width = 5,
        solidHeader = T,
        leafletOutput('plot_map')
      ),
      box(
        title = 'Top 10 Countries',
        status = 'primary',
        width = 5,
        solidHeader = T,
        plotOutput('plot_bc_top_cnt')
      )
    )
  )
)

p2 = fluidRow(# Time Spent Studying vs Score
  fluidRow(
    column(
      width = 12,
      box(
        title = 'Settings',
        status = 'primary',
        width = 2,
        solidHeader = T,
        radioButtons(
          inputId = 'in_rb_result_ts',
          label = 'Study Time',
          choices = c('Total', 'Outside School'),
          selected = 'Total'
        )
# selectInput(
#   inputId = 'in_dd_country_sc',
#   label = 'Select Country',
#   choices = NULL
# )
      ),
      box(
        title = 'Does spending more time studying results in better scores?',
        status = 'primary',
        width = 10,
        solidHeader = T,
# h2('Does spending more time studying results in better scores?'),
        plotOutput('plot_sc_score_stime')
      )
    )
  )
)

p3 = fluidRow(# Compare Gender
  fluidRow(
    column(
      width = 12,
      column(width = 2),
      valueBoxOutput('over_m_sg', width = 2),
      valueBoxOutput('over_m_all', width = 2),
      valueBoxOutput('over_f_sg', width = 2),
      valueBoxOutput('over_f_all', width = 2),
      column(width = 2)
    )
  ),
  fluidRow(
    column(
      width = 12,
      box(
        title = 'Settings',
        status = 'primary',
        width = 2,
        solidHeader = T,
        radioButtons(
          inputId = 'in_rb_sg_gen',
          label = 'Select',
          choices = c('Study Time', 'Score')
        )
      ),
      box(
        title = 'How do Males compare to Females...',
        status = 'primary',
        width = 10,
        solidHeader = T,
        plotOutput('plot_bp_gen')
      )
    )
  )
)

p4 = fluidRow(# Time Spent Studying vs Score - Boxplot
  fluidRow(
    column(
      width = 12,
      box(
        title = 'Settings',
        status = 'primary',
        width = 2,
        solidHeader = T,
        radioButtons(
          inputId = 'in_rb_sg_factor',
          label = 'Select',
          choices = c('Study Time', 'Score')
        ),
        selectInput(
          inputId = 'in_dd_stu_factor',
          label = 'Select Comparison Factors',
          choices = NULL
        )
      ),
      box(
        title = textOutput('txt_factor_graph'),
        status = 'primary',
        width = 10,
        solidHeader = T,
        plotOutput('plot_bp_material')
      )
    )
  )
)

p5 = fluidRow(# Predict Score by Material Factors
  column(
    width = 12,
    box(
      title = 'Settings',
      status = 'primary',
      width = 2,
      solidHeader = T,
      radioButtons(
        inputId = 'in_rb_stu_factor1',
        label = 'Gender',
        inline = T,
        choices = c('Male', 'Female')
      ),
      checkboxInput(
        inputId = 'in_cb_stu_factor2',
        label = 'Repeated Grade',
        value = F
      ),
      checkboxInput(
        inputId = 'in_cb_stu_factor3',
        label = 'Native Parents',
        value = T
      ),
      checkboxInput(
        inputId = 'in_cb_stu_factor4',
        label = 'Owns Computer',
        value = T
      ),
      numericInput(
        inputId = 'in_tb_stu_factor5',
        label = 'Number of Cars',
        value = 0,
        min = 0,
        max = 5
      ),
      numericInput(
        inputId = 'in_tb_stu_factor6',
        label = 'Number of Books',
        value = '11',
        min = 0
      ),
      selectInput(
        inputId = 'in_sc_stu_factor7',
        label = 'Parents care for me',
        choices = opt_ag_scale
      ),
      selectInput(
        inputId = 'in_sc_stu_factor8',
        label = 'I am ambitious',
        choices = opt_ag_scale
      ),
      selectInput(
        inputId = 'in_sc_stu_factor9',
        label = 'I worry that a test would be difficult',
        choices = opt_ag_scale
      ),
      selectInput(
        inputId = 'in_sc_stu_factor10',
        label = 'I feel anxious even if I am prepared',
        choices = opt_ag_scale
      )
    ),
    box(
      title = 'Final Predicted Score',
      status = 'primary',
      width = 10,
      solidHeader = T,
      span(
        strong(textOutput('txt_final_predict_result')),
        style = 'font-size: 200px',
        align = 'center'
      )
    )
  )
)

header = dashboardHeader(
  title = textOutput('title')
# dropdownMenu(
#   type = 'messages',
#   messageItem(
#     from = 'G3 T2',
#     message = 'Hello!',
#     time = '11:30'
#   )
# )
)

sidebar = dashboardSidebar(#change to blue
  sidebarMenu(
    menuItem('Global', startExpanded = T,
      menuSubItem('Overview', tabName = 'index', icon = icon('dashboard')),
      menuSubItem('Time vs Score', tabName = 'time-score', icon = icon('line-chart'))
    ),
    menuItem('Singapore', startExpanded = T,
      menuSubItem('Overview', tabName = 'singapore', icon = icon('dashboard')),
      menuSubItem('Analysis', tabName = 'analysis', icon = icon('globe')),
      menuSubItem('Prediction', tabName = 'prediction', icon = icon('line-chart'))
    ),
    menuItem('About', startExpanded = T,
      menuSubItem('About', tabName = 'about', icon = icon('info'))
    )
  )
)

body = dashboardBody(
  tabItems(
    tabItem(tabName = 'index', p1),
    tabItem(tabName = 'time-score', p2),
    tabItem(tabName = 'singapore', p3),
    tabItem(tabName = 'analysis', p4),
    tabItem(tabName = 'prediction', p5),
    tabItem(tabName = 'about', includeMarkdown('about.md'))
  )
)

ui = dashboardPage(
  skin = 'red',
  header,
  sidebar,
  body
)