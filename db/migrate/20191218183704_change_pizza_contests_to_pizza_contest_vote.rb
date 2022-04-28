class ChangePizzaContestsToPizzaContestVote < ActiveRecord::Migration
  def change
    rename_table :pizza_contests, :pizza_contest_votes
  end
end
