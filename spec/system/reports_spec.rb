# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :system do
  let!(:user) { create(:user) }
  let!(:report) { create(:report, user:) }

  let(:title) { 'レビューを元にボウリングのスコア計算プログラムを修正' }
  let(:content) { <<~CONTENT }
    ボウリングのスコア計算のプログラムにメンターの方からコメントをいただいたので修正しました。
    ダブルストライクのときのスコア計算をするコードに重複があったので、いただいたコメントを参考に修正したところ、重複がなくなり読みやすくなりました。
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

  it 'ログインして日報を更新できること' do
    visit root_path
    expect(page).to have_content 'ログイン'

    fill_in 'Eメール', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content '本の一覧'

    click_link '日報'
    expect(page).to have_content '日報の一覧'
    click_link 'この日報を表示'
    click_link 'この日報を編集'

    fill_in 'タイトル', with: title
    fill_in '内容', with: content
    click_button '更新する'

    expect(page).to have_content '日報が更新されました'
    expect(page).to have_content title
    expect(page).to have_content content
  end

  it 'ログインして日報を削除できること' do
    visit root_path
    expect(page).to have_content 'ログイン'

    fill_in 'Eメール', with: 'user@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    expect(page).to have_content '本の一覧'

    click_link '日報'
    expect(page).to have_content '日報の一覧'
    click_link 'この日報を表示'
    click_button 'この日報を削除'

    expect(page).to have_content '日報が削除されました'
    expect(page).not_to have_content title
    expect(page).not_to have_content content
  end
end
