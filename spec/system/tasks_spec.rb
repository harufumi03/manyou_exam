require 'rails_helper'

RSpec.describe 'タスク管理機能', type: :system do
  let!(:second_user) { FactoryBot.create(:second_user) }
  before do
    driven_by(:selenium_chrome_headless)
    @current_user = User.find_by(email: "user2@sample.com")
    visit new_session_path
    fill_in 'session_email', with: 'user2@sample.com'
    fill_in 'session_password', with: '222222'
    click_button 'ログイン'
  end
  describe '登録機能' do
    context 'タスクを登録した場合' do
      it '登録したタスクが表示される' do
        visit new_task_path
        fill_in 'タイトル', with: 'task1'
        fill_in '内容', with: 'sample1'
        fill_in '終了期限', with: '002025-02-18'
        select '中', from: '優先度'
        select '未着手', from: 'ステータス'
        click_button '登録する'
        expect(page).to have_content 'task1'
      end
    end
  end
  
  describe '一覧表示機能' do
    let!(:first) { FactoryBot.create(:task, user_id: @current_user.id) }
    let!(:second) { FactoryBot.create(:second_task, user_id: @current_user.id) }
    before do
      visit tasks_path
    end
    context '一覧画面に遷移した場合' do
      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_title = all('tbody tr')
        expect(task_title[1]).to have_content 'second_task'
        expect(task_title[0]).to have_content 'first_task'
      end
    end
    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        task_title = all('tbody tr')
        expect(task_title[0]).to have_content 'first_task'
        expect(task_title[1]).to have_content 'second_task'
      end
    end
    describe 'ソート機能' do
      let!(:first) { FactoryBot.create(:task, user_id: @current_user.id) }
      let!(:second) { FactoryBot.create(:second_task, user_id: @current_user.id) }
      context '「終了期限でソートする」というリンクをクリックした場合' do
        it "終了期限昇順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          visit tasks_path
          click_on '終了期限'
          sleep 1
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content '2025-02-17'
          expect(task_list[1]).to have_content '2025-02-18'
        end
      end
      context '「優先度でソートする」というリンクをクリックした場合' do
        it "優先度の高い順に並び替えられたタスク一覧が表示される" do
          # allメソッドを使って複数のテストデータの並び順を確認する
          visit tasks_path
          click_on '優先度'
          sleep 1
          task_list = all('tbody tr')
          expect(task_list[0]).to have_content '高'
          expect(task_list[1]).to have_content '中'
        end
      end
    end  
  end

  describe '詳細表示機能' do
    let!(:first) { FactoryBot.create(:task, user_id: @current_user.id) }
    let!(:second) { FactoryBot.create(:second_task, user_id: @current_user.id) }
    context '任意のタスク詳細画面に遷移した場合' do
      it 'そのタスクの内容が表示される' do
        visit task_path(first)
        expect(page).to have_content 'first_task'
      end
    end
  end

  describe '検索機能' do
    let!(:first) { FactoryBot.create(:task, user_id: @current_user.id) }
    let!(:second) { FactoryBot.create(:second_task, user_id: @current_user.id) }
    context 'タイトルであいまい検索をした場合' do
      it "検索ワードを含むタスクのみ表示される" do
        visit tasks_path
        fill_in 'タイトル', with: "first"
        click_button '検索'
        expect(page).to have_content 'first_task'
        expect(page).not_to have_content 'second_task'
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
    context 'ステータスで検索した場合' do
      it "検索したステータスに一致するタスクのみ表示される" do
        visit tasks_path
        select '未着手', from: 'ステータス'
        click_button '検索'
        expect(page).to have_content '未着手'
        expect(page).not_to have_content 'second_task'
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
    context 'タイトルとステータスで検索した場合' do
      it "検索ワードをタイトルに含み、かつステータスに一致するタスクのみ表示される" do
        visit tasks_path
        select '未着手', from: 'ステータス'
        fill_in 'タイトル', with: "first"
        click_button '検索'
        expect(page).to have_content 'first_task'
        expect(page).to have_content '未着手'
        expect(page).not_to have_content 'second_task'
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認すend
      end
    end
  end  

  describe '検索機能' do
    let!(:label) { FactoryBot.create(:label) }
    let!(:first) { FactoryBot.create(:task, user_id: @current_user.id) }
    let!(:second) { FactoryBot.create(:second_task, user_id: @current_user.id, label_ids: label.id)} 
    context 'ラベルで検索をした場合' do
      it "そのラベルの付いたタスクがすべて表示される" do
        visit tasks_path
        sleep 1
        select 'test', from: 'task_label_id'
        click_button '検索'
        expect(page).to have_content 'second_task'
        expect(page).not_to have_content 'first_task'
        # toとnot_toのマッチャを使って表示されるものとされないものの両方を確認する
      end
    end
  end  
end