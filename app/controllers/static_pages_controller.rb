class StaticPagesController < ApplicationController

  before_filter :disable_sidebar

  def home; end

  def about; end

  def team; end

  def code_of_conduct; end

  def cancellation_policy; end

  def terms_and_conditions; end
end
