#!/bin/bash
#csv2json < xxx.csv > xxx.json #csv to json.
#sed '1d' xxx.json | sed '$ d' | sed 's/,$//' > xxx.ndjson 
json-cli xxx.xls xxx.json
ndjson-split < xxx.json | ndjson-map 'd.pubcountry = d["Publication number"].slice(0,2), d' > xxxpubcountry.ndjson
#ndjson-map 'd.pubcountry' < xxxpubcountry.ndjson | awk ' \  
#BEGIN {print "{" }  \  
# { dictionary[$0]++ }  \ 
#END { \
#	counter= 0; \ 
#	for (d in dictionary) { \
#		counter++; \
#		if (counter < length(dictionary)) { \
#			printf "%s: %s,\n", d, dictionary[d]; \ 
#		} else { \
#			printf "%s: %s\n", d, dictionary[d] \ 
#		} \
#	}; \
#	print "}" \
#}' > country.json 
#ndjson-map '{Title: d.Title, PubNo: d["Publication number"], pubdate: d["Publication date"], pubcountry: d.pubcountry}' < xxxpubcountry.ndjson > final.ndjson #Extract useful items from json..
#csv2json < all.csv > code.json
#csv2json < location.csv > location.json
#sed '1d' location.json | sed '$ d' | sed 's/,$//' > location.ndjson
#ndjson-map 'd.pubcountry = d.country, d' < location.ndjson > loc.ndjson
ndjson-join 'd.pubcountry' xxxpubcountry.ndjson loc.ndjson | ndjson-map 'd[0].latitude = d[1].latitude, d[0].longtude = d[1].longitude, d[0]' | jq '.[]' > xxx-join.ndjson
#ndjson-reduce | ndjson-map > xxxloc.json

#jq '.[]' xxx.json is equavalent to jq '.' xxx.ndjson. Both return a well formatted like-ndjson file. 
