class Turn
  attr_reader :player1, :player2, :spoils_of_war, :type

  def initialize(player1, player2)
    @player1       = player1
    @player2       = player2
    @spoils_of_war = []
    @type_class    = {[false, false] => :basic,
                      [false, true] => :basic,
                      [true, false] => :war,
                      [true, true] => :mutually_assured_distruction}
  end

  def compaire(index)
    player1.deck.cards.slice(index).rank ==
    player2.deck.cards.slice(index).rank
  end

  def check_winner(index)
    if player1.deck.cards.slice(index).rank > player2.deck.cards.slice(index).rank
      @winner = @player1
    else
      @winner = @player2
    end
  end

  def type
    if player1.deck.cards.length >= 3 && player2.deck.cards.length >= 3
      @type_of_turn = @type_class[[compaire(0), compaire(2)]]
    else
      @type_of_turn = @type_class[[compaire(0), false]]
    end
  end

  def winner
    if @type_of_turn == :basic
      check_winner(0)
    elsif @type_of_turn == :war
      check_winner(2)
    else
      "No Winner"
    end
  end

  def pile_cards
    if @type_of_turn == :basic
      @spoils_of_war << player1.deck.remove_card
      @spoils_of_war << player2.deck.remove_card
    elsif @type_of_turn == :war
      3.times do
        @spoils_of_war << player1.deck.remove_card
        @spoils_of_war << player2.deck.remove_card
      end
    else
      3.times do
        player1.deck.remove_card
        player2.deck.remove_card
      end
    end
  end

  def award_spoils
    @spoils_of_war.each do |card|
      @winner.deck.cards << card
    end
    @spoils_of_war = []
  end
end
