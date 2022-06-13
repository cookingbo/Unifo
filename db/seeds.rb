# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Admin.create(email: "admin@admin.co.jp", password: "123456")
Tag.create([
  {name: '留学'},
  {name: '学部'},
  {name: '交換'},
  {name: '英語'},
  {name: '語学'},
  {name: '北アメリカ'},
  {name: '南アメリカ'},
  {name: 'アジア'},
  {name: 'オセアニア'},
  {name: 'アフリカ'},
  {name: 'ヨーロッパ'}
])