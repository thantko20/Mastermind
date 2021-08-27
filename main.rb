# frozen_string_literal: true

# create a constant array of colors(R, G, B, W, B)
COLOR_KEYS = %w[Q W E R T].freeze

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

  # This helper method increases computer's intel
  def feedback(key)
    case key.length
    when 1
      key = key.concat(generate_code(3)).split('').shuffle
      return key.join
    when 2
      key = key.concat(generate_code(2)).split('').shuffle
      return key.join
    when 3
      key = key.concat(generate_code(1)).split('').shuffle
      return key.join
    when 4
      key = key.split('').shuffle
      return key.join
    end

    generate_code(4)
  end
end

class Creator
  attr_reader :code

  def initialize(code = COLOR_KEYS.sample(4).join)
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

  # This method can be called to play player as a guesser
  def play
    loop do
      puts "Your previous guesses are: \n#{@guesser.guesses}"
      puts "#{12 - @guesser.guess_count} guesses left"
      break if guess_maximum?

      puts 'Enter your guess: '
      guess = gets.chomp.to_s
      track_guess(guess)
      break if check?(guess)
    end
  end

  # This method can be called to play computer as a guesser
  def computer_play
    key = ''
    loop do
      guess = feedback(key)
      next if @guesser.guesses.include?(guess) # This one line of code reduces amount of guesses that computer took.

      track_guess(guess)
      break if guess_maximum?

      puts "My guess is #{guess}"
      @guesser.guess_count += 1
      break if computer_check?(guess)

      puts 'Provide me with the letters that match(Position doesn\'t matter. Don\'t type duplicated letters from my guess if yours doesn\'t have duplicates.): '
      key = gets.chomp.to_s
      puts '--------------------'
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
      correct_position += 1 if @creator.code.split('')[i] == guess.split('')[i]
    end

    puts "You have #{correct_position} letters in position."
    puts '--------------------'
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

def mastermind
  guesser = Guesser.new

  puts "Welcome to Mastermind! Here you'll have to guess the code created by computer. Or computer can be the guesser!"
  puts "Given keys to guess or create are #{COLOR_KEYS}"
  puts 'Type 1 if you want to guess or 2 if you want the computer to guess!'

  input = 0
  loop do
    input = gets.chomp.to_i
    puts '--------------------'
    break if input.between?(1, 2)
  end

  if input == 1
    puts 'You have 12 guesses. Goodluck!'
    creator = Creator.new
    game = Game.new(creator, guesser)
    game.play
  else
    puts "You have to create code from given letters #{COLOR_KEYS}"
    puts 'Create the code: '
    code = gets.chomp.to_s
    puts '--------------------'
    creator = Creator.new(code)
    game = Game.new(creator, guesser)
    game.computer_play
  end
end

mastermind
