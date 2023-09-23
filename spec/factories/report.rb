# frozen_string_literal: true

FactoryBot.define do
  factory :report do
    title { 'ボウリングのスコア計算プログラムに着手した' }
    content do
      <<~CONTENT
        ボウリングのスコア計算プログラムを考え始めました。
        カレンダーよりもたくさんのコードを書く必要がありそうでワクワクします。
      CONTENT
    end
    user
  end
end
