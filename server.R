server = function(input, output, session) {
  output$title = renderText({
    paste('Education')
  })

  # Page 1
  updateRadioButtons(
    session,
    inputId = 'in_rb_result_sc',
    label = 'Select',
    choices = opt_explain,
    selected = opt_explain[0]
  )

  reactive_region_cnt = reactive({
    compare %>%
      filter(Sub_region == input$in_rb_region_main)
  })

  reactive_region = reactive({
    reactive_region_cnt() %>%
      arrange(if (input$in_rb_result_main == 'Study Time') Total_learn_Time else PISA_Science_Score) %>%
    # arrange(PISA_Science_Score) %>%
    tail(10)
  })

  output$over_n_country = renderValueBox({
    value = paste(count(reactive_region_cnt()))

    valueBox(
      value,
      'Countries'
    )
  })
  output$over_region_study = renderValueBox({
    value = round(mean(reactive_region_cnt()$Total_learn_Time), 2)
    value = paste(value, 'h')

    valueBox(
      value,
      'Study Time',
      color = 'purple'
    )
  })
  output$over_region_score = renderValueBox({
    value = round(mean(reactive_region_cnt()$PISA_Science_Score), 2)

    valueBox(
      paste(value),
      'PISA Result',
      color = 'purple'
    )
  })
  output$over_oecd_study = renderValueBox({
    # value = round(mean(compare$Total_learn_Time), 2)
    value = oecd_study_time

    valueBox(
      paste(value, 'h'),
      'Study Time (OECD)',
      color = 'yellow'
    )
  })
  output$over_oecd_score = renderValueBox({
    # value = round(mean(compare$PISA_Science_Score), 2)
    value = oecd_score

    valueBox(
      paste(value),
      'PISA Result (OECD)',
      color = 'yellow'
    )
  })

  output$plot_map = renderLeaflet({
    is_study = input$in_rb_result_main == 'Study Time'
    compare_region = compare[!(compare$Sub_region != input$in_rb_region_main),]

    pal = colorNumeric(
      palette =
        if (is_study)
          c('light green', 'green', 'dark green')
        else
          c('light blue', 'blue', 'dark blue'),
      domain = if (is_study) compare$Total_learn_Time else compare$PISA_Science_Score
    )

    if (is_study) {
      leaflet(compare_region) %>%
        setView(lng = -15, lat = 20, zoom = 1.5) %>%
        addTiles() %>%
        addCircles(
          data = compare, lat = ~latitude, lng = ~longitude,
          weight = 1,
          radius = ~sqrt(Total_learn_Time) * 50000,
          popup = ~as.character(Total_learn_Time),
          label = ~as.character(
            paste('Country:', Country, '; Average Study Time:', Total_learn_Time)
          ),
          color = ~pal(Total_learn_Time), fillOpacity = 0.5
        )
    } else {
      leaflet(compare_region) %>%
        setView(lng = -15, lat = 20, zoom = 1.5) %>%
        addTiles() %>%
        addCircles(
          data = compare, lat = ~latitude, lng = ~longitude,
          weight = 1,
          radius = ~sqrt(PISA_Science_Score) * 10000,
          popup = ~as.character(PISA_Science_Score),
          label = ~as.character(
            paste('Country:', Country, '; Average Score:', PISA_Science_Score)
          ),
          color = ~pal(PISA_Science_Score), fillOpacity = 0.5
        )
    }
  })

  output$plot_bc_top_cnt = renderPlot({
    base_settings =
      theme_bw() +
      theme(legend.position = "none") +
      theme(plot.title = element_text(hjust = 0.5))

    if (input$in_rb_result_main == 'Study Time') {
      ggplot(
        reactive_region(),
        aes(
          x = reorder(Country, Total_learn_Time),
          y = Total_learn_Time,
          fill = Total_learn_Time,
          label = Total_learn_Time
        )
      ) +
        geom_text(nudge_y = 2) +
        scale_fill_gradient(low = "green", high = "dark green") +
        geom_hline(yintercept = oecd_study_time, colour = "#BB0000", size = 2) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        labs(
          title = 'Top 10 Countries by Time Spent Studying',
          x = 'Country',
          y = 'Time Spent Studying (hrs)'
        ) +
        base_settings
    } else {
      ggplot(
        reactive_region(),
        aes(
          x = reorder(Country, PISA_Science_Score),
          y = PISA_Science_Score,
          fill = PISA_Science_Score,
          label = PISA_Science_Score
        )
      ) +
        geom_text(nudge_y = 18) +
        scale_fill_gradient(low = "blue", high = "dark blue") +
        geom_hline(yintercept = oecd_score, colour = "#BB0000", size = 2) +
        geom_bar(stat = 'identity') +
        coord_flip() +
        labs(
          title = 'Top 10 Countries by PISA Science Score',
          x = 'Country',
          y = 'PISA Science Score'
        ) +
        base_settings
    }

  })

  # Page 2
  output$plot_sc_score_stime = renderPlot({
    is_total = input$in_rb_result_ts == 'Total'

    ggplot(
      compare,
      aes(
        x = if (is_total) Total_learn_Time else TOT_OSCH_STUDYTIME,
        y = PISA_Science_Score
      )
    ) +
      geom_point(shape = 23, fill = "blue", color = "darkred", size = 3) +
      geom_hline(
        yintercept = oecd_score,
        colour = "#BB0000",
        size = 2
      ) +
      geom_vline(
        xintercept = if (is_total) oecd_study_time else 17.21,
        colour = "#BB0000",
        size = 2
      ) +
      geom_label_repel(
        aes(label = Country),
        box.padding = 0.35,
        point.padding = 0.5,
        segment.color = 'grey50'
      ) +
      xlab(paste('Total', if (is_total) 'Learning' else 'Outside of School Study', 'Time Per Week (Hours)')) +
      ylab('PISA Science Score') +
      theme_classic() +
      scale_x_reverse()
  })

  # Page 3 / 4
  dat_summary = reactive({

  })

  output$over_m_sg = renderValueBox({
    target = input$in_rb_sg_gen
    data = pisa %>%
      filter(GENDER == 'Male')
    data = if (target == opt_explain[1]) data$TOT_OSCH_STUDYTIME else data$PV2_SCI
    value = paste(round(mean(data), 2), if (target == opt_explain[1]) 'h')

    valueBox(
      value,
      paste('Singapore Male', input$in_rb_sg_gen)
    # color = 'blue'
    )
  })

  output$over_m_all = renderValueBox({
    # target = input$in_rb_sg_gen
    # data = compare %>% 
    #   filter(GENDER == 'Male')
    # data = if (target == opt_explain[1]) data$TOT_OSCH_STUDYTIME else data$PV2_SCI
    # value = paste(round(mean(data),2), if(target == opt_explain[1]) 'h')
    value = paste('-')

    valueBox(
      value,
      paste('OECD Male', input$in_rb_sg_gen)
    # color = 'blue'
    )
  })

  output$over_f_sg = renderValueBox({
    target = input$in_rb_sg_gen
    data = pisa %>%
      filter(GENDER == 'Female')
    data = if (target == opt_explain[1]) data$TOT_OSCH_STUDYTIME else data$PV2_SCI
    value = paste(round(mean(data), 2), if (target == opt_explain[1]) 'h')

    valueBox(
      value,
      paste('Female', input$in_rb_sg_gen),
      color = 'orange'
    )
  })

  output$over_f_all = renderValueBox({
    value = paste('-')

    valueBox(
      value,
      paste('OECD Female', input$in_rb_sg_gen),
      color = 'orange'
    )
  })

  output$plot_bp_gen = renderPlot({
    is_study_time = input$in_rb_sg_gen == 'Study Time'

    means =
      if (is_study_time)
      aggregate(TOT_OSCH_STUDYTIME ~ GENDER, pisa, mean)
    else
      aggregate(PV2_SCI ~ GENDER, pisa, mean)
    ggplot(pisa,
      if (is_study_time)
        aes(GENDER, TOT_OSCH_STUDYTIME)
      else
        aes(GENDER, PV2_SCI)
      ) +
      geom_boxplot(aes(fill = GENDER)) +
      geom_text(
        data = means,
        if (is_study_time)
          aes(label = round(TOT_OSCH_STUDYTIME, 2), y = TOT_OSCH_STUDYTIME)
        else
          aes(label = round(PV2_SCI, 2), y = PV2_SCI)
        ,
        size = 3.5
      ) +
      labs(
        x = 'Gender'
    # y = if (is_study_time) 'Study Time' else 'Science Score'
      )
  })

  # Page 4
  out_dd_select_factors = reactive({
    if (input$in_rb_sg_factor == opt_explain[1]) head(opt_factors, 5) else tail(opt_factors, 5)
  })

  observe({
    updateSelectInput(
      session,
      inputId = 'in_dd_stu_factor',
      label = 'Select Comparison',
      choices = out_dd_select_factors()
    )
  })

  output$txt_factor_graph = renderText({
    x_label = input$in_dd_stu_factor
    y_label = input$in_rb_sg_factor

    paste(y_label, 'by', x_label)
  })

  output$plot_bp_material = renderPlot({
    is_study = input$in_rb_sg_factor == opt_explain[1]
    dep_var = if (is_study) 'TOT_OSCH_STUDYTIME' else 'PV2_SCI'
    x_label = input$in_dd_stu_factor
    y_label = input$in_rb_sg_factor

    means = aggregate(as.formula(paste(dep_var, '~', input$in_dd_stu_factor)), pisa, mean)
    plot = ggplot(pisa, aes_string(input$in_dd_stu_factor, dep_var))
    plot_bp = geom_boxplot(aes_string(fill = input$in_dd_stu_factor))
    plot_text = geom_text(
      data = means,
      aes_string(
        label = dep_var,
    # label = round(dep_var, 2),
    # y = dep_var + if(is_study) 5 else 30
      ),
      size = 3.5
    )
    st_summary = stat_summary(
      fun.y = mean, colour = 'darkred',
      geom = 'point',
      shape = 18, size = 3,
      show.legend = F)

    plot +
      plot_bp +
      plot_text +
      st_summary +
      labs(
        x = x_label,
        y = y_label
      )
  })

  # Page 5
  updateCheckboxGroupInput(
    session,
    inputId = 'in_cb_stu_factor',
    label = 'Select Factors',
    choices = opt_factors_detail
  )

  reactive_aggregate_score = reactive({
    gender = input$in_rb_stu_factor1
    retain = input$in_cb_stu_factor2
    parent = input$in_cb_stu_factor3
    computer = input$in_cb_stu_factor4
    car = input$in_tb_stu_factor5
    book = input$in_tb_stu_factor6
    care = input$in_sc_stu_factor7
    ambition = input$in_sc_stu_factor8
    worry = input$in_sc_stu_factor9
    anxious = input$in_sc_stu_factor10

    scale = opt_ag_scale

    score = 375 + if (gender == 'Male') 26 else 0
    score = score + if (retain) 60 else 0
    score = score + if (parent) 12 else 0
    score = score + if (computer) 26 else 0
    score = score + if (car == 1) 8 else if (car > 1) 12 else 0
    score = score + if (book > 500) 62
    else if (book > 200) 64
    else if (book > 100) 48
    else if (book > 25) 39
    else if (book > 10) 26
    else 0
    score = score + if (care == scale[4]) 9 else if (care == scale[2]) - 13 else 0
    score = score + if (ambition == scale[2]) - 14 else if (ambition == scale[1]) - 29 else 0
    score = score + if (worry == scale[4]) 9 else if (worry == scale[2]) - 13 else 0
    score = score + if (anxious == scale[1]) 16 else if (anxious == scale[3]) 8 else 0
    score
  })

  output$txt_final_predict_result = renderText({
    predicted = reactive_aggregate_score() / 585 * 100
    paste(round(predicted, 2), '%', sep = '')
  })
}