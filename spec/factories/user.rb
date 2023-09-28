# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence :email do |n|
      "user_#{n}@example.com"
    end
    name { 'テスト 太郎' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
