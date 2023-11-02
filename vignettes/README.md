# Reproducible Data Vignettes and Tutorials

For any projects that require capturing more than basic scripts about projects - specifically creating longer vignettes or tutorials, this is a place to archive content. 

GitHub pages can be turned on to activate any HTML pages in this repository so they can be linked as free-standing data tutorials or used as part of a data story. 

## HTML Elements

* footer.html
* header.html
* css.clean

```
---
title: "Estimating Sector Size Using Payroll Taxes"
output:
  html_document:
    theme: readable
    df_print: paged
    highlight: tango
    toc: true
    self_contained: true
    number_sections: false
    css: clean.css
    include:
      before_body: header.html
      after_body: footer.html
---
```

## Large Datasets and Reproducibility

# functions to help write reproducible vignettes

(1) add data download chunk to vignette

```
add_downzip_code( fn="payroll" )
```

(2) convert rmd to r script for ease of use

```
convert_rmd_to_r( fn="payroll" )
```
(3) package data + r script in zipped dir

```
zip_rep_files( fn="payroll" )
```

(4) upload to AWS S3

```
upload_to_s3( fn="payroll" )
```


> functions invisibly return 
> filename to enable piping

```
## first create "payroll" folder in the 
## proj dir and copy replication data

"payroll" %>%
    convert_rmd_to_r() %>% 
    zip_rep_files() %>%
    upload_to_s3() %>%
    add_downzip_code()

prepare_replication_files( "payroll" )
```

> functions require AWS credentials to 
> be configured and new token created
> for the session 



