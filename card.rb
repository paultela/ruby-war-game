class Card
    ##
    # Represents a single card in a standard deck.
    #
    
    # The Comparable mixin allows us to compare objects
    # using any of the comparison operators by only implementing
    # the <=> method.
    include Comparable

    # We want the suit and rank of a card to not be editable once
    # the card is created.
    attr_reader :rank, :suit

    # Our constructor takes the rank and suit for the card
    def initialize(rank, suit)
        @rank = rank
        @suit = suit
    end

    # By defining this method on our class and including the Comparable
    # mixin above, we get support for ==, <=, <, >=, > and !=
    def <=>(another_card)
        ##
        # We are only comparing cards based on their rank, so we can 
        # just return the result of the same operator on the cards'
        # rank attribute
        
        @rank <=> another_card.rank
    end

    def to_s
        ##
        # Returns a string representation of the card.
        #
        
        case (@rank)
        when 11
            "Jack of " << @suit.to_s
        when 12
            "Queen of " << @suit.to_s
        when 13
            "King of " << @suit.to_s
        when 14
            "Ace of " << @suit.to_s
        else
            @rank.to_s << " of " << @suit.to_s
        end
    end
end
