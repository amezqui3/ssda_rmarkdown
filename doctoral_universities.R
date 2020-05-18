library(ggplot2)
library(plotly)

ggplotJitter <- function (data,Y,X,W,Z,ID,SZ,title='Doctoral US Universities') {
  
  category <- unlist(unique(data[X])) 
  medians <- 1:length(category)
  for( i in 1:length(medians))
    medians[i] <- median(data[data[X] == as.character(category[i]), Y])
  medians
  
  p <- ggplot(data, aes_string(x=X, y=Y, id=ID, enroll=SZ)) +
    stat_summary(aes_string(x=X, y=Y), fun.data = median_hilow, 
                 geom = "crossbar", width = .5, size=1, color = "violet", fatten=2.5,
                 inherit.aes = FALSE) +
    geom_jitter(aes_string(color=W, shape=Z)) +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
    labs(color = improve_label(W), shape=improve_label(Z)) +
    xlab(improve_label(X)) +
    ylab(improve_label(Y)) +
    ggtitle(title) +
    labs(subtitle = paste(category,': ', signif(medians,2), sep='\t', collapse = '\t'))
  
  return(p)
}

datasrc <- 'data/'
datafile <- 'college_data.csv'
utilsfile <- 'utils/utils.R'
source(utilsfile)

data <- read.csv(paste(datasrc,datafile,sep=''))

ID <- "Institution.Name" 
SZ <- "Total..enrollment..DRVEF2018." 
carnegie <- "Carnegie.Classification..HD2018."
landgrant <- "Land.Grant.Institution..HDNo0Yes8."
sector <- "Sector.of.institution..HDPrivate0Public8."

PhD <- "Number.of.students.receiving.a.Doctor.s.degree..DRVC2018."
MS <- "Number.of.students.receiving.a.Master.s.degree..DRVC2018."
BS <- "Number.of.students.receiving.a.Bachelor.s.degree..DRVC2018."
AS <- "Number.of.students.receiving.an.Associate.s.degree..DRVC2018."
PB <- "Number.of.students.receiving.a.Postbaccalaureate.or.Post.master.s.certificate..DRVC2018."
Cert4 <- "Number.of.students.receiving.a.certificate.of.1.but.less.than.4.years..DRVC2018."

Men <- "Percent.admitted...men..DRVADM2018."
Women <-  "Percent.admitted...women..DRVADM2018."

GradT <- "Graduate.enrollment..DRVEF2018."
UnderT <- "Undergraduate.enrollment..DRVEF2018."
GradF <- "Full.time.graduate.enrollment..DRVEF2018."
UnderF <- "Full.time.undergraduate.enrollment..DRVEF2018."
Normalized <- "Students.receiving.a.PhD.normalized..DRVC2018."

p <- ggplotJitter(df, Normalized, carnegie, sector, landgrant, ID, SZ)
p
ggplotly(p, tooltip = c('id', 'enroll', 'y'))


df <- data.frame(
  data[c(carnegie,PhD,ID,SZ,sector,landgrant)],
  Students.receiving.a.PhD.normalized..DRVC2018. = as.vector(unlist(data[PhD]/data[GradT]))
)

p <- ggplot(data, aes_string(x=carnegie, y=PhD, id=ID, enroll=SZ)) +
  stat_summary(aes_string(x=carnegie, y=PhD), fun.data = median_hilow, 
               geom = "crossbar", width = .5, size=1, color = "violet", fatten=2.5,
               inherit.aes = FALSE) +
  geom_jitter(aes_string(color=sector, shape=landgrant)) +
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
  labs(color = improve_label(sector), shape=improve_label(landgrant)) +
  xlab(improve_label(carnegie)) +
  ylab(improve_label(PhD)) +
  ggtitle('US Doctoral') +
  labs(subtitle = paste(category,': ', medians, sep='', collapse = '\t'))
p


ggplot(iris, aes(x=Species, y=Sepal.Width, shape=Species)) +  
  stat_summary(fun.data = median_hilow, geom = "crossbar", width = .5, color = "red") +
  geom_jitter(width=0.2)
