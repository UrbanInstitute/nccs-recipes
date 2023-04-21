# Data

When possible, add data to make existing scripts executable.  

## Instructions

There are a few ways to add data to scripts. 

Ideally the dataset is already in a package. In that case it is as easy as loading the package and attaching the dataset.

In other cases the file might be too large 

In many cases, though, you can create a small demo version of the dataset and include it with the script. Let's use the US Mortality dataset as an example: 

```r
d <- head( USMortality )
d %>% kable()
```

|   |Status |Sex    |Cause         |  Rate|  SE|
|:--|:------|:------|:-------------|-----:|---:|
|1  |Urban  |Male   |Heart disease | 210.2| 0.2|
|2  |Rural  |Male   |Heart disease | 242.7| 0.6|
|3  |Urban  |Female |Heart disease | 132.5| 0.2|
|4  |Rural  |Female |Heart disease | 154.9| 0.4|
|53 |Urban  |Male   |Cancer        | 195.9| 0.2|
|54 |Rural  |Male   |Cancer        | 219.3| 0.5|


### dput()

The dput() function dumps an object (versus just printing the object values). 

```r
dput(d)
```
You can copy the output and add it directly to your script. You just need to add the object name and assignment operator before the output. 

```
d <- # add this line manually
structure(list(Status = structure(c(2L, 1L, 2L, 1L, 2L, 1L), .Label = c("Rural", 
"Urban"), class = "factor"), Sex = structure(c(2L, 2L, 1L, 1L, 
2L, 2L), .Label = c("Female", "Male"), class = "factor"), Cause = structure(c(6L, 
6L, 6L, 6L, 2L, 2L), .Label = c("Alzheimers", "Cancer", "Cerebrovascular diseases", 
"Diabetes", "Flu and pneumonia", "Heart disease", "Lower respiratory", 
"Nephritis", "Suicide", "Unintentional injuries"), class = "factor"), 
    Rate = c(210.2, 242.7, 132.5, 154.9, 195.9, 219.3), SE = c(0.2, 
    0.6, 0.2, 0.4, 0.2, 0.5)), row.names = c(1L, 2L, 3L, 4L, 
53L, 54L), class = "data.frame")
```

### dump()

```r
dump( "d", file="USMortality.R" )
```

This will create an [R script](USMortality.R) that contains the object. You would add it to the script by: 

1. Add the file to the data folder. 
2. Navigate to the file and get the raw URL. 
3. Source the URL in the script. 

```r
source( "https://raw.githubusercontent.com/UrbanInstitute/nccs-pubs-recipes/main/data/USMortality.R" )
```

Note that repositories have to be public for this to work properly.


### Hosted Data

You can also read data from an external source as long as it has a URL. The important thing is finding the right link to the raw file. 

In Box you can select the option to share a file, but you need to go into the advanced settings and select the link to the raw data file (the other link takes you to an HTML download page). 

```r
d <- read.csv( "https://urbanorg.box.com/shared/static/q6r3bviyidwioxab5qygvfiqgldrnx0x.csv" )
```

In DropBox you can right-click on a file and select "Copy DropBox Link" to get a URL. To use the URL to load data directly you just need to change the download option to yes (change "dl=0" to "dl=1" at the end of the URL): 

```r
d <- read.csv( "https://www.dropbox.com/s/pruacygsb3z7e5j/biz-mod-data.csv?dl=1" )
```
