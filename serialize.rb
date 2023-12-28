module Serialize

    def old_game
        if File.exist?('./saved_games')
            puts "saved files: #{Dir.children('./saved_games').join(', ')}"
            puts 'Enter file name "filename.yml"'
            filename = gets.chomp
        else
            puts 'there are no files'
            saved_or_new
        end 
    end

    def to_yaml(filename)
        Dir.mkdir('saved_game') unless File.exist?('saved_game')
        f = File.open("saved_game/#{filename}.yml",'w')
        YAML.dump({:word =>@word,:display => @display ,:life => @life ,:player_misses => @player.misses ,:player_guess => @player.guess_history}, f)
f.close
puts "\n Game Saved!"
    end

    def from_yaml(filename)
        f = YAML.load(File.read("./saved_games/#{filename}"))
        @word = f[:word]
        @display = f[:display]
        @player.misses = f[:player_misses]
        @player.guess_history = f[:player_guess_history]
    end
end
