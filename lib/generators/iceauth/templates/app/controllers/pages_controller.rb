class PagesController < ApplicationController
  before_filter :set_title
  
  def home
  end

  def contact
  end

  def about
  end

  def help
  end
  
  private
    
    def set_title
      @title = params[:action].titleize
    end

end
