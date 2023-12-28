class SecretWord
    attr_accessor :choice

    def initialize 
    @choice
    end

    def select_word
        word_array = []
        word_list = File.open('./google-10000-english.txt')
        word_list.each do |word|
            word_array << word if word.length >= 5 && word.length <= 12
        end
        @choice = word_array.sample
    end
end
