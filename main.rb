require 'yaml'
require './player'
require './word'
require './serialize'

class Game 
include Serialize
attr_accessor :player,:word,:life,:display

def initialize
    @word = SecretWord.new
    @player = Player.new
    @display = ''
    @life = 10
    saved_or_new
end

def saved_or_new
puts "Enter '1' for a new game and '2' for a saved game."
input = gets.chomp
  if input == '1'
    @word.select_word
    play_game
  else
    old_game
puts @display.join(' ')
play_game
  end
  end

def display
    if @display == ''
        length = word.choice.strip!.length
        @display = Array.new(length,'_')
        puts @display.join(' ')
        puts "\n"
    else 
        false
    end
end

def save_game
if player.guess == 'save'
    puts 'Enter a filname without space.'
    filename = gets.chomp
    to_yaml(filename)
end
end

  def match
    return false if @player.guess == 'save'
    if @word.choice.include?(@player.guess) 
        word_array = @word.choice.split(/ /)
        word_array.each_with_index do |letter,index|
            @display[index] = letter if letter == @player.guess
        end
        puts "\ngreat, '#{player.guess}' is in the word.\n"
        puts @display.join(' ')
    else
         miss
    end
end

  def miss
player.misses << @player.guess
puts "\n '#{player.guess}' is not in the word."
puts "Missess: #{player.misses.join(',')}"
puts "\n"
@life -= 1
puts @display.join(' ')
puts "\n"
end

def winner
    if @display == @word.choice.split(/ /)
puts "Hurry! you win"
@life = 0
    elsif @life.zero?
    puts "you lose, The word was '#{@word.choice}'."
    end
end

def replay
    puts "Enter 'y' to play again and 'n' to exit."
    output = get.chomp.downcase
    if output == 'y'
        new_game
    elsif output == 'n'
        puts"thanks for playing"
        return
    end
end

def new_game
    new = Game.new
    new.play_game
end

  def play_game
    display
    until @life.zero?
        puts "life left: #{@life}"
@player.player_input
save_game
match
winner
    end
    replay
  end
end

puts "Welcome to Hangman.\nYou got 10 attempts to guess the word.\nBest of luck!".center(100)
Game.new