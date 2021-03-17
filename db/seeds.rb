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
@user.build_profiles(age: 25, sex: true, height: 173, target_weight: 65, action_level: 1.25, notes: "コンビニメイン")
@user.save
@user2 = User.create(name: "bibi",
                    email: "bi@gmail.com",
                    password: "11111111",)
@user2.image.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'user_default.png')), filename: 'user_default.png', content_type: 'image/png')
@user2.back_ground.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'photo4.jpg')), filename: 'photo4.jpg', content_type: 'image/jpg')
@user2.build_profiles(age: 29, sex: true, height: 164, target_weight: 55, action_level: 1.25, notes: "コンビニメイン")
@user2.save