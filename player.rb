class Player
attr_accessor :misses , :guess , :guess_history

def intialize 
    @guess = ''
    @misses =[]
    @guess_history= []
end

def player_input
input = gets.chomp.downcase
if input == 'save'
    @guess = input
else
    valid_input(input)
end 
end

def valid_input(input = '')
    until input.length == 1 && input =~ /[a-z]/
        puts "\n Enter a valid guess (one letter a - z)."
    input =gets.chomp.downcase
    end

    def history(input)
        if @guess_history.include?(input)
            puts "you are already tried that one!"
            valid_input
        else
            false
        end
    end
end
end
