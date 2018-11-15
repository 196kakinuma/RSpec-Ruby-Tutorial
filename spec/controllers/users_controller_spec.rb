require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  describe '#index' do
    context 'visit index' do
      let(:user){create(:user)}
      it 'indexページが描画される' do
        log_in_session_as(user)
        get :index
        expect(response).to render_template('users/index')
      end
    end 
    context 'when not logged in' do
      it 'ログインページにリダイレクトされる' do
        get :index
        expect(response).to redirect_to(login_path)
      end
    end
  end
  describe "GET #new" do
    it "returns http success" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end
  
  describe '#create' do
    context 'when success signup' do
      let(:user){build(:user)}
      let(:post_create){
        post( :create, params: {
          user: attributes_for(:user)
      })}

      it 'ユーザが新規に生成される' do
        expect{post_create}.to change{User.count}.by(1)
      end

      it 'サインアップ後リダイレクトする' do
        post_create
        created = User.find_by(email: user.email)
        expect(response).to redirect_to("/users/#{created.id}")
      end

      it 'flashに値が入っている' do
        post_create
        created = User.find_by(email: user.email)
        get :show, params: {id: created.id} 
        expect(flash[:success]).not_to be_empty
      end

      it 'flashの値が消える' do
        post_create
        created = User.find_by(email: user.email)
        get :show, params: {id: created.id}
        get :show, params: {id: created.id}
        expect(flash[:success]).to be nil
      end

      it 'ログインセッションが保存される' do
        post_create
        expect(is_logged_in?).to eq true
      end
    end
    context 'invalid signup information' do
      let(:post_create){post( :create, params: {
        user: attributes_for(:user, :invalid)
      })}

      it 'ユーザ数が増えない' do
        expect{post_create}.to_not change{User.count}
      end

      it 'users/newに遷移する' do
        post_create
        expect(response).to render_template('users/new')
      end
    end
  end

  describe 'editt' do
    let(:user){create(:user)}
    let(:get_edit){get :edit, params:{id: user.id}}
    context 'when visit edit page' do
      let(:login){log_in_session_as(user)}
      it 'render edit page' do
        login
        get_edit
        expect(response).to render_template('users/edit')
      end
    end

    context 'when not logged in' do 
      it '権限がなくログインページに飛ばされる' do
        get_edit
        expect(response).to redirect_to(login_url)
      end
      it 'フラッシュに値が入る' do
        get_edit
        expect(flash[:danger]).to_not be_empty
      end
      it 'sessionにurlが保存される' do
        get_edit
        expect(session[:forwarding_url]).to eq edit_user_url(user)
      end
    end
  end

  describe '#update' do
    let(:user){create(:user)}
    let(:login){log_in_session_as(user)}
    let(:update_user){patch(:update, params:{
      id: user,
      user: attributes_for(:michael)
    })}
    context 'when use valid info' do
      it 'flashが空でない' do 
        login
        update_user
        expect(flash[:success]).to_not be_empty
      end

      it 'プロフィールページにリダイレクト' do
        login
        update_user
        expect(response).to redirect_to(user)
      end

      it 'user情報が変更される' do
        login
        expect{update_user}.to change{User.find(user.id).name}.from(user.name).to(build(:michael).name)
      end
    end

    context 'when use invalid info' do
      it 'editに戻ってくる' do
        login
        get :edit, params:{id:user.id}
        patch :update ,params:{
          id: user.id,
          user: attributes_for(:user,:invalid)
          }
        expect(response).to render_template('users/edit')
      end
    end

    context 'when not logged in' do 
      it '権限がなくログインページに飛ばされる' do
        update_user
        expect(response).to redirect_to(login_url)
      end
      it 'フラッシュに値が入る' do
        update_user
        expect(flash[:danger]).to_not be_empty
      end
    end
  end
end
