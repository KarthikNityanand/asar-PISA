# 2015 OECD PISA - Understanding Students' Performance & Study Time
A ISSS616 Applied Statistical Analysis with R Project
AY2019-20 Term 1

## About

This is a project as part of the SMU **ISSS616 Applied Statistical Analysis with R** course, which involves the application of statistical concepts using R as the tool. Part of the requirement of this project was to examine a dataset of our choice, and to present our findings from the chosen dataset using a Shiny dashboard.

## The Topic

The aim of our project is to understand the variation in students’ study time outside of school and their standardized scores. For the purpose of this project, we focus on science scores, as science is the subject of focus for the 2015 PISA test. We seek to identify factors (e.g. student’s attitudes, demographics, socioeconomic background) affecting students’ studying time and their performance in the test. We also explore if the amount of study time outside of school is associated with indicators of students’ socio-emotional well-being. We expect that these insights can help schools and policy makers develop intervention measures to address issues associated with overly long study time outside school, particularly if it is found to indicate high stress, and short study time which could indicate disinterest in school.

Through a Shiny interactive dashboard, we explore and visualize the relationship that each variable (e.g. gender, socioeconomic background) has on the mean study time and science score as well as their impact using appropriate statistical models.

## Setup

### Using Docker

To be announced.

### Using `runGitHub` Command

To run the codes, simply run the command in any R environment that has `shiny` installed :

```bash
shiny::runGitHub('asar-PISA','KarthikNityanand')
```

### Natively

Alternatively, you may download the zip file of this project from the 'Clone or download' button on the top right of this repository. Extract to any directory of your choice and execute the `runApp()` command directly in the directory.

## Datasets

The datasets can be obtained from the [OECD PISA website](https://www.oecd.org/pisa/data/2015database/).

The dataset pertains to the 2015 cycle of the OECD PISA, which was administed to 15 to 16-year-old students around the world. The assessment tests student's learning outcomes in Reading, Math and Science.

## Acknowledgements

We would like to express our heartfelt thanks to [Aldy GUNAWAN](https://www.smu.edu.sg/faculty/profile/153976/Aldy-GUNAWAN), Assistant Professor of Information Systems at SMU for his guidance in this project.
