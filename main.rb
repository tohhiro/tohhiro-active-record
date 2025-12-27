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

    # クラスメソッドでtop3を抽出する例
    # def self.top3
    #     select(:id, :name, :age).order(age: :asc).limit(3)
    # end
    # 引数を取るクラスメソッドの例
    # def self.age_greater_than(min_age)
    #     select(:id, :name, :age).where("age > ?", min_age)
    # end

    # scopeを使ってtop3を抽出する例
    # scope :top3, -> { select(:id, :name, :age).order(age: :asc).limit(3) }  
    # 引数を取るscopeの例
    scope :age_greater_than, ->(min_age) { select(:id, :name, :age).where("age > ?", min_age) }
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
# pp User.select(:id, :name, :age).where.not(id: 3) # idが3以外のレコードを配列で取得・表示

# プレースホルダを使った検索（SQLインジェクション対策）
# min = 25
# max = 30
# # pp User.select(:id, :name, :age).where("age >= ? and age <= ?", min, max) # ageが25以上かつ30以下のレコードを配列で取得・表示
# pp User.select(:id, :name, :age).where("age >:min and age <= :max", {min: min, max: max}) # 上記と同じ
# pp User.select(:id, :name, :age).where("age >= #{min} and age <= #{max}") # NGパターン（SQLインジェクションの危険性あり）

# LIKE検索
# pp User.select(:id, :name, :age).where("name LIKE ?", "%an%") # nameに'an'を含むレコードを配列で取得・表示f

# ORDER BY
# pp User.select(:id, :name, :age).order(age: :asc) # age昇順で取得・表示
# pp User.select(:id, :name, :age).order(age: :desc) # age降順で取得・表示

# LIMIT
# pp User.select(:id, :name, :age).order(age: :asc).limit(2) # age昇順で上位2件を取得・表示

# OFFSET
# pp User.select(:id, :name, :age).order(age: :asc).limit(2).offset(1) # age昇順で上位2件をスキップして取得・表示

# クラスメソッドで定義したtop3を実行して表示
# pp User.top3 # クラスメソッドtop3を実行して表示
# pp User.age_greater_than(25) # ageが25より大きいレコードを取得・表示

# scopeで定義したtop3を実行して表示（memo: scopeの方がメソッドチェーンで使いやすい）
# pp User.top3 # scopeで定義したtop3を実行して表示（クラスメソッド版と同じ書き方、結果）
# pp User.age_greater_than(25) # scopeで定義したage_greater_thanを実行して表示（クラスメソッド版と同じ書き方、結果）

# find_or_create_byメソッド（レコードが存在しなければ作成）
user = User.find_or_create_by(name: "Alice") do |u|
    u.age = 27
end
pp user