# DB設計

## 1.usersテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false, unique: true|
|name|string|null: false, unique: true|
|e-mail|string|null: false, unique: true|
|limit_post|integer||
|limit_like|integer||

### Association
- has_many :posts
- has_many :supporters
- has_many :routes, through: :supporters

## 2.postsテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false, unique: true|
|body|text||
|image|string|null: false|
|user_id|integer|null: false, foreign_key: true|
|route_id|integer|null: false, foreign_key: true|
|be_liked|integer||


### Association
- belongs_to :user
- belongs_to :route

## 3.routesテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false, unique: true|
|name|string|null: false|
|rank|integer||

### Association
- has_many :posts
- has_many :supporters
- has_many :users, through: :supporters

## 4.supportersテーブル

|Column|Type|Options|
|------|----|-------|
|id|integer|null: false, unique: true|
|user_id|integer|null: false, foreign_key: true|
|route_id|integer|null: false, foreign_key: true|

### Association
- belongs_to :route
- belongs_to :user
