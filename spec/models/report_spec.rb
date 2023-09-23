# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:user) do
    User.create(
      email: 'user@example.com',
      name: 'テスト 太郎',
      password: 'password',
      password_confirmation: 'password'
    )
  end
  let(:content) { 'コンテンツ' }
  let(:report) { user.reports.create(title: 'タイトル', content:) }

  describe '#editable?' do
    context 'with 自分の日報' do
      subject { report.editable?(user) }

      it { is_expected.to eq true }
    end

    context 'with 他人の日報' do
      subject { report.editable?(other_user) }

      let(:other_user) do
        User.create(
          email: 'other_user@example.com',
          name: 'テスト 次郎',
          password: 'password',
          password_confirmation: 'password'
        )
      end

      it { is_expected.to eq false }
    end
  end

  describe '#created_on' do
    it '日付を返すこと' do
      travel_to("2023-08-20 17:32:46".in_time_zone) do
        expect(report.created_on).to eq "2023-08-20".to_date
      end
    end
  end

  describe '#save_mentions' do
    let(:other_report1) { user.reports.create(title: '別の日報1', content: 'コンテンツ') }
    let(:other_report2) { user.reports.create(title: '別の日報2', content: 'コンテンツ') }

    context 'when 別の日報への言及がある' do
      let(:content) do
        <<~CONTENT
          別の日報にメンションを送ります。
          http://localhost:3000/reports/#{other_report1.id}

          もう一つメンションします
          http://localhost:3000/reports/#{other_report2.id}
        CONTENT
      end

      it 'メンションを保存すること' do
        report.content = content
        report.save

        expect(report.mentioning_reports).to match_array([other_report1, other_report2])
      end
    end

    context 'when 別の日報への言及がない' do
      let(:content) { '言及のない日報です' }

      it 'メンションを保存しないこと' do
        report.content = content
        report.save

        expect(report.mentioning_reports).to be_empty
      end
    end
  end
end
