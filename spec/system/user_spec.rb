require 'rails_helper'

RSpec.describe 'ユーザ管理機能', type: :system do
  before do
    driven_by(:selenium_chrome_headless)
  end
  describe '登録機能' do
    context 'アカウントを登録した場合' do
      it 'タスク一覧画面に遷移する' do
        visit new_user_path
        fill_in '名前', with: 'user1'
        fill_in 'メールアドレス', with: 'user1@sample.com'
        fill_in 'パスワード', with: '111111'
        fill_in 'パスワード（確認）', with: '111111'
        click_on '登録する'
        expect(page).to have_content 'タスク一覧ページ'
      end
    end
    context 'ログインせずにタスク一覧画面に遷移した場合' do
      it 'ログイン画面に遷移し、「ログインしてください」というメッセージが表示される' do
        visit tasks_path
        expect(page).to have_content 'ログインしてください'
      end
    end
  end

  describe 'ログイン機能' do
    let!(:first_user) { FactoryBot.create(:first_user) }
    let!(:second_user) { FactoryBot.create(:second_user) }
    before do
      visit new_session_path
      fill_in 'session_email', with: 'user1@sample.com'
      fill_in 'session_password', with: '111111'
      click_button 'ログイン'
    end
    context '登録済みのユーザでログインした場合' do
      it 'タスク一覧画面に遷移し、「ログインしました」というメッセージが表示される' do
        expect(page).to have_content 'ログインしました'
      end
      it '自分の詳細画面にアクセスできる' do
        visit user_path(first_user.id)
        expect(page).to have_content 'アカウント詳細ページ'
      end
      it '他人の詳細画面にアクセスすると、タスク一覧画面に遷移する' do
        visit user_path(second_user.id)
        expect(page).to have_content 'タスク一覧ページ'
      end
      it 'ログアウトするとログイン画面に遷移し、「ログアウトしました」というメッセージが表示される' do
        click_on 'ログアウト'
        expect(page).to have_content 'ログアウトしました'
      end
    end
  end

  describe '管理者機能' do
    let!(:second_user) { FactoryBot.create(:second_user) }
    let!(:third_user) { FactoryBot.create(:third_user) }
    before do
      visit new_session_path
      fill_in 'session_email', with: 'user3@sample.com'
      fill_in 'session_password', with: '333333'
      click_button 'ログイン'
    end
    context '管理者がログインした場合' do
      it 'ユーザ一覧画面にアクセスできる' do
        visit admin_users_path
        expect(page).to have_content 'ユーザ一覧ページ'
      end
      it '管理者を登録できる' do
        visit admin_users_path
        click_on 'ユーザを登録する'
        fill_in '名前', with: 'user1'
        fill_in 'メールアドレス', with: 'user1@sample.com'
        fill_in 'パスワード', with: '111111'
        fill_in 'パスワード（確認）', with: '111111'
        check 'check_admin'
        click_on '登録する'
      end
      it 'ユーザ詳細画面にアクセスできる' do
        visit admin_users_path(third_user.id)
        expect(page).to have_content 'ユーザ一覧ページ'
      end
      it 'ユーザ編集画面から、自分以外のユーザを編集できる' do
        visit edit_admin_user_path(second_user.id)
        fill_in '名前', with: 'user2'
        fill_in 'メールアドレス', with: 'user00@sample.com'
        fill_in 'パスワード', with: '222222'
        fill_in 'パスワード（確認）', with: '222222'
        check 'check_admin'
        click_on '更新する'
      end
      it 'ユーザを削除できる' do
        visit admin_users_path(third_user.id)
        click_on '削除', match: :first
        expect(page.accept_confirm).to eq '本当に削除してもよろしいですか？'
        expect(page).to have_content 'ユーザを削除しました'
      end
    end
    context '一般ユーザがユーザ一覧画面にアクセスした場合' do
      let!(:first_user) { FactoryBot.create(:first_user) }
      before do
        click_on 'ログアウト'
        visit new_session_path
        fill_in 'session_email', with: 'user1@sample.com'
        fill_in 'session_password', with: '111111'
        click_button 'ログイン'
      end
      it 'タスク一覧画面に遷移し、「管理者以外アクセスできません」というエラーメッセージが表示される' do
        visit admin_users_path(second_user.id)
        expect(page).to have_content '管理者以外はアクセスできません'
      end
    end
  end
end