# Game of Mastermind

# create a constant array of colors(R, G, B, W, B)
COLOR_KEYS = ['R', 'G', 'B', 'W', 'B'].freeze

module Feedback
  def key
    
  end
end

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
  attr_reader :guess_count, :guesses
  def initialize
    @guess_count = 0
    @guesses = []
  end
end

class Game
  include Feedback

  attr_reader :creator, :guesser
  def initialize(creator, guesser)
    @creator = creator
    @guesser = guesser
  end

  def play
    loop do
      if @guesser.guess_count > 12
        puts "Run out of guess"
        break
      end
      puts @creator.code
      puts "Enter your guess: "
      guess = gets.chomp.to_s
      if guess == @creator.code
        puts 'Correct!'
        break
      end
    end
  end

end

computer = Computer.new
player = Player.new
game = Game.new(computer, player)

game.play