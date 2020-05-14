library(ggplot2)
library(plotly)

ggplotRegression <- function (data,Y,X,W,Z,title) {
  fit <- lm(as.formula(paste(Y,'~',X)), data)
  
  smmry <- summary(fit)
  p <- ggplot(data, aes_string(x=X, y=Y, color=W, shape=Z, id=ID, enroll=SZ)) + 
    stat_smooth(aes_string(x=X,y=Y), method = "lm", col = "red", inherit.aes = F) +
    geom_point() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
    labs(color = improve_label(W), shape=improve_label(Z)) +
    xlab(improve_label(names(fit$model)[2])) +
    ylab(improve_label(names(fit$model)[1])) +
    theme(legend.justification='top', legend.position=c(0.17,0.99)) +
    labs(subtitle =  paste("Adj R2 = ",signif(smmry$adj.r.squared, 2), 
                           ";\t Slope =",signif(fit$coef[[2]], 2),
                           ";\t P =",signif(smmry$coef[2,4], 2)),
         title = 'US doctoral')
  
  return(list(p, fit))
}


datasrc <- 'data/'
datafile <- 'college_data.csv'
utilsfile <- 'utils/utils.R'
source(utilsfile)

data <- read.csv(paste(datasrc,datafile,sep=''))

Y <- "Total.FTE.staff..DRVHR2018."
X <- "Instructional..research.and.public.service.FTE..DRVHR2018."  
ID <- "Institution.Name" 
SZ <- "Total..enrollment..DRVEF2018." 
carnegie <- "Carnegie.Classification..HD2018."
landgrant <- "Land.Grant.Institution..HDNo0Yes8."
sector <- "Sector.of.institution..HDPrivate0Public8."

foo <- ggplotRegression(data,Y,X,carnegie,sector,'US Doctoral Universities')
foo[[1]]
ggplotly(foo[[1]], tooltip = c('id', 'enroll', 'x', 'y'), size=8)

fit <- lm(as.formula(paste(Y,'~',X)), data)

smmry <- summary(fit)
p <- ggplot(data, aes_string(x=X, y=Y, color=carnegie, shape=sector, id=ID, enroll=SZ)) + 
  stat_smooth(aes_string(x=X,y=Y), method = "lm", col = "red", inherit.aes = F) +
  geom_point() +
  theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
  labs(color = improve_label(carnegie), shape=improve_label(sector)) +
  xlab(improve_label(names(fit$model)[2])) +
  ylab(improve_label(names(fit$model)[1])) +
  theme(legend.justification='top', legend.position=c(0.17,0.99)) +
  labs(subtitle =  paste("Adj R2 = ",signif(smmry$adj.r.squared, 2), 
                         ";\t Slope =",signif(fit$coef[[2]], 2),
                         ";\t P =",signif(smmry$coef[2,4], 2)),
       title = 'US doctoral')
 
  
p
