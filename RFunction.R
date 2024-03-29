library('move')
library('foreach')
library('ggplot2')
library('sf')
library('reshape2')
library('grid')
library('gridExtra')


Sys.setenv(tz="UTC")

rFunction = function(time_now=NULL, attribs=NULL, time_dur=NULL, data, ...) { #dont give id selection option, but decide that only plot those with data in the time_dur window
  
  if (is.null(time_now)) time_now <- Sys.time() else time_now <- as.POSIXct(time_now,format="%Y-%m-%dT%H:%M:%OSZ",tz="UTC")
  
  if (is.null(attribs))
  {
    logger.info("Warning! You did not provide any attribute names to be plotted. The function returns the input data set. No plots will be generated.")
  } else
  {
    attribs_list <- strsplit(attribs,",")[[1]]
    for (i in seq(along=attribs_list)) attribs_list[i] <- gsub(" ","",attribs_list[i],fixed=TRUE)
    
    data_spl <- move::split(data)
    ids <- namesIndiv((data))
    if (is.null(time_dur))
    {
      time_dur <- 10
      logger.info("You did not provide a time duration for your plot. It is defaulted by 10 days.")
    }  #else  time_dur <- as.numeric(time_dur)
    time0 <- time_now - as.difftime(time_dur,units="days")
    
    attribs_ok <- attribs_list[attribs_list %in% names(data)]
    len <- length(attribs_ok)
    attribs_error <- attribs_list[!attribs_list %in% names(data)]
    if (length(attribs_error)>0) logger.info(paste0("Warning! Your defined attributes: ",paste(attribs_error,collapse=", ")," do not exist in the data set. They will not be plotted."))
    
    if (len>5) logger.info("Warning! You have selected more than 5 valid attributes to plot. This might lead to strange cutoffs on your pdf pages.")
    if (len>0)
    {
      logger.info(paste0("Your defined attributes: ",paste(attribs_ok,collapse=", ")," exist in the data set and will be plotted."))
      g <- list()
      ids_g <- character()
      k <- 1
      for (i in seq(along=ids))
      {
        datai <- data_spl[[i]]
        datai_t <- datai[timestamps(datai)>time0 & timestamps(datai)<time_now]
        if (length(datai_t)>0)
        {
          datai_t_a <- datai_t@data[,c("timestamp",attribs_ok)]
          datai.df <- melt(datai_t_a, measure.vars = attribs_ok)
          
          g[[k]] <- ggplot(datai.df, aes(x = timestamp, y = value)) +
            geom_line(aes(color = variable),show.legend=FALSE) +
            facet_grid(variable ~ ., scales = "free_y") +
            labs(title = paste("individual:",ids[i])) +
            theme(plot.margin=grid::unit(c(2,2,2+3*(5-len),2), "cm")) #max 5 attributes to plot
          ids_g <- c(ids_g,ids[i])
          k <- k+1
          
        } else logger.info(paste0("There are no locations available in the requested time window for individual ",ids[i]))
      }
      
      if (length(ids_g)>0)
      {
        logger.info(paste0("Maps are produced for the individuals ",paste(ids_g,collapse=", "),", which have data in the requested time window."))
        gp  <- marrangeGrob(g, nrow = 1, ncol = 1)
        ggsave(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"MorningReport_attribPlots.pdf"), gp, width = 21, height = 29.7, units = "cm")
        #ggsave("MorningReport_attribPlots.pdf",gp, width = 21, height = 29.7, units = "cm")
      } else logger.info ("None of the individuals have data in the requested time window. Thus, no plots (pdf artefact) is generated.")
        
    } else logger.info("The provided attributes are not available in the given data set, thus no plots (pdf artefact) can be generated.")
  }
  
  return(data)
}
