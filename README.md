# OUAppStoreRankings

Open University - The Netherlands

Software to support for MSc Software Engineer thesis, "Do iOS applications respects your privacy? A case study on popular iPhone apps in Belgium." by Jelle De Laender.

## Intro

This software helps collect and generate the top list of applications in the Belgian Apple Top store.
This project is written in Ruby and exists in multiple smaller files.

### Generating Top Lists

The "rankings.rb" script updates the database by downloading new top lists via the API and processing the results.

An SQLite database is the main local storage. By default, the "OURanking.sqlite" is used. Optionally a different database can be defined.

Usage:
`ruby rankings.rb <number_of_days> <optional: Clear database {true/false}> <optional: DB Location>`

This script can be executed by one parameter, defining the time interval in past days that need to be downloaded and added or updated to the local database.
Using number 1 will download the top list of today and process this data and add this data to the database.
3 will process the last three days, including today and so on.

The second parameter is an optional boolean which is default `false`.
This boolean can be set to true if the local database needs to be cleared before the new data is processed and added.

The third and last parameter is the path to the local database. This is default `OURanking.sqlite`

By having a cronjob that runs `ruby rankings.rb 1` daily will result in a dataset that is always up to date.

### Top Lists

Once the database exists with data, the top list script can be used to analyse the database and generate top lists.

Usage:
`ruby toplist.rb <free/paid/grossing> <iphone/ipad/all> <optional:limit> <optional:DB Location>`

There are two required parameters.

The first one is free, paid, or grossing. This filters the dataset based on the type of top list.
Grossing can contain free apps that have optional InApp payments embedded.

The second parameter allows filtering on iPhone top lists, iPad top lists, or the combination of both by using "all"

The third and optional parameter can be used to limit the results. The default limit is 50. By defining the limit to 10, the top 10 can be generated.

The last optional parameter is the path to the local database. This is by default `OURanking.sqlite` 

<img width="1074" alt="Screenshot 2023-03-20 at 11 20 19 PM" src="https://user-images.githubusercontent.com/75109/226478120-bb95c30e-38a1-4fd7-ba02-1900536b0ce7.png">

### App Info

The App Info script can get all the top list information of a given App ID.
The App ID can be retrieved via a top list as explained in previous section.

Usage:
`ruby toplist.rb <appid> <optional:DB Location>`

The required parameter is the AppID, as Apple uses in the App Store.

The optional parameter is the local database. This is by default `OURanking.sqlite` 

## Database

SQLite is used for local storage and database. The structure is defined in `apps.sql` 

A new database can be created by making a new SQLite database and executing this SQL file.

The database structure exists of one table with all metadata. Each record represents an app on a given day in the top list.
Constraints are used to ensure the integrity of the database, and are a combination of the date, app_id, category, and type of device.
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

There are three default datasets available.
One of 2020, containing data from 1 May up to 31 July.
There is also a dataset of 2021 and 2022, both containing data from 1 April up to 30 June.

## Definition of popular apps

Apple is providing top lists which reflect the current moment. The exact definition and algorithm used by Apple is unknown and kept as a secret, but is based on factors like the number of recent downloads, ratings by users, usage data like how long apps are used, how quickly apps are removed again, number of launches a day, etc.

Our objective is to list popular applications over a longer time. An algorithm was defined as the list provided by Apple, and other sources only show snapshots of the top list.

Some applications can be on the top list in a very good position, like the top 5, but are only for a couple of days in the list due to a spike of media attention, while other applications can be in the 20th place but for a month. Which application is more popular?

The initial idea was to calculate a score based on the position and improve the score based on every day the app is listed at the top. This idea was iterated, refined, and simplified to the following definition:

We started by defining a `popularity` score. The lower, the more popular we define the application.
As a start, we are using the average position of the app in the top lists of the period in scope.
To take into account how long an app is on the top list, we divide this number by the number of days the app is on the top list, as we consider applications that are multiple days in the app store more popular.

This results in a shared score for one app being in position 1 for one day and an app listed at the third position for three days.

```
SELECT
	name, MIN(rank) AS min_position,
	printf('%.3f', AVG(rank)) AS average_position,
	MAX(rank) AS max_position,
	count(*) AS number_of_days,
	printf('%.3f', AVG(rank) / count(*)) AS popularity,
	app_id
FROM apps WHERE category = 'free'
GROUP BY app_id
ORDER BY popularity
ASC LIMIT 50
```


This algorithm can be more refined by taking more aspects into account:
- Ratings: Improving the popularity score for apps with excellent ratings. The question is to which extent the rating should influence the popularity score. A rating reflects on the user experience and quality, which indirectly will have an impact on the popularity of the app. As this is taken into account indirectly by the top-list position, this factor was excluded from the algorithm
- Number of periods and durations the app is in the top list: Currently, we take into account how many days an app is in the data set. We don't check if those are random days or a longer period an application is listed without any interruptions. One app that is one full week in the top list could be considered more popular than an app with just 7 random days listed in the top list. This is left for future work and out of scope for now.

## Disclaimer

The current data source used is the public API of SensorTower. This API is publicly available and data is updated multiple times a day.
There is an active rate limit. The API structure can change any day.
