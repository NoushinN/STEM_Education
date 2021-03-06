###DEMO for data import into R###
# lessons curated by Noushin Nabavi, PhD (adapted from Datacamp lessons for importing data into R)

# working with excel, csv, and tsv files in R

# Import swimming_pools.csv correctly: pools
pools <- read.csv("swimming_pools.csv", stringsAsFactors = FALSE)
#With stringsAsFactors, you can tell R whether it should convert strings in the flat file to factors.
# Check the structure of pools
str(pools)


# Import hotdogs.txt: hotdogs
hotdogs <- read.delim("hotdogs.txt", header = FALSE)

# Summarize hotdogs
summary(hotdogs)

# Path to the hotdogs.txt file: path
path <- file.path("data", "hotdogs.txt")

# Import the hotdogs.txt file: hotdogs
hotdogs <- read.table(path, 
                      sep = "\t", 
                      col.names = c("type", "calories", "sodium"))

# Call head() on hotdogs
head(hotdogs)

#---------------------------------------------------------------

# Load the readr package
library(readr) #read_csv, read_tsv, and read_delim are part of this package

# Import potatoes.csv with read_csv(): potatoes
potatoes <- read_csv("potatoes.csv")

# Column names
properties <- c("area", "temp", "size", "storage", "method",
                "texture", "flavor", "moistness")

# Import potatoes.txt: potatoes
potatoes <- read_tsv("potatoes.txt", col_names = properties)

# Call head() on potatoes
head(potatoes)


# Import potatoes.txt using read_delim(): potatoes
potatoes <- read_delim("potatoes.txt", delim = "\t", col_names = properties)

# Print out potatoes
potatoes

# Import 5 observations from potatoes.txt: potatoes_fragment
potatoes_fragment <- read_tsv("potatoes.txt", skip = 6, n_max = 5, col_names = properties)


# Import all data, but force all columns to be character: potatoes_char
potatoes_char <- read_tsv("potatoes.txt", col_types = "cccccccc", col_names = properties)

# Print out structure of potatoes_char
str(potatoes_char)

# Import without col_types
hotdogs <- read_tsv("hotdogs.txt", col_names = c("type", "calories", "sodium"))

# Display the summary of hotdogs
summary(hotdogs)

# The collectors you will need to import the data
fac <- col_factor(levels = c("Beef", "Meat", "Poultry"))
int <- col_integer()

# Edit the col_types argument to import the data correctly: hotdogs_factor
hotdogs_factor <- read_tsv("hotdogs.txt",
                           col_names = c("type", "calories", "sodium"),
                           col_types = list(fac, int, int))


#---------------------------------------------------------------

# load the data.table package
library(data.table)

# Import potatoes.csv with fread(): potatoes
potatoes <- fread("potatoes.csv")

# Print out potatoes
potatoes

# Import columns 6 and 8 of potatoes.csv: potatoes
potatoes <- fread("potatoes.csv", select = c(6, 8))

# Plot texture (x) and moistness (y) of potatoes
plot(potatoes$texture, potatoes$moistness)

#---------------------------------------------------------------

# Load the readxl package
library(readxl)

# Print the names of all worksheets
excel_sheets("urbanpop.xlsx")

# Read the sheets, one by one
pop_1 <- read_excel("urbanpop.xlsx", sheet = 1)
pop_2 <- read_excel("urbanpop.xlsx", sheet = 2)
pop_3 <- read_excel("urbanpop.xlsx", sheet = 3)

# Put pop_1, pop_2 and pop_3 in a list: pop_list
pop_list <- list(pop_1, pop_2, pop_3)

# Display the structure of pop_list
str(pop_list)

# Read all Excel sheets with lapply(): pop_list
pop_list <- lapply(excel_sheets("urbanpop.xlsx"), read_excel, path = "urbanpop.xlsx")

# Import the first Excel sheet of urbanpop_nonames.xlsx (R gives names): pop_a
pop_a <- read_excel("urbanpop_nonames.xlsx", col_names = FALSE)

