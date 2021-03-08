# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
@user = User.create(name: "koda",
                    email: "kodakoda@gmail.com",
                    password: "11111111",)
@user.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'user_default.png')), filename: 'user_default.png', content_type: 'image/png')
@user.back_ground.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'photo4.jpg')), filename: 'photo4.jpg', content_type: 'image/jpg')
@user.build_profiles(notes: "コンビニメイン")
@user.save
@user = User.create(name: "bibi",
                    email: "bi@gmail.com",
                    password: "11111111",)
@user.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'user_default.png')), filename: 'user_default.png', content_type: 'image/png')
@user.back_ground.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'photo4.jpg')), filename: 'photo4.jpg', content_type: 'image/jpg')
@user.build_profiles(notes: "レストラン")
@user.save