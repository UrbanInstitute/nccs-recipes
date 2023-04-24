#This script uses 2019 Form 990 data, available at https://rb.gy/at3sp,
#to estimate the annual amount of payroll taxes that nonprofits pay.
#We use 2019, 2020, and 2021 files since there's a 2-year lag.
#And we adjust 18.85% for inflation at the end, because
#https://salaryinflation.com/ says salaries experienced that much inflation
#from January 2019 to April 2023 (when we wrote this script).

library( tidyverse )
library( knitr )

#read the CSVs
soi.2021 <- read_csv(
  "https://urbanorg.box.com/shared/static/q6r3bviyidwioxab5qygvfiqgldrnx0x.csv"
  )
soi.pf.2021 <- read_csv(
  "https://urbanorg.box.com/shared/static/h51re368fls4zjojjewxqfk59tzfmpjv.csv"
  )
soi.2020 <- read_csv(
  "https://urbanorg.box.com/shared/static/qvzbroegxaz6fs2zgdt8vdc76wcb0owq.csv"
  )
soi.pf.2020 <- read_csv(
  "https://urbanorg.box.com/shared/static/qhzpgenehsgg9dcn4lgm26huxnnxjo2b.csv"
  )
soi.2019 <- read_csv(
  "https://urbanorg.box.com/shared/static/kgonjv86e1fob90rdk12burnsc0ces3s.csv"
  )

#check the tax period years that are in the datasets
soi.2021$year <- substr( as.character( soi.2021$tax_pd ), 1, 4)
table( soi.2021$year ) %>% kable()

#  |1980 |      1|
#  |2006 |      1|
#  |2007 |      2|
#  |2008 |      3|
#  |2009 |     11|
#  |2010 |     13|
#  |2011 |     17|
#  |2012 |     26|
#  |2013 |     47|
#  |2014 |     83|
#  |2015 |    144|
#  |2016 |    320|
#  |2017 |    757|
#  |2018 |   2516|
#  |2019 |  41258|
#  |2020 | 258312|
#  |2021 |  39409|

soi.2020$year <- substr( as.character( soi.2020$tax_pd ), 1, 4)
table( soi.2020$year ) %>% kable()

#  |2000 |      1|
#  |2001 |      1|
#  |2008 |      1|
#  |2009 |      2|
#  |2010 |     11|
#  |2011 |     17|
#  |2012 |     22|
#  |2013 |     32|
#  |2014 |     43|
#  |2015 |     66|
#  |2016 |    120|
#  |2017 |    589|
#  |2018 |   9035|
#  |2019 | 227816|
#  |2020 |  36215|

soi.2019$year <- substr( as.character( soi.2019$tax_pd ), 1, 4)
table( soi.2019$year ) %>% kable()

#  |2000 |      1|
#  |2007 |      1|
#  |2008 |      8|
#  |2009 |     14|
#  |2010 |     28|
#  |2011 |     38|
#  |2012 |     51|
#  |2013 |     88|
#  |2014 |    161|
#  |2015 |    402|
#  |2016 |   1180|
#  |2017 |   6059|
#  |2018 | 254339|
#  |2019 |  42071|

soi.pf.2021$year <- substr( as.character( soi.pf.2021$TAX_PRD ), 1, 4)
table( soi.pf.2021$year ) %>% kable()

#  |2007 |     1|
#  |2008 |     1|
#  |2009 |     3|
#  |2010 |     2|
#  |2011 |     6|
#  |2012 |    10|
#  |2013 |    14|
#  |2014 |    18|
#  |2015 |    21|
#  |2016 |    67|
#  |2017 |   170|
#  |2018 |   796|
#  |2019 | 17867|
#  |2020 | 95996|
#  |2021 | 10340|

soi.pf.2020$year <- substr( as.character( soi.pf.2020$TAX_PRD ), 1, 4)
table( soi.pf.2020$year ) %>% kable()

#  |2007 |     2|
#  |2008 |     2|
#  |2009 |     1|
#  |2010 |     3|
#  |2011 |     5|
#  |2012 |     8|
#  |2013 |    10|
#  |2014 |    11|
#  |2015 |    25|
#  |2016 |    68|
#  |2017 |   252|
#  |2018 |  1948|
#  |2019 | 80470|
#  |2020 |  8668|

