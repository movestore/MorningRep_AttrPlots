# Morning Report pdf Attribute Plots
MoveApps

Github repository: *github.com/movestore/MorningRep_AttrPlots*

## Description
This App creates a multipage pdf downloadable file with time-plots of up to five selected data attributes for each individual track. A reference time and (back) time duration have to be provided. So that you can get an overview of how your animals (and tags) were doing. 

## Documentation
A multipage pdf is created of up to 5 user-defined data attributes across time. The plotted time window is defined by the reference timestamp (either user-defined or by default NOW) and the time duration that defines how long before the reference timestamp the x-axis of the plots shall start.

### Input data
moveStack in Movebank format

### Output data
moveStack in Movebank format

### Artefacts
`MorningReport_attribPlots.pdf`: Artefact pdf with a multiple attribute plots on each page showing the time series of the selected attributes for one animal.

### Settings
**Reference time (`time_now`):** reference timestamp towards which all analyses are performed. Generally (and by default) this is NOW, especially if in the field and looking for one or the other animal or wanting to make sure that it is still doing fine. When analysing older data sets, this parameter can be set to other timestamps so that the to be plotted data fall into a selected back-time window. 

**Track time duration. (`time_dur`):** time duration into the past that the attributes have to be plotted for. So, if the time duration is selected as 7 days then the x-axis ranges from the reference timestamp to 7 days before it. Unit: days

**Data attributes to plot (max. of 5 attributes allowed) (`attribs`):** the user has to provide the data attributes that shall be plotted for the defined time window. They have to be correctly spelled and comma-separated. Example: "tag_voltage, location_lat".

### Null or error handling:
**Setting `time_now`:** If this parameter is left empty (NULL) the reference time is set to NOW. The present timestamp is extracted in UTC from the MoveApps server system.

**Setting `time_dur`:** If this parameter is left empty (NULL) then by default 10 days is used. A respective warning is given.

**Setting `attribs`:** If no attributes are defined (NULL) or none of the given attributes relate to any column names of the data set, then no pdf artefact is created. If more than 5 valid attributes are listed a warning is given, but the plotting is still done; the plots might be cut off on the pdf pages.

**Artefact:** If there are no locations of any animals in the defined time window, a warning is given and no pdf artefact created.

**Data:** The data are not manipulated in this App, but plotted in a downloadable pdf. So that a possible Workflow can be continued after this App, the input data set is returned.
