## DEMO

Iframe page
[http://adsimple.mgyk.net/index.html](http://adsimple.mgyk.net/index.html)

Available ads

12356, 23456

Report page

[http://adsimple.mgyk.net/report.html](http://adsimple.mgyk.net/report.html)

## REQUIREMENTS

tested with ruby 1.9.2, mysql2, sinatra

## SETUP

bundle install

mv config/db_sample.yaml config/db.yaml

edit config/db.yaml

rake db:setup

## RUN

`thin -r adsimple.ru`

## Customizations

edit config/ads.yaml

## Report

/report.html or /report.csv
