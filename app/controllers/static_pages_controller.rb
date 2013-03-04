class StaticPagesController < ApplicationController

	def home

	end

  def sandbox
    @feed_items = []
    10.times do |i|
      @feed_items << "Cool Content Item ##{i+1}"
    end
  end
end