# Import the first Excel sheet of urbanpop_nonames.xlsx (specify col_names): pop_b
cols <- c("country", paste0("year_", 1960:1966))
pop_b <- read_excel("urbanpop_nonames.xlsx", col_names = cols)

# Import the second sheet of urbanpop.xlsx, skipping the first 21 rows: urbanpop_sel
urbanpop_sel <- read_excel("urbanpop.xlsx", sheet = 2, col_names = FALSE, skip = 21)

# Print out the first observation from urbanpop_sel
urbanpop_sel[1,]

#---------------------------------------------------------------

# Import a local file
# Similar to the readxl package, you can import single Excel sheets from Excel sheets to start your analysis in R.
# Load the gdata package
library(gdata)

# Import the second sheet of urbanpop.xls: urban_pop
urban_pop <- read.xls("urbanpop.xls", sheet = "1967-1974")

# Print the first 11 observations using head()
head(urban_pop, n = 11)

# Column names for urban_pop
columns <- c("country", paste0("year_", 1967:1974))

# Finish the read.xls call
urban_pop <- read.xls("urbanpop.xls", sheet = 2,
                      skip = 50, header = FALSE, stringsAsFactors = FALSE,
                      col.names = columns)

# Print first 10 observation of urban_pop
head(urban_pop, n = 10)

# Import all sheets from urbanpop.xls
path <- "urbanpop.xls"
urban_sheet1 <- read.xls(path, sheet = 1, stringsAsFactors = FALSE)
urban_sheet2 <- read.xls(path, sheet = 2, stringsAsFactors = FALSE)
urban_sheet3 <- read.xls(path, sheet = 3, stringsAsFactors = FALSE)

# Extend the cbind() call to include urban_sheet3: urban_all
urban <- cbind(urban_sheet1, urban_sheet2[-1], urban_sheet3[-1])

# Remove all rows with NAs from urban: urban_clean
urban_clean <- na.omit(urban)

# Print out a summary of urban_clean
summary(urban_clean)

#---------------------------------------------------------------

# When working with XLConnect, the first step will be to load a workbook in your R session with loadWorkbook(); this function will build a "bridge" between your Excel file and your R session.

# Load the XLConnect package
library(XLConnect)

# Build connection to urbanpop.xlsx: my_book
my_book <- loadWorkbook("urbanpop.xlsx")

# Print out the class of my_book
class(my_book)


# List the sheets in my_book
getSheets(my_book)

# Import the second sheet in my_book
readWorksheet(my_book, sheet = 2)


# Import columns 3, 4, and 5 from second sheet in my_book: urbanpop_sel
urbanpop_sel <- readWorksheet(my_book, sheet = 2, startCol = 3, endCol = 5)

# Import first column from second sheet in my_book: countries
countries <- readWorksheet(my_book, sheet = 2, startCol = 1, endCol = 1)

# cbind() urbanpop_sel and countries together: selection
selection <- cbind(countries, urbanpop_sel)

# Add a worksheet to my_book, named "data_summary"
createSheet(my_book, "data_summary")

# Use getSheets() on my_book
getSheets(my_book)

# Create data frame: summ
sheets <- getSheets(my_book)[1:3]
dims <- sapply(sheets, function(x) dim(readWorksheet(my_book, sheet = x)), USE.NAMES = FALSE)
summ <- data.frame(sheets = sheets,
                   nrows = dims[1, ],
                   ncols = dims[2, ])

# Add data in summ to "data_summary" sheet
writeWorksheet(my_book, summ, "data_summary")

# Rename "data_summary" sheet to "summary"
renameSheet(my_book, "data_summary", "summary")

# Remove the fourth sheet
removeSheet(my_book, 4)

# Save workbook to "renamed.xlsx"
saveWorkbook(my_book, file = "renamed.xlsx")


#---------------------------------------------------------------


# Download various files with download.file() 
# Here are the URLs! As you can see they're just normal strings
csv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_1561/datasets/chickwts.csv"
tsv_url <- "http://s3.amazonaws.com/assets.datacamp.com/production/course_3026/datasets/tsv_data.tsv"

