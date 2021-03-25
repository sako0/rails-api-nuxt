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
@user.build_profiles(age: 27, sex: false, height: 173, target_weight: 65, action_level: 1.5, notes: "コンビニメイン")
@user.save
@user2 = User.create(name: "bibi",
                     email: "bi@gmail.com",
                     password: "11111111",)
@user2.build_profiles(age: 29, sex: true, height: 164, target_weight: 55, action_level: 1.5, notes: "コンビニメイン")
@user2.save