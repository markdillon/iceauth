require 'spec_helper'

describe UsersController do
  render_views

  describe "#new", '(GET)' do

    context "when not logged in" do
      
      before(:each) do
        get :new
      end
      
      it "is successful" do
        response.should be_success
      end
    
      it "has the correct title" do
        page.has_content?("Sign Up")
      end
    
      it "has a name field" do
        page.has_selector?("input[name='user[name]'][type='text']")
      end

      it "has a username field" do
        page.has_selector?("input[name='user[username]'][type='text']")
      end
    
      it "has an email field" do
        page.has_selector?("input[name='user[email]'][type='text']")
      end

      it "has a password field" do
        page.has_selector?("input[name='user[password]'][type='password']")
      end

      it "has a password confirmation field" do
        page.has_selector?("input[name='user[password_confirmation]'][type='password']")
      end
      
    end
    
    context "when logged in" do
      
      before(:each) do
        test_sign_in(Factory(:user))
        get :new
      end
      
      it "redirects to the root path" do
        response.should redirect_to(root_path)
      end
      
    end

  end
  
  describe '#create', '(POST)' do

    context "when not logged in" do
      
      context "given invalid parameters" do

        before(:each) do
          @attr = { :name => "", :username => "", :email => "", :password => "",
                    :password_confirmation => "" }
        end

        it "does not create a user" do
          lambda do
            post :create, :user => @attr
          end.should_not change(User, :count)
        end

        it "renders the 'new' page" do
          post :create, :user => @attr
          response.should render_template('new')
        end

        it "has the correct title" do
          post :create, :user => @attr
          page.has_content?("Sign Up")
        end
      
      end
    
      context "given valid parameters" do

        before(:each) do
          @attr = { :name => "Mark Dillon", :username => "markdillon", :email => "mdillon@gmail.com",
                    :password => "foobar", :password_confirmation => "foobar" }
        end

        it "creates a user" do
          lambda do
            post :create, :user => @attr
          end.should change(User, :count).by(1)
        end

        it "redirects to the root path" do
          post :create, :user => @attr
          response.should redirect_to(root_path)
        end
      
        it "has a welcome message" do
          post :create, :user => @attr
          flash[:success].should =~ /Signed Up/i
        end
      
        it "signs the user in" do
          post :create, :user => @attr
          controller.should be_signed_in
        end
      
      end
      
    end
    
    context "when logged in" do
      
      before(:each) do
        test_sign_in(Factory(:user))
      end
      
      it "redirects to the root path" do
        post :create, :user => @attr
        response.should redirect_to(root_path)
      end
      
    end
    
  end
  
  describe '#edit', '(GET)' do
    
    context 'when not logged in' do
      
      before(:each) do
        @user = Factory(:user)
        get :edit, :id => @user.username
      end

      it "is not successful" do
        response.should_not be_success
      end
      
      it 'redirects to the signin page' do
        response.should redirect_to(signin_path)
      end

    end

    context 'when logged in' do
      
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      context 'given a user other than current user' do
        
        it 'redirects to rooth path' do
          wrong_user = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
          get :edit, :id => wrong_user.id
          response.should redirect_to(root_path)
        end
        
      end

      context 'given the current user' do
        
        before(:each) do
          get :edit, :id => @user.id
        end
        
        it "is successful" do
          response.should be_success
        end

        it "has the correct title" do
          page.has_content?("Profile Settings")
        end
        
      end
    end
    
  end
  
  describe '#update', 'PUT' do
    
    context 'when not logged in' do
      
      before(:each) do
        @user = Factory(:user)
        put :update, :id => @user.id, :user => {}
      end
      
      it 'is not successful' do
        response.should_not be_success
      end
      
      it "redirects to the signin path" do
        response.should redirect_to(signin_path)
      end
      
    end
    
    context "when logged in" do
  
      before(:each) do
        @user = Factory(:user)
        test_sign_in(@user)
      end
      
      context "given a user other than current user" do
        it 'redirects to rooth path' do
          wrong_user = Factory(:user, :username => Factory.next(:username), :email => Factory.next(:email))
          put :update, :id => wrong_user.id, :user => {}
          response.should redirect_to(root_path)
        end
      end
  
      context "given invalid parameters" do
        before(:each) do
          @attr = { :email => "", :name => "", :password => "",
                    :password_confirmation => "" }
          put :update, :id => @user.id, :user => @attr
        end
        
        it "renders the 'edit' page" do
          response.should render_template('edit')
        end
  
        it "should have the right title" do
          page.has_content?("Profile Settings")
        end
      end
  
      context 'given valid parameters' do
        before(:each) do
          @attr = { :current_password => @user.password, :name => "New Name", :email => "user@example.org",
                    :password => "barbaz", :password_confirmation => "barbaz" }
          put :update, :id => @user.id, :user => @attr
        end
  
        it "changes the user's attributes" do
          @user.reload
          @user.name.should  == @attr[:name]
          @user.email.should == @attr[:email]
        end
  
        it "redirects to the user edit page" do
          response.should redirect_to(edit_user_path(@user))
        end
  
        it "displays a message that the user was updated" do
          flash[:success].should =~ /updated/i
        end
      end
      
    end
    
  end  

end
