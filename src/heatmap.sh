shp2json ne_50m_admin_0_countries.shp -o world.json
geoproject 'd3.geoEquirectangular().rotate([100,0]).center([-50,0]).fitSize([1800,900],d)' < world.json > world-project.json
ndjson-split 'd.features' < world-project.json > world-project.ndjson
ndjson-map 'd.id = d.properties.iso_a2, d' < world-project.ndjson > world-project1.ndjson
ndjson-join 'd.id' world-project1.ndjson count_final.ndjson > x.ndjson
ndjson-map -r d3=d3-array 'd[0].properties = {density: d3.bisect([1,10,50,200,500,1000,2000,4000],(d[1].Count))}, d[0]' < x.ndjson >xx.ndjson
ndjson-map -r d3=d3-scale-chromatic '(d.properties.fill = d3.schemeYlGnBu[9][d.properties.density], d)' < xx.ndjson > xxx.ndjson
geo2svg -n --stroke '#CCC' -p 1 -w 1800 -h 900 < xxx.ndjson > xxx1800.svg   


#For interactive
ndjson-map -r d3=d3-array 'd[0].properties = {densityscale: d3.bisect([1,10,50,200,500,1000,2000,4000],(d[1].Count)),density: d[1].Count}, d[0]' < x.ndjson >xx.ndjson
geo2topo -n counties=xx.ndjson > topo.json
