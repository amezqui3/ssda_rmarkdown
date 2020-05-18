library(ggplot2)
library(plotly)

improve_label <- function(label){
  xlab <- strsplit(label, '[.]')[[1]]
  xlab <- xlab[1:(length(xlab)-2)]
  return(paste(xlab, collapse = ' '))
}

linregression_traditional <- function(data,X,Y,W, logtrans=F){
  
  usedata <- data
  if(logtrans == T)
    usedata[c(X,Y)] <- log(data[c(X,Y)])
  categories <- as.character(unlist(unique(data[W])))
  cols <- hcl.colors(length(categories), palette = 'Zissou 1')
  
  maX <- apply(usedata[c(X,Y)],2,max)
  miN <- apply(usedata[c(X,Y)],2,min)
  
  xlab <- improve_label(X)
  ylab <- improve_label(Y)
  wlab <- improve_label(W)
  
  regression <- lm(as.formula(paste(Y,'~',X)), usedata)
  diagnostic <- summary(regression)$coefficients
  
  plot(usedata[c(X,Y)], xlab=xlab, ylab=ylab, type='n')
  
  polygon(c(maX[1], maX[1], miN[1], miN[1]),
          c((diagnostic[2,1] + diagnostic[2,2])*maX[1] + (diagnostic[1,1] + diagnostic[1,2]),
            (diagnostic[2,1] - diagnostic[2,2])*maX[1] + (diagnostic[1,1] - diagnostic[1,2]),
            (diagnostic[2,1] + diagnostic[2,2])*miN[1] + (diagnostic[1,1] + diagnostic[1,2]),
            (diagnostic[2,1] - diagnostic[2,2])*miN[1] + (diagnostic[1,1] - diagnostic[1,2])),
          col='skyblue')
  abline(coef = regression$coefficients, col='lightcyan4', lw=4)
  
  ptch <- c(21:25)
  for(i in 1:length(categories)){
    points(usedata[data[W] == categories[i], c(X,Y)], pch=ptch[i], bg=cols[i])
  }
  legend('topleft', title=wlab, legend=categories, pt.bg=cols, pch = ptch[1:length(cols)])
  
  return(regression)
}

ggplotRegression <- function (data,Y,X,W,Z,ID,SZ,title='Doctoral US Universities') {
  fit <- lm(as.formula(paste(Y,'~',X)), data)
  
  smmry <- summary(fit)
  p <- ggplot(data, aes_string(x=X, y=Y, color=W, shape=Z, id=ID, enroll=SZ)) + 
    stat_smooth(aes_string(x=X,y=Y), method = "lm", col = "violet", inherit.aes = F) +
    geom_point() +
    theme(plot.title = element_text(hjust = 0.5), plot.subtitle = element_text(hjust = 0.5)) +
    labs(color = improve_label(W), shape=improve_label(Z)) +
    xlab(improve_label(names(fit$model)[2])) +
    ylab(improve_label(names(fit$model)[1])) +
    #theme(legend.justification='top', legend.position=c(0.17,0.99)) +
    labs(subtitle =  paste("Adj R2 = ",signif(smmry$adj.r.squared, 2), 
                           ";\t Slope =",signif(fit$coef[[2]], 2),
                           ";\t P =",signif(smmry$coef[2,4], 2)),
         title = title)
  
  return(list(p, fit))
}

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
