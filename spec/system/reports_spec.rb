# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user) }
  let!(:report) { create(:report, user:, title: 'Sinatraの実装中', content: 'あと少し頑張ります') }

  it 'ログインして日報を新規作成できること' do
    visit root_path
    expect(page).to have_content 'ログイン'

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content '本の一覧'

    click_link '日報'
    expect(page).to have_content '日報の一覧'
    click_link '日報の新規作成'
    expect(page).to have_content '日報の新規作成'

    fill_in 'タイトル', with: 'Railsの章に入った'
    fill_in '内容', with: '少し不安です'
    click_button '登録する'

    expect(page).to have_content '日報が作成されました'
    expect(page).to have_content 'Railsの章に入った'
    expect(page).to have_content '少し不安です'
  end

  it 'ログインして日報を更新できること' do
    visit root_path
    expect(page).to have_content 'ログイン'

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content '本の一覧'

    click_link '日報'
    expect(page).to have_content '日報の一覧'
    click_link 'この日報を表示'
    click_link 'この日報を編集'

    fill_in 'タイトル', with: 'Railsの章に入った'
    fill_in '内容', with: '少し不安です'
    click_button '更新する'

    expect(page).to have_content '日報が更新されました'
    expect(page).to have_content 'Railsの章に入った'
    expect(page).to have_content '少し不安です'
  end

  it 'ログインして日報を削除できること' do
    visit root_path
    expect(page).to have_content 'ログイン'

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content '本の一覧'

    click_link '日報'
    expect(page).to have_content '日報の一覧'
    expect(page).to have_content 'Sinatraの実装中'
    click_link 'この日報を表示'
    click_button 'この日報を削除'

    expect(page).to have_content '日報が削除されました'
    expect(page).not_to have_content 'Sinatraの実装中'
  end
end
