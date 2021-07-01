# OUAppStoreRankings

Open University - The Netherlands

Software to support for MSc Software Engineer thesis, "Do iOS applications respects your privacy? A case study on popular iPhone apps in Belgium." by Jelle De Laender.

## Intro

This software helps in collecting and generating the top list for applications in the Belgian Apple Top store.
This project is written in Ruby and exists in multiple smaller projects.

### Generating Top Lists

An SQLLite database is the main local storage. By default, the "OURanking.sqlite" is used. Optionally a different database can be defined.

Usage:
`ruby rankings.rb <number_of_days> <optional: Clear database {true/false}> <optional: DB Location>`

This script can be executed by one parameter, defining the time interval in past days that need to be downloaded and added or updated to the local database. Using number 1 will download the top list of today and process this data and add this data to the database. 3 will process the last 3 days including today and so on.

The second parameter is an optional boolean which is default `false`. This boolean can be set to true if the local database needs to be cleared before the new data is processed and added.

The third and last parameter is the path to the local database. This is default `OURanking.sqlite`

By having a cronjob that runs `ruby rankings.rb 1` multiple times a day will result in a dataset that is always up to date.

### Top Lists

Once the database is filled, the top list script can be used to analyse the database.

Usage:
`ruby toplist.rb <free/paid/grossing> <iphone/ipad/all> <optional:limit> <optional:DB Location>`

There are 2 required parameters.

The first one is free, paid, or grossing. This filters the dataset based on the type of top list.
Grossing can contain free apps that have optional InApp payments embedded.

The second parameter allows filtering on iPhone top lists, iPad top lists, or the combination of both.

The third and optional parameter can be used to set a limit to the results. The default limit is 50. By defining the limit to 10, the top 10 can be generated.

The last parameter is the path to the local database. This is by default `OURanking.sqlite` 

### App Info

The App Info script can be used to get all the top list information of a given App ID.

Usage:
`ruby toplist.rb <appid> <optional:DB Location>`

The required parameter is the AppID as used in the App Store by Apple.

The optional parameter is the local database. This is by default `OURanking.sqlite` 

## Database

SQLite is used for local storage and database. The structure is defined in `apps.sql` 

A new database can be created by making a new SQLite database and executing this SQL file.

The database structure exists of one table with all metadata. Each record represents an app on a given day in the top list.
Constraints are used to ensure the integrity of the database, as a combination of the date, app_id, category, and type of device.
Indexes are used to ensure efficient search and analytic operations.

Saved medata is:

- "date" text(10,0) NOT NULL,
- "app_id" INTEGER(11,0) NOT NULL,
- "category" TEXT,
- "device" TEXT,
- "rank" INTEGER(11,0),
- "name" TEXT(500,0) NOT NULL,
- "version" TEXT(20,0),
- "rating" real,
- "rating_for_current_version" real,
- "rating_count" INTEGER,
- "rating_count_for_current_version" INTEGER,
- "canonical_country" TEXT(2,0),
- "categories" TEXT(500,0),
- "url" TEXT(2038,0),
- "support_url" TEXT,
- "website_url" TEXT,
- "privacy_policy_url" TEXT,
- "eula_url" TEXT,
- "release_date" TEXT,
- "updated_date" TEXT,
- "humanized_worldwide_last_month_downloads" INTEGER(11,0),
- "humanized_worldwide_last_month_revenue" INTEGER(11,0),
- "price" real,
- "in_app_purchases" integer,
- "shows_ads" integer,
- "buys_ads" integer,
- "apple_watch_enabled" integer,
- "imessage_enabled" integer,
- "icon_url" text,

### Default datasets

There is a default dataset with data of 1 May up to 31 July 2020 that can be used to be processed.
A database of 1 April up to 30 June 2021 is available.

## Definition of popular apps

Apple is providing top lists which reflect the current moment. The exact definition and algorithm used by Apple is unknown and kept as a secret, but based on factors like the number of recent downloads, ratings by users, usage data like how long apps are used, how quickly apps are removed again, number of launches a day, etc.

Our objective is to make a list of popular applications over a longer time. As the list provided by Apple and other sources are only showing snapshots of the top list, a small algorithm was defined.

Some applications can be on the top list in a very good position like the top 5 but only for a couple of days due to media attention, while other applications can be in the 20th place but for a month. Which application is more popular?

The initial idea was to calculate a score, based on the position and improving the score based on every day the app is listed in the top list. This idea was iterated, refined, and simplified to the following definition:

We started by defining a `popularity` score. The lower, the more popular we define the application. As a start, we are using the average position of the app in the top lists of the period in scope. On top of this, we divide this number by the number of days the app is on the top list.

This results in a balance of one app being on top 1 for 1 day, and an app on being the third position but for at least 3 days.

`SELECT '' as ind, name, MIN(rank) AS min_position, printf('%.3f', AVG(rank)) AS average_position, MAX(rank) AS max_position, count(*) AS number_of_days, printf('%.3f', AVG(rank) / count(*)) AS popularity, app_id FROM apps WHERE category = 'free' GROUP BY app_id ORDER BY popularity ASC LIMIT 50`

This algorithm can be more refined by taking more aspects into account:
- Ratings: Improving the popularity score for apps with an excellent rating. The question is however to which extent the rating influence the popularity. A rating reflects on the user experience and quality, which indirectly will have an impact on the popularity of the app. As this is taken into account indirectly by the top-list position, this factor was excluded from the algorithm
- Number of periods and durations the app is in the top list: An app that is in the top list for a full week without any interruptions will be considered more popular than an app that managed to be listed 7 times for a shorter time over a longer period. This is left for future work and out of scope for now.

## Disclaimer

The current data source used is the public API of SensorTower. This API is publicly available and data is updated multiple times a day.
There is an active rate limit.
