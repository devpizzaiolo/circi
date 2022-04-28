class PizzaContestVotesController < ApplicationController  
  #before_filter :set_page_title
  
  def index
    @pizza_contest_vote = PizzaContestVote.new
  end
  
  def new
    @pizza_contest_vote = PizzaContestVote.new
  end
  
  def create
    @pizza_contest_vote = PizzaContestVote.new
    @pizza_contest_vote = PizzaContestVote.new(params[:pizza_contest_vote])
    if self.vote_exist
      flash[:error] = "<strong>You have already submited your vote, you can not submit more than once."
      render :new
    else
      if @pizza_contest_vote.save
        redirect_to pizza_contest_vote_path(1)
      else
        flash[:error] = "<strong>There was a problem registering your vote</strong><br />Please verify your infomation and try again."
        render :new
      end 
    end

    
    
  end

  def vote_exist
     PizzaContestVote.find_by_email(params[:pizza_contest_vote][:email]) ? true : false
  end

  def show
    
  end
  
end