# Read a file in from the CSV URL and assign it to csv_data
csv_data <- read.csv(file = csv_url)

# Read a file in from the TSV URL and assign it to tsv_data
tsv_data <- read.delim(file = tsv_url)

# Examine the objects with head()
head(csv_data)
head(tsv_data)

# Download the file with download.file()
download.file(url = csv_url, destfile = "feed_data.csv")

# Read it in with read.csv()
csv_data <- read.csv(file = "feed_data.csv")


# Add a new column: square_weight
csv_data$square_weight <- (csv_data$weight ^ 2)

# Save it to disk with saveRDS()
saveRDS(object = csv_data, file = "modified_feed_data.RDS")

# Read it back in with readRDS()
modified_feed_data <- readRDS(file = "modified_feed_data.RDS")

# Examine modified_feed_data
str(modified_feed_data)

#---------------------------------------------------------------

# Using data from API clients 

#example 1
# Load pageviews library for wikipedia
library(pageviews)

# Get the pageviews for "Hadley Wickham"
hadley_pageviews <- article_pageviews(project = "en.wikipedia", article = "Hadley Wickham")

# Examine the resulting object
str(hadley_pageviews)

#example 2
# Load birdnik
library(birdnik)

# Get the word frequency for "vector", using api_key to access it
vector_frequency <- word_frequency(key = api_key, words = "vector")


#---------------------------------------------------------------

# Load the httr package
library(httr)

# Make a GET request to http://httpbin.org/get
get_result <- GET(url = "http://httpbin.org/get")

# Print it to inspect it
get_result


# Make a POST request to http://httpbin.org/post with the body "this is a test"
post_result <- POST(url = "http://httpbin.org/post", body = "this is a test")

# Print it to inspect it
post_result

# Make a GET request to url and save the results
pageview_response <- GET(url)

# Call content() to retrieve the data the server sent back
pageview_data <- content(pageview_response)

# Examine the results with str()
str(pageview_data)

# Handling http failures
fake_url <- "http://google.com/fakepagethatdoesnotexist"

# Make the GET request
request_result <- GET(fake_url)

# Check request_result
if(http_error(request_result)){
  warning("The request failed")
} else {
  content(request_result)
}
#---------------------------------------------------------------

# example start to finish

# Load httr
library(httr)

# The API url
base_url <- "https://en.wikipedia.org/w/api.php"

# Set query parameters
query_params <- list(action = "parse", 
                     page = "Hadley Wickham", 
                     format = "xml")

# Get data from API
resp <- GET(url = base_url, query = query_params)

# Parse response
resp_xml <- content(resp)

# Load rvest
library(rvest)

# Read page contents as HTML
page_html <- read_html(xml_text(resp_xml))

# Extract infobox element
infobox_element <- html_node(x = page_html, css =".infobox")

# Extract page name element from infobox
page_name <- html_node(x = infobox_element, css = ".fn")

# Extract page name as text
page_title <- html_text(page_name)


# Your code from earlier exercises
wiki_table <- html_table(infobox_element)
colnames(wiki_table) <- c("key", "value")
cleaned_table <- subset(wiki_table, !key == "")

# Create a dataframe for full name
name_df <- data.frame(key = "Full name", value = page_title)

# Combine name_df with cleaned_table
wiki_table2 <- rbind(name_df, cleaned_table)

# Print wiki_table
wiki_table2

# Reproducibility

library(httr)
library(rvest)
library(xml2)

