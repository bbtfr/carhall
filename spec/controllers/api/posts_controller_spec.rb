require 'spec_helper'

describe Api::PostsController do
  include_context "for devise"

  let(:resource_name) { :post }
  let(:resource) { create :post, user: user }
  let(:other) { create :user }

  before do
    user.make_friend_with(other).save
    3.times { create :post, user: other }
    3.times { create :post, user: user }
  end 

  include_examples "resources#index"
  include_examples "resources#show"
  include_examples "resources#create"
  include_examples "resources#destroy"

  describe "GET friends" do
    let(:collection_name) { :friends }
    include_examples "resources#collection"
  end
  describe "GET top" do
    let(:collection_name) { :top }
    include_examples "resources#collection"
  end
  describe "GET club" do
    let(:collection_name) { :club }
    include_examples "resources#collection"
  end

  describe "when comment belongs to other" do
    let(:resource) { create :post, user: other }
    it "doesn't delete" do
      delete :destroy, id: resource.id
      response.status.should eq(403), error_messages
    end
  end
end

describe Api::CommentsController do
  include_context "for devise"

  let(:resource_name) { :comment }
  let(:user_post) { create :post, user: user }
  let(:other) { create :user }
  let(:other_post) { create :post, user: other }

  shared_examples "comments" do
    before do
      3.times { create :comment, user: user, source: source }
    end 
    let(:resource) { create :comment, user: user, source: source }
    let(:attach_args) {{ post_id: source.id }}

    include_examples "resources#index"
    include_examples "resources#show"
    include_examples "resources#create"
    include_examples "resources#destroy"
  end

  describe "when post belongs to himself" do
    let(:source) { user_post }
    include_examples "comments"
  end
  describe "when post belongs to other" do
    let(:source) { other_post }
    include_examples "comments"
  end
  describe "when comment belongs to other" do
    let(:resource) { create :comment, user: other, source: other_post }
    it "doesn't delete" do
      delete :destroy, id: resource.id, post_id: other_post.id
      response.status.should eq(403), error_messages
    end
  end
end

describe Api::PostBlacklistsController do
  include_context "for devise"

  let(:resource_name) { :user }

  before { 3.times { user.add_to_post_blacklist(create(:user)).save }}

  include_examples "resources#index"
  context do
    let(:reset_args) {{ id: id }}
    include_examples "resources#create"
  end
  include_examples "resources#destroy"
end

describe Api::ClubsController do
  include_context "for devise"

  let(:resource_name) { :club }

  include_examples "resource#show"
  describe "POST president" do
    let(:post_name) { :president }
    include_examples "resources#post"
  end
  describe "POST president" do
    let(:post_name) { :mechanics }
    include_examples "resources#post"
  end
  describe "when user isn't president" do
    it "doesn't edit" do
      put :update
      response.status.should eq(403), error_messages
    end
  end
  describe "when user is president" do
    before do 
      club = Club.with_user(user)
      club.president = user
      club.save
    end
    include_examples "resource#update"
  end

end