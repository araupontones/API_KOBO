library(httr)
library(jsonlite)

#BEFORE ANYTHING, CREATE A TOKEN IN KOBO: https://support.kobotoolbox.org/api.html


#Define url to query  ---------------------------------
base_url = "https://kobo.humanitarianresponse.info"
token_url = paste0(base_url, "/token/?format=json")


## GET token (you need to define your user name and password of your kobo server) -----------------------------

password = "XXXXX" #set your password
username = "usuario" #set your username 

respo_token = GET(token_url,authenticate(username, password)) #get token

token = fromJSON(content(respo_token, 'text')) %>% as.character() #convert response to character



##get list of assests in server (notice that I am using the token gotten above)-----------------------------
respo_assets = GET("https://kc.humanitarianresponse.info/api/v1/data",
                   authenticate(username, password),
                   query=list(Authorization=token)
)

http_status(respo_assets) #check status of query

#list of assets
assets = fromJSON(content(respo_assets, 'text')) %>% tibble()


##export data -----------------------------------------------------------------------------------------------------

csv_temp = tempfile(fileext = ".csv") #temp file to store the download

qn_url = "https://kc.humanitarianresponse.info/api/v1/data/643810.csv"

respo_qn = GET(qn_url,
               authenticate(username, password),
               query=list(Authorization=token),
               encode = "csv",
               write_disk(csv_temp, overwrite = T)
               
)


#read data -------------------------------------------------------------------------------------------
raw_data = read.csv(csv_temp) 


