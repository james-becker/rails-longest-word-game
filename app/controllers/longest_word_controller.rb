require 'open-uri'
require 'json'
# require 'pry-byebug'

class LongestWordController < ApplicationController

# start_time = Time.now
# attempt = gets.chomp
# end_time = Time.now

# puts "******** Now your result ********"

# result = run_game(attempt, grid, start_time, end_time)



  # Should I define this here to make it accesible to Game and Score?

  def game
    @grid = generate_grid(9).join
    @start_time = Time.now
  end

# $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

  def score
    @attempt = params[:attempt]
    @grid = params[:grid]
    @start_time = Time.parse(params[:start_time])
    @end_time = Time.now

    #does this need to be a class variable?
    @results = run_game(@attempt, @grid, @start_time, @end_time)
  end

  private

  def generate_grid(grid_size)
    puts 'generating'
    (0...grid_size).map { (65 + rand(26)).chr }
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    attempt = attempt.downcase
    url = "https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=5d632143-f289-47ed-afda-c4050f108a86&input=#{attempt}"

    systran_data = JSON.parse(open(url).read)

    translation = systran_data["outputs"][0]["output"]

    elapsed_time = start_time - end_time


    # binding.pry


    score = calc_score(attempt, grid, elapsed_time)

    if score.zero?
      message = "not in the grid"
    elsif translation == attempt
      translation = nil
      score = 0
      message = "not an english word"
    else
      message = "well done"
    end

    return { time: elapsed_time, translation: translation, score: score, message: message }
  end


  def calc_score(attempt, grid, elapsed_time)
    attempt = attempt.downcase.split('')
    grid = grid.split('')

    grid_h = Hash.new(0)
    attempt_h = Hash.new(0)
    grid.each { |l| grid_h[l.downcase] ? grid_h[l.downcase] += 1 : grid_h[l.downcase] = 1 }
    attempt.each { |l| attempt_h[l.downcase] ? attempt_h[l.downcase] += 1 : attempt_h[l.downcase] = 1 }

    attempt_h.each do |k, _|
      return 0 if !grid_h.key?(k) || grid_h[k] < attempt_h[k]
    end

    return attempt.length + (elapsed_time * 2)
  end

end
