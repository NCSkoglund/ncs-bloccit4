require 'spec_helper'

describe User do 

  describe ".top_rated" do 
    before :each do
      post = nil
      topic = create(:topic)
      @u0 = create(:user) do |user|
        post = user.posts.build(attributes_for(:post))
        post.topic = topic
        post.save
        c = user.comments.build(attributes_for(:comment))
        c.post = post
        c.save
      end

      @u1 = create(:user) do |user|
        c = user.comments.build(attributes_for(:comment))
        c.post = post
        c.save
        post = user.posts.build(attributes_for(:post))
        post.topic = topic
        post.save
        c = user.comments.build(attributes_for(:comment))
        c.post = post
        c.save
      end
    end

    it "should return users based on comments + posts" do
      User.top_rated.should eq([@u1, @u0])
    end
    it "should have `posts_count` on user" do 
      users = User.top_rated
      users.first.posts_count.should eq(1)
      users.last.posts_count.should eq(1)
    end
    it "should have `comments_count` on user" do
      users = User.top_rated
      users.first.comments_count.should eq(2)
      users.last.comments_count.should eq(1)
    end
    it "should have 'rank' on user arranged in descending order" do
      users = User.top_rated
      users.first.rank.should eq(3)
      users.last.rank.should eq(2)
      users.first.rank.should be >= users.last.rank
    end
    it "should total posts + comments into rank" do
      users = User.top_rated
      (users.first.comments_count + users.first.posts_count).should be(users.first.rank)
      (users.last.comments_count + users.last.posts_count).should be(users.last.rank)
    end
  end
  
  describe ".role?" do 
    before :each do
      @u = create(:user)
    end

    it "should be set to 'member' by default for a new user" do 
      @u.role?(:admin).should be_false
      @u.role?(:moderator).should be_false
      @u.role?(:member).should be_true
    end
    it "should recognize a moderator's role" do 
      @u.update_attribute(:role, 'moderator')
      @u.role?(:admin).should be_false
      @u.role?(:moderator).should be_true
      @u.role?(:member).should be_false
    end
    it "should recognize an admin's role" do 
      @u.update_attribute(:role, 'admin')
      @u.role?(:admin).should be_true
      @u.role?(:moderator).should be_false
      @u.role?(:member).should be_false
    end
  end

  describe ".favorited" do 
    before :each do
      @user = create(:user) 
      @p0 = create(:post)
      @p1 = create(:post)
      @favorite =  @user.favorites.build(post: @p1)
      @favorite.save
    end
    it "should return true if a user has favorited a post" do
      @user.favorited(@p1).should be_true
    end
    it "should return false if a user has not favorited a post" do 
      @user.favorited(@p0).should be_false
    end
    it "should return false if a user unfavorites a post" do 
      @favorite.destroy
      @user.favorited(@p1).should be_false
    end
  end
 

  describe ".voted" do 
    before :each do
      @user = create(:user) 
      @p0 = create(:post)
      @p1 = create(:post)
      @p2 = create(:post)
      @v0 =  Vote.create(value: 1, post: @p0, user: @user)
      @v1 =  Vote.create(value: -1, post: @p1, user: @user)
    end
    it "should return true if a user has upvoted a post" do
      @user.voted(@p0).should be_true
    end
    it "should return true if a user has downvoted a post" do
      @user.voted(@p1).should be_true
    end
    it "should return false if a user has not voted on a post" do
      @user.voted(@p2).should be_false
    end
  end

 describe ".set_member" do 
  it "should set a new user's role to 'member' by default" do 
      @u = User.new
      @u.send(:set_member)
      @u.role?(:member).should be_true
      @u.role?(:moderator).should be_false
      @u.role?(:admin).should be_false
    end
 end

end