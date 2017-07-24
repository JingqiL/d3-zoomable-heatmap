#! /bin/bash
json-cli $dir $dir.json
ndjson-split < $dir.json | ndjson-map 'd.pubcountry = d["Publication number"].slice(0,2), d' > xxxpubcountry.ndjson
ndjson-join 'd.pubcountry' xxxpubcountry.ndjson loc.ndjson | ndjson-map 'd[0].latitude = d[1].latitude, d[0].longtude = d[1].longitude, d[0]' | jq '.' > $dir.ndjson
