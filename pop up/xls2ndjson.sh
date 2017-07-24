#! /bin/bash
shp2json ne_50m_admin_0_countries.shp -o world.json
geoproject 'd3.geoEquirectangular().rotate([100,0]).center([-50,0]).fitSize([1800,900],d)' < world.json | ndjson-split 'd.features' | ndjson-map 'd.id = d.properties.iso_a2, d' > world-project.ndjson
ndjson-map '{id :d.id, count: 0}' < world-project.ndjson > count.ndjson
for dir in *.xls
do
json-cli $dir $dir.json
ndjson-split < $dir.json | ndjson-map 'd.pubcountry = d["Publication number"].slice(0,2), d' | jq 'map({id: .pubcountry}) | group_by(.id) | map({id: .[].id, count: length}) | unique' > c$dir.ndjson
done
cat c*.ndjson | jq '.[]' | jq -s . | jq 'group_by(.id) | .[] | (map(.count) | add) as $sum | first | .count = $sum' | jq -c '.' > ready.ndjson
rm c*.ndjson
ndjson-join 'd.id' world-project.ndjson ready.ndjson | ndjson-map -r d3=d3-array 'd[0].properties = {density: d[1].count, densityscale: d3.bisect([1,10,50,200,500,1000,2000,4000],(d[1].count))}, d[0]' > world-project1.ndjson
ndjson-join 'd.id' world-project1.ndjson code.ndjson | ndjson-map 'd[0].properties.country = d[1].Country, d[0]' | ndjson-map -r d3=d3-scale-chromatic '(d.properties.fill = d3.schemeYlGnBu[9][d.properties.densityscale], d)' > world.ndjson
geo2topo -n counties=world.ndjson > topo.json
rm world-*.ndjson
 
