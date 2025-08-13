# Page Title Scraper
A bash script to scrape page titles from a list of URLs.

## How to Use
First you'll need to create a `.txt` file that lists out all the URLs you want to scrape. Ensure that there is only one URL per line like so:
```
https://www.website.com/
https://www.website.com/page
https://www.website.com/page2
```
Download `scrape_page_titles.sh` by cloning this repository or copying and pasting the file into vim or your favorite code editor. Navigate to the folder where it lives, and run the following command:
```
./scrape_page_titles.sh urls.txt output.csv
```
Where `urls.txt` is the name and path of the file containing the list of URLs and `output.csv` is whatever you want the outputted file name to be.
