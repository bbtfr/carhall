class Api::Accounts::CurrentUsersController < Api::Accounts::ApplicationController
  before_filter :set_current_user

  # GET /api/current_user
  # GET /api/current_user.json
  def show
    render_show @user
  end

  # GET /api/current_user/detail
  # GET /api/current_user/detail.json
  def detail
    render_show @user, :detail
  end

  # PUT /api/current_user
  # PUT /api/current_user.json
  # We need to use a copy of the @user because we don't want to change
  # the current user in place.
  def update
    if @user.update_without_password(update_params)
      render_update_success @user
    else
      render_failure @user
    end
  end

  # PUT /api/current_user/password
  # PUT /api/current_user/password.json
  # We need to use a copy of the @user because we don't want to change
  # the current user in place.
  def password
    if @user.update_with_password(password_params)
      render_update_success @user
    else
      render_failure @user
    end
  end

private

  def update_params
    params.require(:data).permit(:username, :mobile, :description, :avatar, 
      :sex_id, :sex, :area_id, :area, :brand_id, :brand, 
      detail: [:id, :series, :plate_num, :car_image]
    )
  end

  def password_params
    params.require(:data).permit(:username, :mobile, :description, :avatar, 
      :password, :password_confirmation, :current_password, 
      :sex_id, :sex, :area_id, :area, :brand_id, :brand,
      detail: [:id, :series, :plate_num, :car_image]
    )
  end

end
