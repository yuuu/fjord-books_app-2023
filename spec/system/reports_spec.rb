# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  before do
    create(:user)
  end

  let(:title) { 'ボウリングのスコア計算プログラムに着手した' }
  let(:content) { <<~CONTENT }
    ボウリングのスコア計算プログラムを考え始めました。
    カレンダーよりもたくさんのコードを書く必要がありそうでワクワクします。
  CONTENT

  it 'ログインして日報を新規作成できること' do
    visit root_path
    expect(page).to have_content 'ログイン'

    fill_in 'Eメール', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content '本の一覧'

    click_link '日報'
    expect(page).to have_content '日報の一覧'
    click_link '日報の新規作成'
    expect(page).to have_content '日報の新規作成'

    fill_in 'タイトル', with: title
    fill_in '内容', with: content
    click_button '登録する'

    expect(page).to have_content '日報が作成されました'
    expect(page).to have_content title
    expect(page).to have_content content
  end
end
