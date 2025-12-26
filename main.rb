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

User.delete_all # 既存データ削除
User.connection.execute("DELETE FROM sqlite_sequence WHERE name='user'") # オートインクリメントのリセット（sqlite_sequenceはSQLite固有） [memo] connection.executeはMySQLやPostgressqlなどのDBでも使える

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
# pp User.select("id, name, age").all # カラム指定して取得・表示

# selectの中はシンボルでも可
# pp User.select(:id, :name, :age).first # カラム指定して1件目を取得・表示
# pp User.select(:id, :name, :age).last # カラム指定して最終件を取得・表示
# pp User.select(:id, :name, :age).first(3) # カラム指定して最初から3件分を取得・表示

# idでの検索
# pp User.find(2) # id=2のレコードを取得・表示
# pp User.select(:id, :name, :age).find(3) # id=3のレコードをカラム指定して取得・表示

# id以外での検索
# pp User.find_by(name: "Manson") # nameがMansonのレコード
# pp User.find_by name: "Manson" # 上記と同じで引数の括弧は省略可能
# pp User.find_by_name("Manson") # 上記と同じで動的メソッドを使用

# pp User.find_by_name!("Manson") # nameがMansonのレコード。見つからない場合は例外を発生させる
# pp User.find_by_name! "tanaka" # !マーク付きメソッドで例外発生させる

# whereメソッドでの検索
# pp User.select(:id, :name, :age).where(age: 25) # ageが25のレコードを配列で取得・表示
# pp User.select(:id, :name, :age).where(age: 22..29) # ageが22〜29のレコードを配列で取得・表示
# pp User.select(:id, :name, :age).where(age: [22, 30]) # ageが22または30のレコードを配列で取得・表示

# and検索
# pp User.select(:id, :name, :age).where("age >= 25").where("age <= 30") # ageが25以上かつ30以下のレコードを配列で取得・表示 つまりwhere(age: 22..30) と同じ
# pp User.select(:id, :name, :age).where("age >= 25 and age <= 30") # 上記と同じ

# or検索
# pp User.select(:id, :name, :age).where("age <= 25 or age >= 30") # 上記と同じ
# pp User.where("age <= 25").or(User.where("age >= 30")).select(:id, :name, :age) # 上記と同じ（selectを最後に持ってきて、冗長を避けるパターン）

# NOT検索
pp User.select(:id, :name, :age).where.not(id: 3) # idが3以外のレコードを配列で取得・表示