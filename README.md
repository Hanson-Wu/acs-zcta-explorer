# acs-zcta-explorer

View selected 2013 US Census Demographics for US Zip Code Tabulated Areas (ZCTAs).

You can view the running application [here](https://arilamstein.shinyapps.io/acs-zcta-explorer/), though 
if you see an error message that means that I have exausted my monthly quota at shinyapps.io. In that case you
can install the application yourself by typing the following from an R console:

    # install.packages("shiny")
    library(shiny)
    shiny::runGitHub("acs-zcta-explorer", "arilamstein")
