require 'spec_helper'

describe SessionsController do
  render_views
  
  describe "#new", "(GET)" do
    
    it "is successful" do
      get :new
      response.should be_success
    end
    
    it "has the right title" do
      get :new
      page.has_content?("Sign In")
    end
    
  end
  
  describe "#create", "(POST)" do

    context "given invalid login or password" do

      before(:each) do
        @attr = { :login => "email@example.com", :password => "invalid" }
      end

      it "re-renders the new page" do
        post :create, :session => @attr
        response.should render_template('new')
      end

      it "has the correct title" do
        post :create, :session => @attr
        page.has_content?("Sign in")
      end

      it "has a flash.now error message" do
        post :create, :session => @attr
        flash.now[:error].should =~ /invalid/i
      end
      
    end
    
    context "given valid login and password" do
    
      before(:each) do
        @user = Factory(:user)
        @attr = { :login => @user.username, :password => @user.password }
      end
    
      it "signs the user in" do
        post :create, :session => @attr
        controller.current_user.should == @user
        controller.should be_signed_in
      end
    
      it "redirects to the root page" do
        post :create, :session => @attr
        response.should redirect_to(root_path)
      end
      
    end
    
    describe "with twitter omniauth"
    
    describe "with facebook omniauth"

  end
  
  describe "#destroy", "(DELETE)" do
    
    before(:each) do
      test_sign_in(Factory(:user))
      delete :destroy
    end

    it "signs a user out" do
      controller.should_not be_signed_in
    end
    
    it "redirects to root path" do
      response.should redirect_to(root_path)
    end
    
  end

end
