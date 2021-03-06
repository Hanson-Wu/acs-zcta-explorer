# population estimates data by race and ethnicity for zip code tabulated areas for 2013
# see http://factfinder.census.gov/faces/affhelp/jsf/pages/metadata.xhtml?lang=en&type=dataset&id=dataset.en.ACS_13_5YR
library(acs)
zip_geo = geo.make(zip.code = "*")
race.data = acs.fetch(geography=zip_geo, table.number = "B03002", col.names = "pretty", endyear = 2013, span = 5)

# print column names
# acs.data@acs.colnames

# convert to a data.frame 
df_race = data.frame(region                   = as.character(geography(race.data)$zipcodetabulationarea), 
                     total_population         = as.numeric(estimate(race.data[,1])),
                     white_alone_not_hispanic = as.numeric(estimate(race.data[,3])),
                     black_alone_not_hispanic = as.numeric(estimate(race.data[,4])),
                     asian_alone_not_hispanic = as.numeric(estimate(race.data[,6])),
                     hispanic_all_races       = as.numeric(estimate(race.data[,12])))

df_race$region = as.character(df_race$region) # no idea why, but it's a factor before this line

df_race$percent_white    = round(df_race$white_alone_not_hispanic / df_race$total_population * 100)
df_race$percent_black    = round(df_race$black_alone_not_hispanic / df_race$total_population * 100)
df_race$percent_asian    = round(df_race$asian_alone_not_hispanic / df_race$total_population * 100)
df_race$percent_hispanic = round(df_race$hispanic_all_races       / df_race$total_population * 100)

df_race = df_race[, c("region", "total_population", "percent_white", "percent_black", "percent_asian", "percent_hispanic")]

# per capita income 
library(choroplethr)
df_income = get_acs_data("B19301", "zip", endyear=2013, span=5)[[1]]  
colnames(df_income)[[2]] = "per_capita_income"

# median rent
df_rent = get_acs_data("B25058", "zip", endyear=2013, span=5)[[1]]  
colnames(df_rent)[[2]] = "median_rent"

# median age
# can't do get_acs_data here because there seems to be a bug with how column_idx is treated right now
#df_age = get_acs_data("B01002", "zip", endyear=2013, span=5, column_idx=1)[[1]]  
age = acs.fetch(geography=zip_geo, table.number = "B01002", col.names = "pretty", endyear = 2013, span = 5)
df_age = choroplethr:::convert_acs_obj_to_df("zip", age, 1) 
colnames(df_age)[[2]] = "median_age"

df_demographics = merge(df_race, df_income)
df_demographics = merge(df_demographics, df_rent)  
df_demographics = merge(df_demographics, df_age)

# remove the regions (such as zips in Puerto Rico) that are not on my map.
library(choroplethrZip)
data(zip.regions)
df_demographics = df_demographics[df_demographics$region %in% zip.regions$region, ]

# save the data 
save(df_demographics, file="df_demographics.rdata")
write.csv(df_demographics, file="df_demographics.csv")

# subset san francisco and save it
data(zip.regions)
sf_zips = zip.regions[zip.regions$county.name == "san francisco", ]
sf_zips = sf_zips$region

sf_demographics = df_demographics[df_demographics$region %in% sf_zips, ]
save(sf_demographics, file="sf_demographics.rdata")
write.csv(sf_demographics, file="sf_demographics.csv")

