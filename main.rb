require "active_record"
require "active_support/time"
require "pp"

Time.zone_default = Time.find_zone! "Asia/Tokyo"

ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: "./myapp.db"
)

class User < ActiveRecord::Base
end

# インサート
# 方法1
user = User.new
user.name = "Alice"
user.age = 30
user.save

# 方法2
user = User.new(name: "Bob", age: 25)
user.save

# 方法3
User.create(name: "Charlie", age: 28)