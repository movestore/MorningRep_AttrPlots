# Morning Report Attribute Plots PDF
MoveApps

Github repository: *github.com/movestore/MorningRep_AttrPlots*

## Description
This App creates a multipage PDF downloadable file with time-plots of selected data attributes for each individual track. A reference time and (back) time duration have to be provided. So that you can get an overview of how your animals (and tags) were doing. 

## Documentation
A multipage PDF is created of user-defined data attributes across time. The plotted time window is defined by the reference timestamp (either user-defined or by default NOW) and the time duration that defines how long before the reference timestamp the x-axis of the plots shall start.

### Application scope
#### Generality of App usability
This App was developed for any taxonomic group. 

#### Required data properties
The App should work for any kind of (location) data.

### Input type
`move2::move2_loc`

### Output type
`move2::move2_loc`

### Artefacts
`MorningReport_attribPlots.pdf`: PDF with attribute plots per track on each page, showing the time series of the selected attributes for each track.

### Settings 
**Reference time (`time_now`):** reference timestamp towards which all analyses are performed. Generally (and by default) this is NOW, especially if in the field and looking for one or the other animal or wanting to make sure that it is still doing fine. When analysing older data sets, this parameter can be set to other timestamps so that the to be plotted data fall into a selected back-time window. 

**Track time duration. (`time_dur`):** time duration into the past that the track has to be plotted for. So, if the time duration is selected as 5 days then the plotted track consists of all location from the reference timestamp to 5 days before it. Values can be also decimals, e.g. 0.25 for the last 6 hours. Unit: days

**Data attributes to plot (max. of 5 attributes allowed) (`attribs`):** the user has to provide the data attributes that shall be plotted for the defined time window. The exact names of the data attributes must be comma-separated! and without quotes. If unsure of attribute names or spelling, please run the previous App in your workflow and check the `event_attributes` in the `App Output Details` (green 'i'). For definitions of Movebank attributes please refer to the Movebank Attribute Dictionary (https://www.movebank.org/cms/movebank-content/movebank-attribute-dictionary). Example: barometric_pressure, gps_satellite_count.


### Changes in output data
The input data remains unchanged.

### Most common errors

### Null or error handling
*Very small plots*: the more attributes are selected, the smaller the plots. If many attributes need to be plotted, consider adding this App several times to the Workflow, each time with different attributes.
