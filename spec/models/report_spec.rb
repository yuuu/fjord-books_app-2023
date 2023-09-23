# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe '#editable?' do
    let(:user) { create(:user) }
    let(:report) { create(:report, user:) }

    context '自分の日報の場合' do
      subject { report.editable?(user) }

      it { is_expected.to eq true }
    end

    context '他人の日報の場合' do
      subject { report.editable?(other_user) }

      let(:other_user) { create(:other_user) }

      it { is_expected.to eq false }
    end
  end

  describe '#created_on' do
    let(:user) { create(:user) }
    let(:report) { create(:report, user:) }

    it '日付を返すこと' do
      travel_to('2023-08-20 17:32:46'.in_time_zone) do
        expect(report.created_on).to eq '2023-08-20'.to_date
      end
    end
  end

  describe '#save_mentions' do
    let(:user) { create(:user) }
    let(:report) { create(:report, user:, content:) }

    let(:other_user) { create(:other_user) }
    let(:other_report1) { create(:report, user: other_user, content: <<~CONTENT) }
      ボウリングのスコア計算のプログラムにメンターの方からコメントをいただいたので修正しました。
      ダブルストライクのときのスコア計算をするコードに重複があったので、いただいたコメントを参考に修正したところ、重複がなくなり読みやすくなりました。
    CONTENT
    let(:other_report2) { create(:report, user: other_user, content: <<~CONTENT) }
      プログラムを書き始めて1日が経過しましたが、まだボウリングのスコア計算ができていません。
      ストライクやスペアを考慮せず、スコアを単純に合計することはできています。
    CONTENT

    context '別の日報への言及がある場合' do
      let(:content) do
        <<~CONTENT
          ボウリングのスコア計算プログラムを考え始めました。
          カレンダーよりもたくさんのコードを書く必要がありそうでワクワクします。

          早速行き詰まってしまったので、他の生徒の方の日報を読ませていただきました。

          ダブルストライクの場合も考慮する必要があるんですね。
          http://localhost:3000/reports/#{other_report1.id}

          この方のようにまずはスコアを単純に合計するところからスタートしたいと思いました。
          http://localhost:3000/reports/#{other_report2.id}
        CONTENT
      end

      it '言及を保存すること' do
        report.save!

        expect(report.mentioning_reports).to contain_exactly(other_report1, other_report2)
      end
    end

    context '別の日報への言及がない場合' do
      let(:content) do
        <<~CONTENT
          ボウリングのスコア計算プログラムを考え始めました。
          カレンダーよりもたくさんのコードを書く必要がありそうでワクワクします。
        CONTENT
      end

      it '言及を保存しないこと' do
        report.save!

        expect(report.mentioning_reports).to be_empty
      end
    end
  end
end
