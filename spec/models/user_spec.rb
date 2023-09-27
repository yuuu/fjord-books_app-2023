# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name_or_email' do
    subject { user.name_or_email }

    context '名前があるとき' do
      let(:user) { create(:user) }

      it { is_expected.to eq 'テスト 太郎' }
    end

    context '名前がないとき' do
      let(:user) { create(:user, name: '') }

      it { is_expected.to eq 'user@example.com' }
    end
  end
end
