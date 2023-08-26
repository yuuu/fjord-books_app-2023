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
    context '自分の日報の場合' do
      subject { report.editable?(user) }

      it { is_expected.to eq true }
    end

    context '他人の日報の場合' do
      let(:other_user) do
        User.create(
          email: 'other_user@example.com',
          name: 'テスト 次郎',
          password: 'password',
          password_confirmation: 'password'
        )
      end
      subject { report.editable?(other_user) }

      it { is_expected.to eq false }
    end
  end

  describe '#created_on' do
    it '日付を返すこと' do
      travel_to(Time.zone.local(2023, 8, 20, 17, 32, 46)) do
        expect(report.created_on).to eq Date.new(2023, 8, 20)
      end
    end
  end

  describe '#save_mentions' do
    let(:other_report0) { user.reports.create(title: '別の日報0', content: 'コンテンツ') }
    let(:other_report1) { user.reports.create(title: '別の日報1', content: 'コンテンツ') }

    context '別の日報への言及がある場合' do
      let(:content) do
        <<~CONTENT
          別の日報にメンションを送ります。
          http://localhost:3000/reports/#{other_report0.id}

          もう一つメンションします
          http://localhost:3000/reports/#{other_report1.id}
        CONTENT
      end
      it 'メンションを保存すること' do
        report.content = content
        report.save

        expect(report.mentioning_reports[0]).to eq other_report0
        expect(report.mentioning_reports[1]).to eq other_report1
      end
    end

    context '別の日報への言及がない場合' do
      let(:content) { '言及のない日報です' }

      it 'メンションを保存しないこと' do
        report.content = content
        report.save

        expect(report.mentioning_reports).to be_empty
      end
    end
  end
end