get_infobox <- function(title){
  base_url <- "https://en.wikipedia.org/w/api.php"
  
  # Change "Hadley Wickham" to title
  query_params <- list(action = "parse", 
                       page = title, 
                       format = "xml")
  
  resp <- GET(url = base_url, query = query_params)
  resp_xml <- content(resp)
  
  page_html <- read_html(xml_text(resp_xml))
  infobox_element <- html_node(x = page_html, css =".infobox")
  page_name <- html_node(x = infobox_element, css = ".fn")



#---------------------------------------------------------------

# Construct a directory-based API URL to `http://swapi.co/api`,
# looking for person `1` in `people`
directory_url <- paste("http://swapi.co/api", "people", "1", sep = "/")

# Make a GET call with it
result <- GET(directory_url)

# Create list with nationality and country elements
query_params <- list(nationality = "americans", 
                     country = "antigua")

# Make parameter-based call to httpbin, with query_params
parameter_response <- GET("https://httpbin.org/get", query = query_params)

# Print parameter_response
parameter_response

#---------------------------------------------------------------

# Using user agents
# Informative user-agents are a good way of being respectful of the developers running the API you're interacting with. 
# They make it easy for them to contact you in the event something goes wrong. I always try to include:
## My email address;
## A URL for the project the code is a part of, if it's got a URL.

# Do not change the url
url <- "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents/Aaron_Halfaker/daily/2015100100/2015103100"

# Add the email address and the test sentence inside user_agent()
server_response <- GET(url, user_agent("my@email.address this is a test"))

# Rate-limiting
# The next stage of respectful API usage is rate-limiting: making sure you only make a certain number of requests to the server in a given time period. 
# Your limit will vary from server to server, but the implementation is always pretty much the same and involves a call to Sys.sleep(). 
# This function takes one argument, a number, which represents the number of seconds to "sleep" (pause) the R session for. 
# So if you call Sys.sleep(15), it'll pause for 15 seconds before allowing further code to run.


# Construct a vector of 2 URLs
urls <- c("http://httpbin.org/status/404",
          "http://httpbin.org/status/301")

for(url in urls){
  # Send a GET request to url
  result <- GET(url)
  # Delay for 5 seconds between requests
  Sys.sleep(5)
}

# Tying it all together
get_pageviews <- function(article_title){
  url <- paste(
    "https://wikimedia.org/api/rest_v1/metrics/pageviews/per-article/en.wikipedia/all-access/all-agents", 
    article_title, 
    "daily/2015100100/2015103100", 
    sep = "/"
  )   
  response <- GET(url, user_agent("my@email.com this is a test")) 
  # Is there an HTTP error?
  if(http_error(response)){ 
    # Throw an R error
    stop("the request failed") 
  }
  # Return the response's content
  content(response)
}
#---------------------------------------------------------------

# working with JSON files (for more information see: www.json.org)
# While JSON is a useful format for sharing data, your first step will often be to parse it into an R object, so you can manipulate it with R.

# Get revision history for "Hadley Wickham"
resp_json <- rev_history("Hadley Wickham")

# Check http_type() of resp_json
http_type(resp_json) # confirm the API returned a JSON object

# Examine returned text with content()
content(resp_json, as = "text")

# Parse response with content()
content(resp_json, as = "parsed")

# Parse returned text with fromJSON()
library(jsonlite)
fromJSON(content(resp_json, as = "text"))

# Manipulating parsed JSON
# Load rlist
library(rlist)

# Examine output of this code
str(content(resp_json), max.level = 4)

# Store revision list
revs <- content(resp_json)$query$pages$`41916270`$revisions

# Extract the user element
user_time <- list.select(revs, user, timestamp)

# Print user_time
user_time 

# Stack to turn into a data frame
list.stack(user_time)

# Load dplyr
library(dplyr)

# Pull out revision list
revs <- content(resp_json)$query$pages$`41916270`$revisions

# Extract user and timestamp
revs %>%
  bind_rows() %>%
  select(user, timestamp)

#---------------------------------------------------------------
# working with XML files
# Just like JSON, you should first verify the response is indeed XML with http_type() 
# and by examining the result of content(r, as = "text"). 
# Then you can turn the response into an XML document object with read_xml()

# Load xml2
library(xml2)

# Get XML revision history
resp_xml <- rev_history("Hadley Wickham", format = "xml")

# Check response is XML
http_type(resp_xml)

# Examine returned text with content()
rev_text <- content(resp_xml, as = "text")
rev_text

# Turn rev_text into an XML document
rev_xml <- read_xml(rev_text)

# Examine the structure of rev_xml
xml_structure(rev_xml)



# Extracting XML data
# Find all nodes using XPATH "/api/query/pages/page/revisions/rev"
xml_find_all(rev_xml, "/api/query/pages/page/revisions/rev")

# Find all rev nodes anywhere in document
rev_nodes <- xml_find_all(rev_xml, "//rev")

# Use xml_text() to get text from rev_nodes
xml_text(rev_nodes)

# Extracting XML attributes
# All rev nodes
rev_nodes <- xml_find_all(rev_xml, "//rev")

# The first rev node
first_rev_node <- xml_find_first(rev_xml, "//rev")

# Find all attributes with xml_attrs()
xml_attrs(first_rev_node)

# Find user attribute with xml_attr()
xml_attr(first_rev_node, "user")

# Find user attribute for all rev nodes
xml_attr(rev_nodes, "user")

# Find anon attribute for all rev nodes
xml_attr(rev_nodes, "anon")

# returning nice API output
get_revision_history <- function(article_title){
# Get raw revision response
rev_resp <- rev_history(article_title, format = "xml") }
  
# Turn the content() of rev_resp into XML
rev_xml <- read_xml(content(rev_resp, "text"))
  
# Find revision nodes
rev_nodes <- xml_find_all(rev_xml, "//rev")
  
# Parse out usernames
user <- xml_attr(rev_nodes, "user")
  
# Parse out timestamps
timestamp <- readr::parse_datetime(xml_attr(rev_nodes, "timestamp"))
  
# Parse out content
content <- xml_text(rev_nodes)
  
#---------------------------------------------------------------
  
# web scraping 101
# The first step with web scraping is actually reading the HTML in. 
# This can be done with a function from xml2, which is imported by rvest - read_html(). 
# This accepts a single URL, and returns a big blob of XML that we can use further on.
  
# Load rvest
library(rvest)
  
# Hadley Wickham's Wikipedia page
test_url <- "https://en.wikipedia.org/wiki/Hadley_Wickham"
  
# Read the URL stored as "test_url" with read_html()
test_xml <- read_html(test_url)
  
# Print test_xml
test_xml

#html_node(), which extracts individual chunks of HTML from a HTML document. 
# There are a couple of ways of identifying and filtering nodes, and for now we're going to use XPATHs: 
# unique identifiers for individual pieces of a HTML document.

# Use html_node() to grab the node with the XPATH stored as `test_node_xpath`
node <- html_node(x = test_xml, xpath = test_node_xpath)

# Print the first element of the result
node[[1]]

# Extract the name of table_element
element_name <- html_name(table_element)

# Print the name
element_name

# Extract the element of table_element referred to by second_xpath_val and store it as page_name
page_name <- html_node(x = table_element, xpath = second_xpath_val)

# Extract the text from page_name
page_title <- html_text(page_name)

# Print page_title
page_title


# Turn table_element into a data frame and assign it to wiki_table
wiki_table <- html_table(table_element)

# Print wiki_table
wiki_table

# Cleaning a data frame
# Rename the columns of wiki_table
colnames(wiki_table) <- c("key", "value")

# Remove the empty row from wiki_table
cleaned_table <- subset(wiki_table, !key == "")

# Print cleaned_table
cleaned_table

#---------------------------------------------------------------

# CSS web scraping 
# CSS is a way to add design information to HTML, that instructs the browser on how to display the content. 
# You can leverage these design instructions to identify content on the page.


# Select the table elements
html_nodes(test_xml, css = "table")

# Select elements with class = "infobox"
html_nodes(test_xml, css = ".infobox")

# Select elements with id = "firstHeading"
html_nodes(test_xml, css = "#firstHeading")

# Extract element with class infobox
infobox_element <- html_nodes(test_xml, css = ".infobox")

# Get tag name of infobox_element
element_name <- html_name(infobox_element)

# Print element_name
element_name

# Extract element with class fn
page_name <- html_node(x = infobox_element, css = ".fn")

# Get contents of page_name
page_title <- html_text(page_name)

# Print page_title
page_title
  