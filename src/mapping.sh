#First install npm from https://nodejs.org/en/download/
curl 'http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip' -o ne_50m_admin_0_countries.zip
unzip -o ne_50m_admin_0_countries.zip
npm install -g shapefile
shp2json ne_50m_admin_0_countries.shp -o world.json
#This json is a ......First project it to svg to see how it looks like.
npm install -g d3-geo-projection
geoproject 'd3.geoEquirectangular().rotate([100,0]).center([-50,0])' < world.json > world-project.json
#Cylindrical Projections, rotate to make the map centered at USA and center to make the map shows in the center of screen.
geo2svg -w 1600 -h 800 < world-project.json > world-project.svg
#From now about pop-up information we are going to display on our website.#
csv2json < xxx.csv > xxx.json #csv to json.
sed '1d' xxx.json | sed '$ d' > xxxx.ndjson  #Remove the first line and the last line.
sed 's/,$//' xxxx.json > xxx.ndjson #Remove the last character of each line and make it as ndjson.
###If the json is an unnamed array that with lots of children objects in it, use jq to make it transfer to ndjson.
###Install jq package---commandline JSON processor. Installation follow "https://stedolan.github.io/jq/download/".
###jq '.[]' < xxx.json > xxx.ndjson 
###But this does not return an normal json object, it's just well-formatted and easy to read. Still need to explore its usage.
#Install ndjson-cli package---Command line tools for operating on newline-delimited JSON streams. Installation follow "https://github.com/mbostock/ndjson-cli".
ndjson-map 'd.pubcountry = d["Publication number"].slice(0,2), d' < xxx.ndjson > xxxpubcountry.ndjson #Extract the country information from our content.



