/*
 Navicat Premium Data Transfer

 Source Server         : OURanking
 Source Server Type    : SQLite
 Source Server Version : 3012001
 Source Database       : main

 Target Server Type    : SQLite
 Target Server Version : 3012001
 File Encoding         : utf-8

 Date: 07/31/2020 00:41:47 AM
*/

PRAGMA foreign_keys = false;

-- ----------------------------
--  Table structure for apps
-- ----------------------------
DROP TABLE IF EXISTS "apps";
CREATE TABLE "apps" (
	 "date" text(10,0) NOT NULL,
	 "app_id" INTEGER(11,0) NOT NULL,
	 "category" TEXT,
	 "device" TEXT,
	 "rank" INTEGER(11,0),
	 "name" TEXT(500,0) NOT NULL,
	 "version" TEXT(20,0),
	 "rating" real,
	 "rating_for_current_version" real,
	 "rating_count" INTEGER,
	 "rating_count_for_current_version" INTEGER,
	 "canonical_country" TEXT(2,0),
	 "categories" TEXT(500,0),
	 "url" TEXT(2038,0),
	 "support_url" TEXT,
	 "website_url" TEXT,
	 "privacy_policy_url" TEXT,
	 "eula_url" TEXT,
	 "release_date" TEXT,
	 "updated_date" TEXT,
	 "humanized_worldwide_last_month_downloads" INTEGER(11,0),
	 "humanized_worldwide_last_month_revenue" INTEGER(11,0),
	 "price" real,
	 "in_app_purchases" integer,
	 "shows_ads" integer,
	 "buys_ads" integer,
	 "apple_watch_enabled" integer,
	 "imessage_enabled" integer,
	 "icon_url" text,
	CONSTRAINT "Unique combination per ranking" UNIQUE ("date" ASC, "app_id" ASC, "category" ASC, "device" ASC)
);

-- ----------------------------
--  Indexes structure for table apps
-- ----------------------------
CREATE INDEX "Date index" ON apps ("date" ASC);
CREATE INDEX "Category index" ON apps ("categorie" ASC);
CREATE INDEX "Device Index" ON apps ("device" ASC);

PRAGMA foreign_keys = true;
