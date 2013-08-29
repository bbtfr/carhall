class Api::FriendsController < Api::BaseController
  before_filter :set_user

  # GET /api/friends
  # GET /api/friends.json
  def index
    render_index @user.friends
  end

  # POST /api/friends/1
  # POST /api/friends/1.json
  def create
    friendship = @user.make_friend_with params[:id]
    if not friendship.new_record? or friendship.save
      render_create_success friendship, { data: friendship.friend }
    else
      render_failure friendship
    end
  end

  # DELETE /api/friends/1
  # DELETE /api/friends/1.json
  def destroy
    @user.break_with params[:id]

    render_accepted
  end

  protected

  def set_user
    if user_id = params[:user_id]
      @user = BaseUser.find(user_id)
    else
      @user = current_base_user
    end
  end
end
