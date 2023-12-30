#!/usr/bin/bash

# get geo
wget https://file.iriswo.com/geo/geoip-cn.db -O geoip-cn.db
wget wget https://file.iriswo.com/geo/geosite.db -O geosite.db

# n
geosites=(category-dev category-pt category-games@cn category-media category-porn cn geolocation-cn google openai)
geoips=(cn jp netflix bilibili)

# export

for site in ${geosites[*]}
do
    echo "site: $site"
    ./sing-box geosite export  -f geosite.db -o source/geosite-$site.json $site
done

for site in ${geoips[*]}
do
    echo "ip: $site"
    ./sing-box geoip export  -f geoip-cn.db -o source/geoip-$site.json $site
done

# build

srs=$(ls source/*.json | sed 's/source\///g')

for sr in $srs
do
    echo "build: $sr"
    name=$(echo $sr | sed 's/.json//g')
    ./sing-box rule-set compile source/$sr -o binary/$name.srs
done
