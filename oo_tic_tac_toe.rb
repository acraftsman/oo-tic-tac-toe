# Description: There is a board. It has a 3*3 square. Players take turns to place their marker on a empty square of the board. Player wins the game when their markers lie in a line. If there is no empty square of the board, and no winner. It's a tie.
# nouns => board, player, marker
# verbs => place a marker
# states => markers lie in a line, empty square
require "pry"
class Board
  attr_accessor :squares_status
  attr_accessor :empty_squares
  def initialize
    self.squares_status = {1 => ' ', 2 => ' ', 3 => ' ',
                           4 => ' ', 5 => ' ', 6 => ' ', 
                           7 => ' ', 8 => ' ', 9 => ' '}
    self.empty_squares = nil
    
  end

  def draw
    system "clear"
    puts "     |     |     "
    puts "  #{squares_status[1]}  |  #{squares_status[2]}  |  #{squares_status[3]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{squares_status[4]}  |  #{squares_status[5]}  |  #{squares_status[6]}  "
    puts "     |     |     "
    puts "-----+-----+-----"
    puts "     |     |     "
    puts "  #{squares_status[7]}  |  #{squares_status[8]}  |  #{squares_status[9]}  "
    puts "     |     |     "
  end

  def has_empty_square?
    get_empty_squares.size > 0
  end

  def get_empty_squares
    empty_squares = squares_status.select{ |k, v| v == ' ' }
  end
end

class Player
  attr_accessor :name, :marker, :board
  def initialize(name, marker, board)
    self.name = name
    self.marker = marker
    self.board = board
  end

  def place_marker
  end

  def mark(position, marker)
    board.squares_status[position] = marker
  end
end

class Human < Player
  def place_marker
    begin
      puts "place a marker(position: 1-9)"
      position = gets.chomp.to_i
    end until board.get_empty_squares.keys.include?(position)
    mark(position, marker)
  end
end


class Computer < Player
  def place_marker
    position = board.get_empty_squares.keys.sample
    mark(position, marker)
  end
end

class Judgment
  attr_accessor :winning_line, :board, :has_result
  def initialize(board)
    self.winning_line = [[1, 2, 3], [4, 5, 6], [7, 8, 9], 
                         [1, 4, 7], [2, 5, 8], [3, 6, 9],
                         [1, 5, 9], [3, 5, 7]]
    self.board = board
    self.has_result = false
  end

  def judge(player1, player2)
    winning_line.each do |arr|
      if (board.squares_status[arr[0]] == player1.marker &&
          board.squares_status[arr[1]] == player1.marker &&
          board.squares_status[arr[2]] == player1.marker)
        say "#{player1.name} won!"
        has_result = true
        return has_result
      elsif (board.squares_status[arr[0]] == player2.marker &&
             board.squares_status[arr[1]] == player2.marker &&
             board.squares_status[arr[2]] == player2.marker)
        say "#{player2.name} won!"
        has_result = true
        return has_result
      end  
    end
    if !board.has_empty_square?
      say "It's a tie!"
      has_result = true
      return has_result
    else
      has_result = false
    end
  end

  private
  def say(msg)
    puts "=> #{msg}"
  end
end

class Game
  attr_reader :board, :human, :computer, :judgment
  def initialize
    @board = Board.new
    @human = Human.new("Alan", "X", board) 
    @computer = Computer.new("Mac", "O", board)
    @judgment = Judgment.new(board)
  end

  def play
    board.draw
    loop do
      human.place_marker
      board.draw
      break if judgment.judge(human, computer)

      computer.place_marker
      board.draw
      break if judgment.judge(human, computer)
    end
  end
end

loop do
  Game.new.play
  puts "Play again?(y/n)"
  is_play = gets.chomp
  break unless is_play == 'y'
end
