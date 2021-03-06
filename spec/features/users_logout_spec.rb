require 'rails_helper'

feature "UserLogout",type: :feature do
  let(:user){create(:user)}

  scenario 'ログイン状態からログアウト成功' do
    visit '/login'
    fill_in_login_form(user)
    click_button "Log in"
    expect(page).to have_current_path(user_path(user))
    click_link "Log out"
    expect(page).to have_current_path(root_path)
  end

  scenario 'ログアウト後別ブラウザからログアウトを実行' do
    visit '/login'
    fill_in_login_form(user)
    click_button "Log in"
    expect(page).to have_current_path(user_path(user))
    click_link "Log out"
    expect(page).to have_current_path(root_path)
    page.driver.submit :delete, "/logout", {}
    expect(page).to_not have_current_path(logout_path)
    expect(page).to_not have_current_path(user_path(user))
  end

end