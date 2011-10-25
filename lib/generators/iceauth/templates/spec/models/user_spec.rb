require 'spec_helper'

describe User do

  before(:each) do
    @attr = {
      :name => "Mark Dillon",
      :username => "markdillon",
      :email => "mdillon@gmail.com",
      :password => "foobar",
      :password_confirmation => "foobar"
    }
  end

  describe ".create" do
    
    before(:each) do
      @count = User.count
      @user = User.create!(@attr)
    end
    
    context "given valid attributes" do
      it "creates a new instance" do
        User.count.should == @count + 1
      end
      
      it "sets the created_at timestamp" do
        @user.created_at.should be
      end
      
      it "sets the updated_at timestamp" do
        @user.updated_at.should be
      end
          
      it "sets the password digest" do
        @user.password_digest.should_not be_blank
      end
      
      it "is not an admin by default" do
        @user.should_not be_admin
      end

      it "is convertible to an admin" do
        @user.should_not be_admin
        @user.toggle_admin!
        @user.should be_admin
      end
    end
    
    context "given invalid attributes" do
      it "does not create a user" do
        @count = User.count
        expect { User.create!({}) }.to raise_error(Mongoid::Errors::Validations)
        User.count.should == @count
      end
    end
    
  end
  
  describe "#valid?" do
    
    it "requires a username" do
      User.new(@attr.merge(:username => "")).should_not be_valid
    end
  
    it "requires an email address" do
      User.new(@attr.merge(:email => "")).should_not be_valid
    end
  
    it "requires a name" do
      User.new(@attr.merge(:name => "")).should_not be_valid
    end
  
    it "rejects usernames with spaces in them" do
      User.new(@attr.merge(:username => "mark dillon")).should_not be_valid
    end
    
    it "rejects usernames that are too long" do
      long_username = "a" * 21
      User.new(@attr.merge(:username => long_username)).should_not be_valid
    end
  
    it "accepts valid email addresses" do
      %w[user@foo.com THE_USER@foo.bar.org first.last@foo.jp].each do |address|
        User.new(@attr.merge(:email => address)).should be_valid
      end
    end

    it "rejects invalid email addresses" do
      %w[user@foo,com user_at_foo.org example.user@foo.].each do |address|
        User.new(@attr.merge(:email => address)).should_not be_valid
      end
    end
  
    it "rejects duplicate email addresses" do
      User.create!(@attr)
      User.new(@attr).should_not be_valid
    end
  
    it "rejects email addresses identical up to case" do
      upcased_email = @attr[:email].upcase
      User.create!(@attr.merge(:email => upcased_email))
      User.new(@attr).should_not be_valid
    end
  
    it "rejects names that are too long" do
      long_name = "a" * 31
      User.new(@attr.merge(:name => long_name)).should_not be_valid
    end
    
    it "requires a password" do
      User.new(@attr.merge(:password => "", :password_confirmation => "")).should_not be_valid
    end

    it "requires a matching password confirmation" do
      User.new(@attr.merge(:password_confirmation => "invalid")).should_not be_valid
    end

    it "rejects short passwords" do
      short = "a" * 5
      hash = @attr.merge(:password => short, :password_confirmation => short)
      User.new(hash).should_not be_valid
    end

    it "rejects long passwords" do
      long = "a" * 41
      hash = @attr.merge(:password => long, :password_confirmation => long)
      User.new(hash).should_not be_valid
    end
    
  end
  
  describe "#delete" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "deletes the user" do
      @count = User.count
      @user.delete
      User.count.should == @count - 1
    end
    
    it "sets deleted_at for the user" do
      @user.deleted_at.should_not be
      @user.delete
      @user.deleted_at.should be
    end
    
    it "makes user irretrievable by normal means" do
      id = @user.id
      User.find(id).should be
      @user.delete
      expect { User.find(id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end
    
    it "allows user to be retrieved specifying deleted_at exists" do
      id = @user.id
      @user.delete
      User.where(:_id => id).first.should_not be
      User.where(:deleted_at.exists => true, :_id => id).first.should be
    end
    
    it "allows user to be restored" do
      id = @user.id
      @user.delete
      expect { User.find(id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
      @user.restore
      User.find(id).should be
    end
    
  end
  
  describe "#restore" do
    
    before(:each) do
      @user = User.create!(@attr)
    end
    
    it "restores a deleted user" do
      id = @user.id
      @user.delete
      expect { User.find(id) }.to raise_error(Mongoid::Errors::DocumentNotFound)
      @user.restore
      User.find(id).should be
    end
    
  end
  

end
