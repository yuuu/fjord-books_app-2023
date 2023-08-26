# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#name_or_email' do
    subject { user.name_or_email }

    context 'when nameがある' do
      let(:user) { described_class.new(name: 'テスト 太郎', email: 'user@example.com') }

      it { is_expected.to eq 'テスト 太郎' }
    end

    context 'when nameがない' do
      let(:user) { described_class.new(name: '', email: 'user@example.com') }

      it { is_expected.to eq 'user@example.com' }
    end
  end
end
