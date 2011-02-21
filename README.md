## DEMO

Iframe page
[[http://adsimple.mgyk.net/index.html]]

Report page
[[http://adsimple.mgyk.net/report.html]]

## REQUIREMENTS
tested with ruby 1.9.2
## SETUP

bundle install

mv config/db_sample.yaml config/db.yaml

edit config/db.yaml

rake setup

## RUN

`thin -r adsimple.ru`

## Customization

edit config/ads.yaml

## Report

/report.html or /report.csv