#only keep tax period year 2019
soi.2021 <- subset( soi.2021, year=="2019" )
soi.2020 <- subset( soi.2020, year=="2019" )
soi.2019 <- subset( soi.2019, year=="2019" )
soi.pf.2021 <- subset( soi.pf.2021, year=="2019" )
soi.pf.2020 <- subset( soi.pf.2020, year=="2019" )

#COMBINE DATASETS
  #only keep the variables we'll need,
  #because several of the variable types don't match, and it's creating errors.
  #and make soi_2021$EIN lowercase to match 2020 and 2019
soi.2021$ein <- soi.2021$EIN

soi.2021 <- 
  soi.2021 %>%
  subset( select=c( ein, payrolltx, compnsatncurrofcr, 
                    compnsatnandothr, othrsalwages, 
                    pensionplancontrb, othremplyeebenef ) )

soi.2020 <- 
  soi.2020 %>%
  subset( select=c( ein, payrolltx, compnsatncurrofcr, 
                    compnsatnandothr, othrsalwages, 
                    pensionplancontrb, othremplyeebenef ) )

soi.2019 <- 
  soi.2019 %>%
  subset( select=c( ein, payrolltx, compnsatncurrofcr, 
                    compnsatnandothr, othrsalwages, 
                    pensionplancontrb, othremplyeebenef ) )

soi.pf.2021 <- 
  soi.pf.2021 %>%
  subset( select=c( EIN, COMPOFFICERS, PENSPLEMPLBENF ) )

soi.pf.2020 <- 
  soi.pf.2020 %>%
  subset( select=c( EIN, COMPOFFICERS, PENSPLEMPLBENF ) )

soi <- bind_rows( soi.2021, soi.2020, soi.2019 )
soi.pf <- bind_rows( soi.pf.2021, soi.pf.2020 )

#remove duplicate EINs
soi <- soi %>% distinct( ein, .keep_all = TRUE )
soi.pf <- soi.pf %>% distinct( EIN, .keep_all = TRUE )

#sum the payroll taxes for 990 filers
payroll.tax <- sum( soi$payrolltx, na.rm=T )
payroll.tax #55,464,358,803

#from the codebook:
#  |Element Name	Description	     Location
#  |payrolltx	    Payroll taxes	   990 Core_Pt IX-10(A)

#sum the salaries for 990 filers
salaries <- sum( soi$compnsatncurrofcr, soi$compnsatnandothr, soi$othrsalwages,
                 soi$pensionplancontrb, soi$othremplyeebenef, na.rm=T )

#from the codebook:
#  |Element Name	      Description
#  |compnsatncurrofcr	  Compensation of current officers, directors, etc
#  |compnsatnandothr	  Compensation of disqualified persons   
#  |othrsalwages	      Other salaries and wages        
#  |pensionplancontrb	  Pension plan contributions
#  |othremplyeebenef	  Other employee benefits

#  |Location
#  |990 Core_Pt IX-5(A)
#  |990 Core_Pt IX-6(A)
#  |990 Core_Pt IX-7(A)
#  |990 Core_Pt IX-7(A)
#  |990 Core_Pt IX-8(A)
#  |990 Core_Pt IX-9(A)

#calculate the percentage of salaries that 990 filers spend on payroll taxes
percent <- payroll.tax / salaries
percent #5.75%

#sum the salaries for 990-PF filers
salaries.pf <- sum( soi.pf$COMPOFFICERS, soi.pf$PENSPLEMPLBENF, na.rm=T )
salaries.pf #2,670,373,181

#from the codebook:
#  |Element Name	   Description	                      Location
#  |COMPOFFICERS	   Compensation of officers	          990-PF Pt I-13, col (a)
#  |PENSPLEMPLBENF	 Pension plans, employee benefits 	990-PF Pt I-15, col (a)

#estimate the payroll taxes for 990-PF filers, based on the percentage
#of salaries that 990 filers spend on payroll taxes
payroll.tax.pf <- percent * salaries.pf
payroll.tax.pf #153,457,677

#sum the payroll taxes of 990 and 990-PF filers
payroll.tax + payroll.tax.pf #55,617,816,480

#scale by 18.85% for inflation
55617816480*1.1885 #66,101,774,886