

knitr::opts_chunk$set(
  echo = FALSE,
  fig.height = 8,
  fig.width = 10,
  warning = FALSE
)
#include packages
library(tidyverse)
library(haven)
library(kableExtra)
library(skimr)
library(flextable)
library(ggridges)
library(scales)
library(ggtext)
library(estimatr)
library(srvyr)
#library(spatstat)
library(Hmisc)
library(ggpmisc)
library(ggalt)
library(here)
library(patchwork)
library(DT)
#remotes::install_github("ricardo-bion/ggradar")
library(ggradar)


#Country name and year of survey
country_name <-'Chad'
country <- "TCD"
year <- '2023'
api_user <- "GEPD_api_TCD"
teach=TRUE

########


# define stle for ggplot based on BBC plotting styles
bbc_style <- function() {
  font <- "Helvetica"
  
  ggplot2::theme(
    
    #Text format:
    #This sets the font, size, type and colour of text for the chart's title
    plot.title = ggplot2::element_text(family=font,
                                       size=28,
                                       face="bold",
                                       color="#222222"),
    #This sets the font, size, type and colour of text for the chart's subtitle, as well as setting a margin between the title and the subtitle
    plot.subtitle = ggplot2::element_text(family=font,
                                          size=22,
                                          margin=ggplot2::margin(9,0,9,0)),
    plot.caption = ggplot2::element_blank(),
    #This leaves the caption text element empty, because it is set elsewhere in the finalise plot function
    
    #Legend format
    #This sets the position and alignment of the legend, removes a title and backround for it and sets the requirements for any text within the legend. The legend may often need some more manual tweaking when it comes to its exact position based on the plot coordinates.
    legend.position = "top",
    legend.text.align = 0,
    legend.background = ggplot2::element_blank(),
    legend.title = ggplot2::element_blank(),
    legend.key = ggplot2::element_blank(),
    legend.text = ggplot2::element_text(family=font,
                                        size=18,
                                        color="#222222"),
    
    #Axis format
    #This sets the text font, size and colour for the axis test, as well as setting the margins and removes lines and ticks. In some cases, axis lines and axis ticks are things we would want to have in the chart - the cookbook shows examples of how to do so.
    axis.title = ggplot2::element_blank(),
    axis.text = ggplot2::element_text(family=font,
                                      size=18,
                                      color="#222222"),
    axis.text.x = ggplot2::element_text(margin=ggplot2::margin(5, b = 10)),
    axis.ticks = ggplot2::element_blank(),
    axis.line = ggplot2::element_blank(),
    
    #Grid lines
    #This removes all minor gridlines and adds major y gridlines. In many cases you will want to change this to remove y gridlines and add x gridlines. The cookbook shows you examples for doing so
    panel.grid.minor = ggplot2::element_blank(),
    panel.grid.major.y = ggplot2::element_line(color="#cbcbcb"),
    panel.grid.major.x = ggplot2::element_blank(),
    
    #Blank background
    #This sets the panel background as blank, removing the standard grey ggplot background colour from the plot
    panel.background = ggplot2::element_blank(),
    
    #Strip background (#This sets the panel background for facet-wrapped plots to white, removing the standard grey ggplot background colour and sets the title size of the facet-wrap title to font size 22)
    strip.background = ggplot2::element_rect(fill="white"),
    strip.text = ggplot2::element_text(size  = 22,  hjust = 0)
  )
}


#############################
# Create database with just learning outcomes for regressions
##############################

df_reg<- read.csv("C:/Users/wb589124/Downloads/data.csv")



#add equations to plots
eq_plot_txt <- function(data, inp, var) {
  eq <- lm_robust(inp ~ var, data=data, se_type='HC2')
  coef <- round(coef(eq),2)
  std_err <- round(sqrt(diag(vcov(eq))),2)
  r_2<- round(summary(eq)$r.squared,2)
  sprintf(" y = %.2f + %.2f x, R<sup>2</sup> = %.2f <br> (%.2f) <span style='color:white'> %s</span> (%.2f) ", coef[1], coef[2], r_2[1], std_err[1],"s", std_err[2])
  
}


regplots<- ggplot(data=df_reg, aes(x=ecd_student_knowledge, y=student_knowledge, weight=school_weight, color="#0081a8")) +
  geom_point() +
  geom_smooth(method='lm') +
  scale_color_manual(labels = c( "Principal Indicator "),  values= c( "#0081a8")) +
  theme_bw() +
  theme(
    text = element_text(size = 14),
    legend.position='none'
  ) +
  expand_limits(x = 0, y = 0) +
  labs(colour = "Indicator") +
  ylab(paste0("4th Grade Score")) +
  xlab(paste0("1st Grade Score")) +
  geom_richtext(
    aes(x=10,y=10,label = eq_plot_txt(df_reg, student_knowledge, ecd_student_knowledge), hjust=0.2)
  ) +
  plot_annotation(title = str_wrap("Scatterplot of School Average 4th Grade Student Scores against 1st Grade Student Scores",90))
regplots

summary(lm(student_knowledge~ecd_student_knowledge, data=df_reg))



###################################################
  
  
  regplots<- ggplot(data=df_reg, aes(x=ecd2_student_knowledge, y=student_knowledge, weight=school_weight, color="#0081a8")) +
  geom_point() +
  geom_smooth(method='lm') +
  scale_color_manual(labels = c( "Principal Indicator "),  values= c( "#0081a8")) +
  theme_bw() +
  theme(
    text = element_text(size = 14),
    legend.position='none'
  ) +
  expand_limits(x = 0, y = 0) +
  labs(colour = "Indicator") +
  ylab(paste0("4th Grade Score")) +
  xlab(paste0("2nd Grade Score")) +
  geom_richtext(
    aes(x=10,y=10,label = eq_plot_txt(df_reg, student_knowledge, ecd2_student_knowledge), hjust=0.2)
  )  +
  plot_annotation(title = str_wrap("Scatterplot of School Average 4th Grade Student Scores against 2nd Grade Student Scores",90))
regplots


summary(lm(student_knowledge~ecd2_student_knowledge, data=df_reg))



###################################
  
  
  
  regplots<- ggplot(data=df_reg, aes(x=ecd_student_knowledge, y=ecd2_student_knowledge, weight=school_weight, color="#0081a8")) +
  geom_point() +
  geom_smooth(method='lm') +
  scale_color_manual(labels = c( "Principal Indicator "),  values= c( "#0081a8")) +
  theme_bw() +
  theme(
    text = element_text(size = 14),
    legend.position='none'
  ) +
  expand_limits(x = 0, y = 0) +
  labs(colour = "Indicator") +
  ylab(paste0("2nd Grade Score")) +
  xlab(paste0("1st Grade Score")) +
  geom_richtext(
    aes(x=10,y=10,label = eq_plot_txt(df_reg, ecd2_student_knowledge, ecd_student_knowledge), hjust=0.2)
  ) +
  plot_annotation(title = str_wrap("Scatterplot of School Average 2nd Grade Student Scores against 1st Grade Student Scores",90))
regplots


summary(lm(ecd2_student_knowledge~ecd_student_knowledge, data=df_reg))