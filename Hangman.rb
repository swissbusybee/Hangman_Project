require './string'
require 'openssl'
require 'yaml'

class Hangman

  def initialize
    @words = []

    # Read each line from file and remove blanks and \n
    File.foreach("5desk.txt") do |line|
      @words << line.chomp
    end

    @wrong_guess = 0
    @player_guess = []
    @word = generate_random_word.downcase

  end

  def generate_random_word
    words = []
    words = @words.select { |word| word.length.between?(5, 12) }
    words.sample
  end

  def print_hangman
    puts "\n\n"
    puts  "           _________".color(:yellow)
    puts  "          ||/       |".color(:yellow)
    print "          ||        ".color(:yellow)
    puts  @wrong_guess > 0? "()" : ""
    print "          ||       ".color(:yellow)
    if @wrong_guess > 5
      puts "/|\\".color(:red)
    elsif @wrong_guess > 4
      puts "/|".color(:red)
    elsif @wrong_guess > 1
      puts " |".color(:red)
    else
      puts ""
    end
    print  "          ||        ".color(:yellow)
    puts @wrong_guess > 1? "|".color(:blue) : ""
    print  "          ||       ".color(:yellow)
    if @wrong_guess > 3
      puts "/ \\".color(:blue)
    elsif @wrong_guess > 2
      puts "/".color(:blue)
    else
      puts ""
    end
    puts  "          ||".color(:yellow)
    puts  "    ______||_________".color(:yellow)
    puts  "   /      ||        /|".color(:yellow)
    puts  "  /                / |".color(:yellow)
    puts  " /________________/ /".color(:yellow)
    puts  "|                | /".color(:yellow)
    puts  "|________________|/".color(:yellow)
  end

  def print_word
    puts "\n\n"
    print "   "
    @word.split("").each { |i| print @player_guess.include?(i)? "#{i} " : "_ " }
    puts "\n\n\n"
  end

  def print_guesses
    puts "Your guesses: #{@player_guess.join(", ")}"
    puts ""
    chances = 7 - @wrong_guess
    puts chances == 1 ? "LAST CHANCE!".color(:red) : "Chances: #{chances} left!"
    puts "\n\n"
  end

  def input_valid?(input)
    if !input.match(/[a-z]|S/).nil? && !@player_guess.include?(input)
      true
    else
      false
    end
  end

  def right_guess?(input)
    @word.include?(input)
  end

  def player_win?
    @word.split("").all? { |i| @player_guess.include?(i) }
  end

  def start_game
    puts "\n\n"
    puts "*****   Welcome to Hangman!   *****"
    puts "\n\n"
    puts "    **************************"
    puts "    *                        *"
    puts "    *   1. Play Game         *"
    puts "    *   2. Load Saved Game   *"
    puts "    *                        *"
    puts "    **************************"
    puts ""
    print "Please select an option: "
    input = gets.chomp

    while input != "1" && input != "2"
      print "The input is invalid. Try again: "
      input = gets.chomp
    end

    input == "1" ? play : load_game

  end

  def play

    while @wrong_guess < 7
      print_hangman
      print_word
      print_guesses
      print "Please enter a letter from 'a' to 'z' (or 'S' to save your game): "
      input = gets.chomp

      while !input_valid?(input)
        print "Your input is invalid. Try again!: "
        input = gets.chomp
      end

      # Save the game and exit
      if input == 'S'
        save_game
        return
      end

      # Add the guess to the list of guesses
      @player_guess << input

      if !right_guess?(input)
        @wrong_guess += 1
      elsif player_win?
        break
      end

    end

    end_game

  end

  def end_game
    print_hangman
    print_word
    print_guesses

    if @wrong_guess == 7
      puts "     ***************************"
      puts "     *                         *"
      puts "     *" + "        GAME OVER        ".color(:red) + "*"
      puts "     *                         *"
      puts "     ***************************"
      puts ""
    else
      puts "     **************************"
      puts "     *                        *"
      puts "     *" + "        YOU WIN!        ".color(:green) + "*"
      puts "     *                        *"
      puts "     **************************"
      puts ""
    end
    puts ""
    puts "The word was: #{@word}"
    puts ""

  end

  def save_game
    data = {}
    data[:word] = @word
    data[:wrong_guess] = @wrong_guess
    data[:player_guess] = @player_guess

    print "Please enter a file name where the game will be saved: "
    file_name = gets.chomp

    yaml = YAML::dump(data)
    game_file = File.new("#{file_name}.yaml", "w")
    game_file.write(yaml)
    puts "Your game has been saved!"
  end

  def load_game
    print "Please enter the file name where the game was saved: "
    file_name = gets.chomp
    yaml = YAML::load_file("#{file_name}.yaml")

    @word = yaml[:word]
    @wrong_guess = yaml[:wrong_guess]
    @player_guess = yaml[:player_guess]

    play
  end

end

game = Hangman.new
game.start_game
