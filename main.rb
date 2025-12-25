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

# インサート
# 方法1
# user = User.new
# user.name = "Alice"
# user.age = 30
# user.save

# 方法2
# user = User.new(name: "Bob", age: 25)
# user.save

# 方法3
# User.create(name: "Charlie", age: 28)

# 方法4
user = User.new do |u|
  u.name = "Brian"
  u.age = 22
end
user.save # user = User.create do |u| の場合は不要