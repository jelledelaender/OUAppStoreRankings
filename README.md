# OUAppStoreRankings

Open University - The Netherlands
Software to support for MSc Software Engineer thesis, "Do iOS applications respect your privacy? A case study on popular iPhone apps in Belgium."

## Intro

This software helps in collecting and generating top list for applications in the Belgian Apple Top store.
This project is written in Ruby and exist of multiple smaller projects.

### Generating Top Lists

An SQLLite database is the main local storage. By default the "OURanking.sqlite" is used. Optionally a different database can be defined.

Usage:
`ruby rankings.rb <number_of_days> <optional: Clear database {true/false}> <optional: DB Location>`

This script can be executed by one parameter, defining the time interval in past days that need to be downloaded and added or updated to the local database. Using number 1 will download the top list of today and process this data and add this data to the database. 3 will process the last 3 days including today and so on.

The second parameter is and optional boolean which is default `false`. This boolean can be set to true if the local database need to be cleared before the new data is processed and added.

The third and last parameter is the path to the local database. This is default `OURanking.sqlite`

By having a cronjob that runs `ruby rankings.rb 1` multiple times a day will result in a dataset that is always up to date.

### Top Lists

Once the database is filled, the top list script can be used to analyse the database.

Usage:
`ruby toplist.rb <free/paid/grossing> <iphone/ipad/all> <optional:limit> <optional:DB Location>`

There are 2 required parameters.

The first one is free, paid or grossing. This filters the dataset based on the type of toplist.
Grossing can contain free apps that have optional InApp payments embedded.

The second parameter allows to filter on iPhone toplists, iPad toplists or combination of both.

The third and optional parameter can be used to set a limit to the results. The default limit is 50. By defining the limit to 10, the top 10 can be generated.

The last parameter is the path to the local database. This is by default `OURanking.sqlite` 

### App Info

The App Info script can be used to get all top list information of a given App ID.

Usage:
`ruby toplist.rb <appid> <optional:DB Location>`

Required parameter is the AppID as used in the App Store by Apple.

Optional parameter is the local database. This is by default `OURanking.sqlite` 

## Database

SQLite is used for local storage and database. The structure is defined in `apps.sql` 

A new database can be created by making a new SQLite database and executing this SQL file.

The database structure exist of one table with all metadata. Each record represents an app on a given day in the top list.
Constraints are used to ensure the intrigity of the database, as combination on date, app_id, category and type of device.
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
