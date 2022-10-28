require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:first) { FactoryBot.create(:task) }
  let!(:second) { FactoryBot.create(:second_task) }
  let!(:third) { FactoryBot.create(:third_task) }
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do        
        visit tasks_path
        expect(page).to have_content '書類作成'
      end
    end
  end
  
  describe '一覧表示機能' do
    before do
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_title = all('tbody tr')
        expect(task_title[0]).to have_content '書類作成'
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        task_title = all('tbody tr')
        expect(task_title[0]).to have_content '書類作成'
      end
    end
  end

  describe '詳細表示機能' do
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do        
        visit task_path(first)
        expect(page).to have_content '書類作成'
      end
    end
  end
end