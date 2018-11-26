# はじめに
bundle install
rails g devise:install
rails db:create
rails db:migrate
bundle exec rake db:migrate
rake db:seed


# DB設計

## 1.Usersテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false, unique: true|
|name|string|null: false, unique: true|
|e-mail|string|null: false, unique: true|
|age|integer|年齢|
|gender|integer|性別(0:男性,1:女性)|
|weight|integer|体重(kg)|


### Association
- has_many :records

## 2.Recordsテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false, unique: true|
|user_id|integer|null: false, foreign_key: true|
|start_station_id|integer|null: false, スタートに設定した駅のid|
|goal_station_id|integer|null: false, ゴールに設定した駅のid|
|opponent|string|null: false, 対戦相手に設定した列車の列番号|
|consumed_calory|integer|消費したカロリー(kcal)|
|running_time|integer|走行時間(m)|
|result|integer|勝敗(0:勝利, 1:敗北)|

### Association
- belongs_to :user

## 3.Stationsテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false, unique: true|
|name_ja|string|null: false, 駅名(日本語)|
|name_en|string|null: false, 駅名(英語)|

### Association


