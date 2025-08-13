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

### Note
There is currently a 0.5s delay in between requests to ensure we're not constantly pinging servers. If you want to change the delay in between requests, you can update this line:
```
sleep 0.5
```
You can change it to a higher number for a longer delay or a lower number for a shorter delay. For large lists, avoid removing this or setting it to 0, as it could raise security concerns from servers. (it's also low-key disrespectful)
