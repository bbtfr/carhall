class OpenfireAPI < Grape::API
  version 'v1', using: :param
  format :json
  helpers GrapeHelper

  error_formatter :json, ErrorFormatter
  formatter :json, DataFormatter

  desc "Login by mobile and password."
  params do
    requires :mobile, type: Integer
    requires :password, type: String
  end
  post :login do
    status 200
    @user = Accounts::Account.find_for_database_authentication(mobile: params[:mobile])

    if @user && @user.valid_password?(params[:password])
      @user.ensure_authentication_token!
      present @user, with: ::OpenfireAccountEntity, type: :login
    else
      error! '401 Unauthorized', 401
    end
  end

  desc "Login by authentication token."
  params do
    requires :token, type: String
  end
  post :login_by_token do
    status 200
    @user = Accounts::Account.find_by(authentication_token: params[:token])

    if @user
      present @user, with: ::OpenfireAccountEntity, type: :login
    else
      error! '401 Unauthorized', 401
    end
  end

  desc "Get user"
  params do
    requires :id, type: Integer
  end
  post :get_user do
    status 200
    @user = Accounts::Account.find(params[:id])
    present @user, with: ::OpenfireAccountEntity, type: :detail
  end

  desc "List users"
  params do
    requires :ids, type: String
  end
  post :list_users do
    status 200
    @users = Accounts::Account.find(params[:ids].split(','))
    present @users, with: ::OpenfireAccountEntity, type: :detail
  end

  desc "Send media file"
  params do
    requires :imres
    requires :type
  end
  post :send_file do
    @upload = ::Share::Upload.new(file: params[:imres], type_id: params[:type])

    if @upload.save
      { filePath: absolute_image_url(@upload.file, :original) }
    else
      failure! @upload
    end
  end
end
