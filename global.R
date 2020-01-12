# PACKAGES

packages = c(
  'shiny',
  'shinydashboard',
  'ggplot2',
  'ggrepel',
  'dygraphs',
  'dplyr',
  'lsr',
  'leaflet.extras',
  'ggrepel',
  'maps'
)

for (p in packages) {
  if (!require(p, character.only = T))
    install.packages(p, dependencies = T)
  library(p, character.only = T)
}

# Data Load
data_dir = 'data/'

pisa_location = paste(data_dir, 'sgdpisa_c.csv', sep = '')
# region_location = paste(data_dir, 'region_code.csv', sep = '')
compare_file = paste(data_dir, 'comparison.csv', sep = '')
pisa = read.csv(pisa_location, fileEncoding = 'UTF-8-BOM', header = T, stringsAsFactors = F)
# region = read.csv(region_location, fileEncoding = 'UTF-8-BOM', header = T, stringsAsFactors = F)
# region = region[1:56, 1:3]
compare = read.csv(compare_file, fileEncoding = 'UTF-8-BOM', header = T, stringsAsFactors = F)

# Data Cleaning
pisa = na_if(pisa, "No Response")
pisa = na_if(pisa, "")
pisa = na_if(pisa, "Invalid")
pisa = na_if(pisa, "Not Applicable")
pisa$TOT_OSCH_STUDYTIME = as.numeric(as.character(pisa$TOT_OSCH_STUDYTIME))
pisa$TOT_SCH_PRD_WK = as.numeric(as.character(pisa$TOT_SCH_PRD_WK))
pisa$MINS_CLASS_PRD = as.numeric(as.character(pisa$MINS_CLASS_PRD))
pisa$Age = as.numeric(as.character(pisa$Age))
pisa$CNT[pisa$CNT == 'Spain (Regions)'] = 'Spain'
pisa$CNT[pisa$CNT == 'Massachusettes (USA)'] = 'United States'
pisa$CNT[pisa$CNT == 'North Carolina (USA)'] = 'United States'

# pisa_r = merge(x = pisa, y = region, by = "CNT", all.x = T)
# s_pisa = subset(pisa_r, CNT %in% get_countries)

compare = compare %>% filter(Country != 'OECD average')
compare$latitude = as.numeric(as.character(compare$latitude))
compare$longitude = as.numeric(as.character(compare$longitude))

# 
# compare_group = group_by(compare, Sub_region)
# compare_summary = summarise(
#   compare_group,
#   mean_score = mean(compare_group$PISA_Science_Score),
#   mean_time_study = mean(compare_group$Total_learn_Time),
#   no_of_countries = n()
# )
# compare_score_sort = compare_summary[order(-compare_summary$mean_score),]
# compare_time_sort = compare_summary[order(-compare_summary$mean_time_study)]

oecd_study_time = 44
oecd_score = 493

get_regions = compare %>% distinct(Sub_region)

opt_explain = c(
  'Study Time',
  'Score'
)
opt_explain_detail = c(
  'Weekly Out of School Study Time (hrs)',
  'Science Score'
)

opt_explain_d = setNames(as.list(opt_explain_detail), opt_explain)

opt_factors_vars = c(
  'TECH_BOOKS',
  'N_BOOKS',
  'PARENTS_INTEREST',
  'EXP_COMP_GRADE',
  'AFT_NET_SN',
  'MOM_EDU',
  'DAD_EDU',
  'N_BOOKS',
  'EXP_COMP_GRADE',
  'REP_GRADE'
)
opt_factors_detail = c(
  'Technical Books',
  'No. of Books',
  'Parents Interest',
  'Expected Completion Grade',
  'After School Social Network Activities',
  'Mom\'s Education Level',
  'Dad\'s Education Level',
  'No. of Books',
  'Expected Completion Grade',
  'Repeat Grade'
)

opt_factors = setNames(as.list(opt_factors_vars), opt_factors_detail)

opt_ag_scale = c('Strongly Disagree', 'Disagree', 'Agree', 'Strongly Agree')