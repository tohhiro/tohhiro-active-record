require "active_record"
require "active_support/time"
require "pp"
require "logger"

Time.zone_default = Time.find_zone! "Asia/Tokyo"

ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "./myapp.db"
)

class User < ActiveRecord::Base
    self.table_name = "user" # テーブル名が規約に従っていない場合に指定
end

# User.delete_all # 既存データ削除

# インサート
# 方法1
user = User.new
user.name = "Henry"
user.age = 30
user.save

# 方法2
user = User.new(name: "Carol", age: 25)
user.save

# 方法3
User.create(name: "Manson", age: 28)

# 方法4
user = User.new do |u|
  u.name = "Kart"
  u.age = 22
end
user.save # user = User.create do |u| の場合は不要

# # pp User.all # 全件全カラムを取得して表示
pp User.select("id, name, age").all # カラム指定して取得・表示

# selectの中はシンボルでも可
pp User.select(:id, :name, :age).first # カラム指定して1件目を取得・表示
pp User.select(:id, :name, :age).last # カラム指定して最終件を取得・表示
pp User.select(:id, :name, :age).first(3) # カラム指定して最初から3件分を取得・表示