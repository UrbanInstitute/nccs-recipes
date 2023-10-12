library( knitr )
library( tidyverse )
library( pander )


URL <- "https://nccsdata.s3.us-east-1.amazonaws.com/replication/payroll/payroll.zip"
download.file( URL, destfile="payroll.zip" )
unzip( "payroll.zip" )

pc.2019 <- readr::read_csv( "payroll/19eoextract990.csv" )
pc.2020 <- readr::read_csv( "payroll/20eoextract990.csv" )
pc.2021 <- readr::read_csv( "payroll/21eoextract990.csv" )
pf.2020 <- readr::read_csv( "payroll/20eoextract990pf.csv" )
pf.2021 <- readr::read_csv( "payroll/21eoextract990pf.csv" )

## url.pc.2019 <- "https://nccsdata.s3.us-east-1.amazonaws.com/replication/payroll/19eoextract990.csv"
## url.pc.2020 <- "https://nccsdata.s3.us-east-1.amazonaws.com/replication/payroll/20eoextract990.csv"
## url.pc.2021 <- "https://nccsdata.s3.us-east-1.amazonaws.com/replication/payroll/21eoextract990.csv"
## url.pf.2020 <- "https://nccsdata.s3.us-east-1.amazonaws.com/replication/payroll/20eoextract990pf.csv"
## url.pf.2021 <- "https://nccsdata.s3.us-east-1.amazonaws.com/replication/payroll/21eoextract990pf.csv"
## 
## pc.2019 <- readr::read_csv( url.pc.2019 )
## pc.2020 <- readr::read_csv( url.pc.2020 )
## pc.2021 <- readr::read_csv( url.pc.2021 )
## pf.2020 <- readr::read_csv( url.pf.2020 )
## pf.2021 <- readr::read_csv( url.pf.2021 )

head( pc.2019[,1:6] ) %>% pander()

pc.2021$year <- pc.2021$tax_pd  %>% substr( 1, 4 )
pc.2020$year <- pc.2020$tax_pd  %>% substr( 1, 4 )
pc.2019$year <- pc.2019$tax_pd  %>% substr( 1, 4 )
pf.2020$year <- pf.2020$TAX_PRD %>% substr( 1, 4 )
pf.2021$year <- pf.2021$TAX_PRD %>% substr( 1, 4 )

pc.2021 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2021 Form 990 Dataset" )

pf.2021 %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the 2021 Form 990-PF Dataset" )

pc.2021.subset <- filter( pc.2021, year=="2019" )
pf.2021.subset <- filter( pf.2021, year=="2019" )
pc.2020.subset <- filter( pc.2020, year=="2019" )
pf.2020.subset <- filter( pf.2020, year=="2019" )
pc.2019.subset <- filter( pc.2019, year=="2019" )

pc.2021.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2021 Form 990 Dataset" )

pf.2021.subset %>%
  group_by( year ) %>%
  summarise( n() ) %>%
  kable( col.names = c( "Tax Period", "Frequency" ),
         caption = "Tax Periods in the Subsetted 2021 Form 990-PF Dataset" )

names( pc.2021.subset ) <- tolower( names( pc.2021.subset ) )
names( pc.2020.subset ) <- tolower( names( pc.2020.subset ) )
names( pc.2019.subset ) <- tolower( names( pc.2019.subset ) )
names( pf.2021.subset ) <- tolower( names( pf.2021.subset ) )
names( pf.2020.subset ) <- tolower( names( pf.2020.subset ) )

pc.2021.subset2 <- 
  pc.2021.subset %>%
  select( ein, payrolltx, compnsatncurrofcr, 
          compnsatnandothr, othrsalwages, 
          pensionplancontrb, othremplyeebenef ) 

pc.2020.subset2 <- 
  pc.2020.subset %>%
  select( ein, payrolltx, compnsatncurrofcr, 
          compnsatnandothr, othrsalwages, 
          pensionplancontrb, othremplyeebenef ) 

pc.2019.subset2 <- 
  pc.2019.subset %>%
  select( ein, payrolltx, compnsatncurrofcr, 
          compnsatnandothr, othrsalwages, 
          pensionplancontrb, othremplyeebenef ) 

pf.2021.subset2 <- 
  pf.2021.subset %>%
  select( ein, compofficers, pensplemplbenf ) 

pf.2020.subset2 <- 
  pf.2020.subset %>%
  select( ein, compofficers, pensplemplbenf ) 

pc <- 
  bind_rows( pc.2021.subset2, 
             pc.2020.subset2, 
             pc.2019.subset2 )
pf <- 
  bind_rows( pf.2021.subset2, 
             pf.2020.subset2 )

# roughly 1,200 duplicates

n_distinct( pc$ein )
nrow( pc )

n_distinct( pf$ein )
nrow( pf )

pc <- pc %>% distinct( ein, .keep_all = TRUE )
pf <- pf %>% distinct( ein, .keep_all = TRUE )

n_distinct( pc$ein )
nrow( pc )

n_distinct( pf$ein )
nrow( pf )

# helpful function for printing large numbers
dollarize <- function(x) 
{ paste0( "$", format( round(x,0), big.mark="," ) ) }

prtax <- sum( pc$payrolltx, na.rm = T )
dollarize( prtax )

salaries <- 
  sum( pc$compnsatncurrofcr,
       pc$compnsatnandothr,
       pc$othrsalwages,
       pc$pensionplancontrb,
       pc$othremplyeebenef, 
       na.rm = T )

dollarize( salaries )

ratio <- prtax / salaries
paste0( 100*round( ratio, 4 ), "%" )

salaries.pf <- 
  sum( pf$compofficers, 
       pf$pensplemplbenf, 
       na.rm = T )

dollarize( salaries.pf )

prtax.pf <- ratio * salaries.pf

dollarize( prtax.pf )

tax.total <- prtax + prtax.pf
dollarize( tax.total )

( tax.total * 1.1885 ) %>% dollarize()
