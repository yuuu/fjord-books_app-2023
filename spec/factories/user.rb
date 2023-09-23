# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    email { 'user@example.com' }
    name { 'テスト 太郎' }
    password { 'password' }
    password_confirmation { 'password' }
  end

  factory :other_user, class: User do
    email { 'other_user@example.com' }
    name { 'テスト 次郎' }
    password { 'password' }
    password_confirmation { 'password' }
  end
end
