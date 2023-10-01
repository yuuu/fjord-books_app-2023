# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Report, type: :model do
  describe '#editable?' do
    let(:user) { create(:user) }
    let(:report) { create(:report, user:) }

    context '自分の日報の場合' do
      subject { report.editable?(user) }

      it { is_expected.to be true }
    end

    context '他人の日報の場合' do
      subject { report.editable?(other_user) }

      let(:other_user) { create(:user, name: 'テスト 次郎') }

      it { is_expected.to be false }
    end
  end

  describe '#created_on' do
    let(:user) { create(:user) }
    let(:report) { create(:report, user:) }

    it '日付を返すこと' do
      report.created_at = '2023-08-20 12:34:56'.in_time_zone
      expect(report.created_on).to eq '2023-08-20'.to_date
    end
  end

  describe '#save_mentions' do
    let(:user) { create(:user) }
    let(:other_user) { create(:user, name: 'テスト 次郎') }
    let(:other_report1) { create(:report, user: other_user, content: <<~CONTENT) }
      ボウリングのスコア計算のプログラムにメンターの方からコメントをいただいたので修正しました。
      ダブルストライクのときのスコア計算をするコードに重複があったので、いただいたコメントを参考に修正したところ、重複がなくなり読みやすくなりました。
    CONTENT
    let(:other_report2) { create(:report, user: other_user, content: <<~CONTENT) }
      プログラムを書き始めて1日が経過しましたが、まだボウリングのスコア計算ができていません。
      ストライクやスペアを考慮せず、スコアを単純に合計することはできています。
    CONTENT
    let(:other_report3) { create(:report, user: other_user, content: <<~CONTENT) }
      ついにボウリングのスコア計算ができました！
      提出し終えたので、レビューが楽しみです。
    CONTENT
    let(:content) { <<~CONTENT }
      ボウリングのスコア計算プログラムを考え始めました。
      カレンダーよりもたくさんのコードを書く必要がありそうでワクワクします。

      早速行き詰まってしまったので、他の生徒の方の日報を読ませていただきました。

      ダブルストライクの場合も考慮する必要があるんですね。
      http://localhost:3000/reports/#{other_report1.id}

      この方のようにまずはスコアを単純に合計するところからスタートしたいと思いました。
      http://localhost:3000/reports/#{other_report2.id}

      存在しないレポートを読みました
      http://localhost:3000/reports/0
    CONTENT

    context '新規作成時' do
      let(:report) { build(:report, user:, content:) }

      it '他日報への言及を保存すること' do
        report.save!

        # MEMO: 他日報への言及を保存すること(以下も併せてチェックする)
        # - 存在しないURLは無視すること
        expect(report.mentioning_reports).to contain_exactly(other_report1, other_report2)
        expect(other_report1.mentioned_reports).to contain_exactly(report)
        expect(other_report2.mentioned_reports).to contain_exactly(report)
      end
    end

    context '更新時' do
      let(:report) { build(:report, user:, content:) }

      it '更新後の他日報への言及を保存すること' do
        report.update!(content: <<~CONTENT)
          ボウリングのスコア計算プログラムを考え始めました。
          カレンダーよりもたくさんのコードを書く必要がありそうでワクワクします。

          早速行き詰まってしまったので、他の生徒の方の日報を読ませていただきました。

          ダブルストライクの場合も考慮する必要があるんですね。
          http://localhost:3000/reports/#{other_report1.id}

          この方のように早くプログラムを完成させたいです
          http://localhost:3000/reports/#{other_report3.id}
          http://localhost:3000/reports/#{other_report3.id}

          これは私の日報です
          http://localhost:3000/reports/#{report.id}
        CONTENT

        # MEMO: 更新後の他日報への言及を保存すること(以下も併せてチェックする)
        # - 削除されたURLは言及がなくなる
        # - 重複したURLは1つにまとめる
        # - 自分の日報への言及は無視する
        expect(report.reload.mentioning_reports).to contain_exactly(other_report1, other_report3)
        expect(other_report1.mentioned_reports).to contain_exactly(report)
        expect(other_report2.mentioned_reports).to be_empty
        expect(other_report3.mentioned_reports).to contain_exactly(report)
      end
    end

    context '削除時' do
      let(:report) { build(:report, user:, content:) }

      it '言及もなくなること' do
        report.destroy!

        expect(other_report1.mentioned_reports).to be_empty
        expect(other_report2.mentioned_reports).to be_empty
      end
    end
  end
end
