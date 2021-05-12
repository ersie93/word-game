require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
  	@alpha = [*('A'..'Z')]
  	@letters = (10).times.map { @alpha.sample }
  end

  def score
  	@attempt = params[:word]
    @valid = valid_word(@attempt)
    @includes = included(@attempt, params[:token])
    @isValid = (@includes == true) && (@valid == true) ? true : false
    @score = @isValid ? @attempt.length * 2 : "Not in the grid!"
  end

  def valid_word(attempt)
    api_url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    json_file = open(api_url).read
    parsed = JSON.parse(json_file)
    parsed["found"]
  end

  def included(attempt, grid)
    notInGrid = attempt.upcase.chars.reject do |element|
      attempt.upcase.count(element) <= grid.count(element)
    end
    notInGrid.count > 0 ? false : true
  end
end
