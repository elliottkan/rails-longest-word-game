require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters.push(("a".."z").to_a.sample) }
    # raise
  end


  def score
    attempt = params[:word]
    letters = params[:letters].split("")
    @score = 0
    if check_word(attempt)["found"] && match_letters_attempt(attempt, letters)
      @score = (1 * check_word(attempt)["length"]).to_i
      @message = "well done"
    elsif !check_word(attempt)["found"]
      @message = "not an english word"
    elsif !match_letters_attempt(attempt, letters)
      @message = "not in the letters"
    end
  end

  def check_word(word_to_check)
    url = "https://wagon-dictionary.herokuapp.com/#{word_to_check}"
    word_serialized = URI.open(url).read
    word_info = JSON.parse(word_serialized)
    return word_info
  end

  def match_letters_attempt(attempt, letters)
    attempt_chars = attempt.chars
    letters.map! { |letter| letter.downcase }
    result = true
    attempt_chars.each { |char| letters.include?(char) ? letters.delete_at(letters.index(char)) : result = false }
    return result
  end
end
