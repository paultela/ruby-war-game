require_relative 'card'

class War
    ##
    # The main class for the game, manages setting up, playing, and cleaning up 
    # the game.
    #

    attr_reader :deck, :player_one_deck, :player_two_deck 

    def initialize
        ##
        # Sets up the game with the given number of players
        @deck = [:diamonds, :spades, :hearts, :clubs].map { |suit| (2..14).map { |rank| Card.new(rank, suit) } }.flatten.shuffle

        @player_one_deck = @deck[0..25]
        @player_two_deck = @deck[26..51]
    end

    def play_cards
        ##
        # Takes a card from each players deck and returns them as an array.
        #
        player_one_card = @player_one_deck.shift
        player_two_card = @player_two_deck.shift

        puts "Player 1 played #{player_one_card.to_s} and Player 2 played #{player_two_card.to_s}" 

        [player_one_card, player_two_card]
    end

    def take_turn
        ##
        # Causes both players to play their top card. This is done by shifting the card from the top.
        # A different course of action is taken based on the cards played
        #

        player_one_card, player_two_card = *play_cards

        if player_one_card == player_two_card
            war player_one_card, player_two_card
        elsif player_one_card > player_two_card
            @player_one_deck.push player_two_card, player_one_card
        else
            @player_two_deck.push player_one_card, player_two_card
        end

        puts ""
    end 
    
    def war(player_one_initial_card, player_two_initial_card)
        ##
        # Three cards are placed in temporary decks from the top of each player's
        # deck, then a card is drawn.  Process is repeated until there is a winner.
        # Winner then takes all cards played.
        #
        have_winner = false
        temporary_deck = []
        

        if @player_one_deck.count == 0
            player_one_card = player_one_initial_card
        else
            temporary_deck.push(player_one_initial_card)
            player_one_card = @player_one_deck.shift
        end

        if @player_two_deck.count == 0
            player_two_card = player_two_initial_card
        else
            temporary_deck.push(player_two_initial_card)
            player_two_card = @player_two_deck.shift
        end

        until have_winner
            puts "It's WAR!!"
            shifted_cards =  [@player_one_deck, @player_two_deck].map do |deck|
                # Must be able to play one card
                if deck.count > 3
                    deck.shift(3)
                elsif deck.count > 0 
                    deck.shift(deck.count - 1)
                else
                    puts "Player has #{deck.count} cards"
                    []
                end
            end

            temporary_deck.push(*(shifted_cards.flatten))

            if player_one_card == player_two_card
                # If this is their last card, don't put it in the temporary deck
                if player_one_deck.count > 0
                    temporary_deck.push player_one_card
                else
                    @player_one_deck.push(player_one_card)
                end

                if player_two_deck.count > 0
                    temporary_deck.push player_two_card
                else
                    @player_two_deck.push(player_two_card)
                end

                player_one_card, player_two_card = *play_cards
            else
                have_winner = true
                temporary_deck.push(player_one_card, player_two_card)
            end
        end

        # We have a winner, let's see who it is
        if player_one_card > player_two_card
            puts "Giving #{temporary_deck.count} cards to player 1"
            # Note use of splat operator to expand the array
            @player_one_deck.push(*temporary_deck)
        else
            puts "Giving #{temporary_deck.count} cards to player 2"
            # Note use of splat operator to expand the array
            @player_two_deck.push(*temporary_deck)
        end
    end

    def is_over?
        ##
        # Returns true if the game is over, false otherwise
        #
        @player_one_deck.count == 0 or @player_two_deck.count == 0
    end
        
    def to_s
        ##
        # Returns a string representation of the current game state
        #
        
        "Player 1 has #{@player_one_deck.count} cards, and player two has #{@player_two_deck.count} cards"
    end

    def winner
        ##
        # Returns the winner of the game if it is over, Nil otherwise
        #
        if is_over?
            if @player_one_deck.count > 0 then "Player 1" else "Player 2" end
        end
    end
end

game = War.new

until game.is_over?
    game.take_turn
    puts game.to_s
end

puts "And the winner is #{game.winner}"
