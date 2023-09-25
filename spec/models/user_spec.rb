# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name_or_email' do
    subject { user.name_or_email }

    context '名前があるとき' do
      let(:user) { User.new(name: 'テスト 太郎', email: 'user_1@example.com') }

      it { is_expected.to eq 'テスト 太郎' }
    end

    context '名前がないとき' do
      let(:user) { User.new(name: '', email: 'user_1@example.com') }

      it { is_expected.to eq 'user_1@example.com' }
    end
  end
end
