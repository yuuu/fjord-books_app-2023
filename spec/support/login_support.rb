# frozen_string_literal: true

module LoginSupport
  def sign_in_as(user)
    visit root_path
    expect(page).to have_content 'ログイン'

    fill_in 'Eメール', with: user.email
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
  end
end

RSpec.configure do |config|
  config.include LoginSupport
end
