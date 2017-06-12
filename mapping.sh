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


