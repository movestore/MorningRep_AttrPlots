library('move2')
library('ggplot2')
library("dplyr")
library('reshape2')
library('gridExtra')
library("units")
library("scales")
library("randomcoloR")
library("grid")

# data <- readRDS("./data/raw/input2_move2loc_Mollweide.rds")
# time_now <- max(mt_time(data))
# time_dur <- 10
# attribs <- paste(names(data)[c(2:16)], collapse = " ,")
# attribs <-  paste(c("eobs_temperature" ,"height_above_ellipsoid","eobs_fix_battery_voltage"), collapse = " ,")

rFunction = function(time_now=NULL, attribs=NULL, time_dur=NULL, data) { 
  
  Sys.setenv(tz="UTC")
  
  if (is.null(attribs)) {
    logger.info("Warning! You did not provide any attribute names to be plotted. The function returns the input data set. No plots will be generated.")
  } else{
    
    if (is.null(time_now)) {time_now <- Sys.time()} else {time_now <- as.POSIXct(time_now,format="%Y-%m-%dT%H:%M:%OSZ",tz="UTC")}
    
    time0 <- time_now - as.difftime(time_dur,units="days")
    
    dataPlot <-  data %>%
      group_by(mt_track_id()) %>%
      filter(mt_time() >= time0)
    
    if(nrow(dataPlot)>0){
      idall <- unique(mt_track_id(data))
      idsel <- unique(mt_track_id(dataPlot))
      if(!identical(idall, idsel)){logger.info(paste0("There are no locations available in the requested time window for track(s): ",paste0(idall[!idall%in%idsel], collapse = ", ")))}
      
      attribs_list <- strsplit(attribs,",")[[1]]
      for(i in seq(along=attribs_list)) {attribs_list[i] <- gsub(" ","",attribs_list[i],fixed=TRUE)}
      
      attribs_ok <- attribs_list[attribs_list %in% names(data)]
      len <- length(attribs_ok)
      attribs_error <- attribs_list[!attribs_list %in% names(data)]
      if(length(attribs_error)>0) logger.info(paste0("Warning! Your defined attributes: ",paste(attribs_error,collapse=", ")," do not exist in the data set. They will not be plotted."))
      
      
      if (len>0){
        logger.info(paste0("Your defined attributes: ",paste(attribs_ok,collapse=", ")," exist in the data set and will be plotted."))
        
        n <- length(attribs_ok)
        if(n < 10){colspt <- brewer_pal(palette = "Set1")(n)}else{colspt <- distinctColorPalette(n)}
        
        dataPlotTr <- split(dataPlot, mt_track_id(dataPlot))
        ggall <- lapply(dataPlotTr, function(trk){
          trk_df <- data.frame(timestamps=mt_time(trk),as.data.frame(trk)[,attribs_ok])
          # trk_df$dummy <- NA
          ggtrk <- lapply(seq_along(attribs_ok), function(x){
            atr <- attribs_ok[x]
            clr <- colspt[x]
            ggplot(trk_df) +
              geom_line(aes(x = timestamps , y = !!sym(atr)), color=clr, show.legend=FALSE) + 
              # facet_grid( ~ dummy, labeller=labeller(dummy=atr))+
              ggtitle(atr)+
              xlab("")+ylab("")+
              theme_bw()
          })
          if(len<=5){
            ggtrkpg <- grid.arrange(grobs=ggtrk,ncol=1,top = textGrob(paste("Track:",unique(mt_track_id(trk)))))
          }
          if(len>5){
            ggtrkpg <-  grid.arrange(grobs=ggtrk,ncol=2,top = textGrob(paste("Track:",unique(mt_track_id(trk)))))
          }
          return(ggtrkpg)
        })
        if(len>5){logger.info("Warning! You have selected more than 5 valid attributes to plot. This might lead to very small plots.")}
        gp  <- marrangeGrob(ggall, nrow = 1, ncol = 1)
        ggsave(file=appArtifactPath("MorningReport_attribPlots.pdf"), plot = gp, width = 21, height = 29.7, units = "cm")
      }
    }else{logger.info("None of the individuals have data in the requested time window. Thus, no pdf artefact is generated.")}
  }
  return(data)
}
