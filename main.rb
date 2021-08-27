require 'pry-byebug'

# Game of Mastermind

# create a constant array of colors(R, G, B, W, B)
COLOR_KEYS = ['Q', 'W', 'E', 'R', 'T'].freeze
module Helper
  def generate_code
    COLOR_KEYS.sample(4).join
  end

  def computer_check?(guess)
    if guess == @creator.code
      puts "I've correctly guessed it. It is #{guess}"
      return true
    end
    false
  end
end

class Creator
  attr_reader :code
  def initialize(code=COLOR_KEYS.sample(4).join)
    @code = code
  end
end

class Guesser
  attr_reader :guesses
  attr_accessor :guess_count

  def initialize
    @guess_count = 0
    @guesses = []
  end
end

class Game
  include Helper

  attr_reader :creator, :guesser
  def initialize(creator, guesser)
    @creator = creator
    @guesser = guesser
  end

  def play
    loop do
      puts "Your previous guesses are: \n#{@guesser.guesses}"
      break if guess_maximum?
      puts "Enter your guess: "
      guess = gets.chomp.to_s
      track_guess(guess)
      break if check?(guess)
    end
  end

  def computer_play
    #guess = generate_code
    loop do
      guess = generate_code
      break if guess_maximum?
      puts "My guess is #{guess}"
      @guesser.guess_count += 1
      break if computer_check?(guess)
    end
  end

  private

  def check?(guess)
    @guesser.guess_count += 1
    correct_position = 0
    if guess == @creator.code
      puts "Correct! It took you #{guesser.guess_count} guesses!"
      return true
    end

    4.times do |i|
      if @creator.code.split('')[i] == guess.split('')[i]
        correct_position += 1
      end
    end
    puts "You have #{correct_position} colors in position."
    correct_position = 0
    false
  end

  def track_guess(guess)
    @guesser.guesses.push(guess)
  end

  def guess_maximum?
    if @guesser.guess_count > 12
      puts "Run out of guesses. The correct code is #{@creator.code}"
      return true
    end
    false
  end
end

guesser = Guesser.new
creator = Creator.new('QWER')
game = Game.new(creator, guesser)
game.computer_play