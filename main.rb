require 'fileutils'

class Hangman
  attr_accessor :word, :guessed_letters, :attempts_left

  def initialize(word, guessed_letters = [], attempts_left = 6)
    @word = word.downcase
    @guessed_letters = guessed_letters.map(&:downcase)
    @max_attempts = 6
    @attempts_left = attempts_left
  end

  def display_word
    display = ""
    @word.chars { |letter| display += @guessed_letters.include?(letter) ? letter : '_' }
    display
  end

  def make_guess(letter)
    letter.downcase!
    return if @guessed_letters.include?(letter)

    @guessed_letters << letter
    @attempts_left -= 1 unless @word.include?(letter)
  end

  def game_over?
    @attempts_left.zero? || win?
  end

  def win?
    @word.chars.all? { |letter| @guessed_letters.include?(letter) }
  end

  def to_s
    "Word: #{display_word}\nAttempts left: #{@attempts_left}"
  end
end

class HangmanGame
  SAVED_GAMES_FOLDER = "saved_games"

  def initialize
    @dictionary = load_dictionary
    @saved_games_folder = SAVED_GAMES_FOLDER
    FileUtils.mkdir_p(@saved_games_folder) unless File.directory?(@saved_games_folder)
  end

  def load_dictionary
    File.readlines("google-10000-english.txt").map(&:strip)
  end

  def select_random_word
    @dictionary.sample
  end

  def save_game(game, filename)
    File.open(File.join(@saved_games_folder, "#{filename}.txt"), 'w') { |file| file.puts(Marshal.dump(game)) }
  end

  def load_saved_games
    saved_games = []
    Dir.glob(File.join(@saved_games_folder, '*.txt')).each do |file_path|
      saved_games << File.basename(file_path, '.txt')
    end
    saved_games
  end

  def load_game(filename)
    file_path = File.join(@saved_games_folder, "#{filename}.txt")
    return nil unless File.exist?(file_path)

    Marshal.load(File.read(file_path))
  end

  def play_again?
    puts "\nDo you want to play again? (y/n): "
    gets.chomp.downcase == 'y'
  end

  def play_game
    loop do
      puts "Welcome to Hangman!"
      puts "1. Start a new game"
      puts "2. Load a saved game"
      print "Choose an option (1 or 2): "
      option = gets.chomp.to_i

      if option == 1
        word_to_guess = select_random_word
        game = Hangman.new(word_to_guess)
      elsif option == 2
        saved_games = load_saved_games
        if saved_games.empty?
          puts "No saved games found. Starting a new game."
          word_to_guess = select_random_word
          game = Hangman.new(word_to_guess)
        else
          puts "Select a saved game:"
          saved_games.each_with_index { |saved_game, index| puts "#{index + 1}. #{saved_game}" }
          print "Enter the number of the saved game: "
          selected_game_index = gets.chomp.to_i - 1
          game = load_game(saved_games[selected_game_index])
        end
      else
        puts "Invalid option. Starting a new game."
        word_to_guess = select_random_word
        game = Hangman.new(word_to_guess)
      end

      until game.game_over?
        puts "\n#{game}"
        print "Guess a letter or type 'save' to save the game: "
        input = gets.chomp

        if input.downcase == 'save'
          print "Enter the filename to save: "
          filename = gets.chomp
          save_game(game, filename)
          puts "Game saved as #{filename}."
          next
        end

        if input =~ /^[a-zA-Z]+$/ && input.length == 1
          if game.guessed_letters.include?(input.downcase)
            puts "You already guessed '#{input}'. Try a different letter."
          else
            game.make_guess(input)
          end
        else
          puts "Invalid input. Please enter a valid alphabetical letter or 'save' to save the game."
        end
      end

      if game.win?
        puts "\nCongratulations! You guessed the word: #{game.word}"
      else
        puts "\nGame over! The word was: #{game.word}"
      end

      break unless play_again?
    end
  end
end

# Example usage
hangman_game = HangmanGame.new
hangman_game.play_game