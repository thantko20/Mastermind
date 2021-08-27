require 'pry-byebug'

# Game of Mastermind

# create a constant array of colors(R, G, B, W, B)
COLOR_KEYS = ['Q', 'W', 'E', 'R', 'T', 'Y'].freeze
module Helper
  def generate_code(num)
    COLOR_KEYS.sample(num).join
  end

  def computer_check?(guess)
    if guess == @creator.code
      puts "I've correctly guessed it. It is #{guess}. It took me #{@guesser.guess_count} guesses!"
      return true
    end
    false
  end

  def feedback(key)
    if key.length == 1
      key = key.concat(generate_code(3)).split('').shuffle
      return key.join
    elsif key.length == 2
      key = key.concat(generate_code(2)).split('').shuffle
      return key.join
    elsif key.length == 3
      key = key.concat(generate_code(1)).split('').shuffle
      return key.join
    elsif key.length == 4
      key = key.split('').shuffle
      return key.join
    end
    generate_code(4)
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
    key = ''
    loop do
      guess = feedback(key)
      next if @guesser.guesses.include?(guess)
      track_guess(guess)
      break if guess_maximum?
      puts "My guess is #{guess}"
      @guesser.guess_count += 1
      break if computer_check?(guess)
      puts "Provide me with some clue: "
      key = gets.chomp.to_s
      puts "--------------------"
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
    puts "--------------------"
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
# game.play