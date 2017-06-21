csv2json < xxx.csv > xxx.json #csv to json.
sed '1d' xxx.json | sed '$ d' > xxxx.json  
sed 's/,$//' xxxx.json > xxx.ndjson 
ndjson-map 'd.pubcountry = d["Publication number"].slice(0,2), d' < xxx.ndjson > xxxpubcountry.ndjson
ndjson-map 'd.pubcountry' < xxxpubcountry.ndjson | awk ' \  
BEGIN {print "{" }  \  
{ dictionary[$0]++ }  \ 
END { \
	counter= 0; \ 
	for (d in dictionary) { \
		counter++; \
		if (counter < length(dictionary)) { \
			printf "%s: %s,\n", d, dictionary[d]; \ 
		} else { \
			printf "%s: %s\n", d, dictionary[d] \ 
		} \
	}; \
	print "}" \
}' > country.json 
ndjson-map '{Title: d.Title, PubNo: d["Publication number"], pubdate: d["Publication date"], pubcountry: d.pubcountry}' < xxxpubcountry.ndjson > final.ndjson #Extract useful items from json..
csv2json < all.csv > code.json
csv2json < location.csv > location.json
sed '1d' location.json | sed '$ d' | sed 's/,$//' > location.ndjson
ndjson-map 'd.pubcountry = d.country, d' < location.ndjson > loc.ndjson
ndjson-join 'd.pubcountry' xxxpubcountry.ndjson loc.ndjson > join.ndjson
ndjson-map 'd[0].latitude = d[1].latitude, d[0].longtude = d[1].longitude, d[0]' < join.ndjson > xxxloc.ndjson
ndjson-reduce < xxxloc.ndjson | ndjson-map > xxxloc.json
jq '.[]' xxxloc.json > xxx-join.ndjson
