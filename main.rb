require 'pry-byebug'

# Game of Mastermind

# create a constant array of colors(R, G, B, W, B)
COLOR_KEYS = ['Q', 'W', 'E', 'R', 'T'].freeze

# Computer randomly selects secret colors
# create computer class
# method to randomly select 4 colors
class Computer
  attr_reader :code
  def initialize
    @code = COLOR_KEYS.sample(4).join
  end
end

# Human Player has to guess the code
class Player
  attr_reader :guesses
  attr_accessor :guess_count

  def initialize
    @guess_count = 0
    @guesses = []
  end
end

class Game
  attr_reader :creator, :guesser
  def initialize(creator, guesser)
    @creator = creator
    @guesser = guesser
  end

  def play
    loop do
      if @guesser.guess_count > 12
        puts "Run out of guess\nComputer's code is #{@creator.code}"
        break
      end
      puts "Enter your guess: "
      guess = gets.chomp.to_s
      break if check?(guess)
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

end

computer = Computer.new
player = Player.new
game = Game.new(computer, player)

game.play