# Game of Mastermind

# create a constant array of colors(R, G, B, W, B)
KEYS = ['R', 'G', 'B', 'W', 'B'].freeze

# Computer randomly selects secret colors
# create computer class
# method to randomly select 4 colors
class Computer
  attr_reader :code
  def initialize
    @code = KEYS.sample(4).join
  end
end

computer = Computer.new
puts computer.code
# Human Player has to guess the code