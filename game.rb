require 'gosu'


class Blackjack < Gosu::Window
  def initialize
    super 640, 480
    self.caption = 'Blackjack'
    @locs = [0]
    start
  end

  def needs_cursor?
    true
  end

  def update
    @player.update
    @computer.update
    @board.update(@player, @computer)
  end

  def draw
    @player.draw
    @computer.draw
    @board.draw
  end

  def button_down(id)
    case id
      when Gosu::MsLeft
        @locs << [mouse_x.to_i, mouse_y.to_i]
        @player.hand[@player.hand.map {|x| ((@locs.last[0] - x.coords[0]).between?(0, 320 / (@player.hand.size))) and ((@locs.last[1] - x.coords[1]).between?(0, 380))}.index(true)].flip unless @player.hand.map {|x| ((@locs.last[0] - x.coords[0]).between?(0, 320 / (@player.hand.size))) and ((@locs.last[1] - x.coords[1]).between?(0, 380))}.index(true).nil?
        $deck.give_cards(@player, 1) if @locs.last[0].between?(220, 314) and @locs.last[1].between?(200, 240)
        if @locs.last[0].between?(220, 400) and @locs.last[1].between?(200, 280) and @board.over
          start
          return
        end
        @computer.turn = true if @locs.last[0].between?(320, 416) and @locs.last[1].between?(200, 240)
    end
  end
end


class Game
  attr_accessor :over, :won

  def initialize
    @hit = Gosu::Image.new("media/hit.png")
    @stand = Gosu::Image.new("media/stand.png")
    @win = Gosu::Image.new("media/won.png")
    @tie = Gosu::Image.new("media/tie.png")
    @lose = Gosu::Image.new("media/lost.png")
    @over = false
    @won = false
  end

  def update(player, computer)
    self.stand(player, computer) if computer.turn == true or player.points > 21
  end

  def draw
    unless over
      @hit.draw(220, 200, 0)
      @stand.draw(320, 200, 0)
    else
      @win.draw(220, 200, 0) if @won
      @lose.draw(220, 200, 0) unless @won and !@won.nil?
      @tie.draw(220, 200, 0) if @won.nil?
    end

  end

  def stand(player, computer)
    if player.points > 21
      @won = false
    elsif player.points == computer.points
      @won = nil
    elsif player.points > computer.points or !computer.points.between?(0,21)
      @won = true
    else
      @won = false
    end
    player.hand[0].flip if player.hand[0].hidden
    computer.hand[0].flip if computer.hand[0].hidden
    @over = true
  end
end

def start
  @player = Player.new
  $deck = Deck.new
  $deck.give_cards(@player, 2)
  @computer = Opponent.new
  $deck.give_cards(@computer, 2)
  @board = Game.new
end


class Deck
  attr_accessor :cards

  def draw
    @image = Gosu::Image.new("media/cardDown.png")
    @image.draw(240, 200, 0)
  end

  def initialize()
    self.shuffle
  end

  def give_cards(player, num)
    num.times do
      player.hand << (self.cards.pop)
    end
  end

  def shuffle
    @cards = []
    suits = %w[ Hearts Diamonds Clubs Spades ]
    values = %w[ A 2 3 4 5 6 7 8 9 10 J Q K ]
    points = {"A" => 1, "J" => 10, "Q" => 10, "K" => 10}
    suits.each do |suit|
      values.each do |value|
        @card = Card.new("card#{suit.capitalize}#{value}")
        if points[value].nil?
          @card.points = value.to_i
        else
          @card.points = points[value]
        end
        @cards << @card
      end
    end
    @cards.shuffle!
  end

end


class Player
  attr_accessor :hand, :points

  def initialize
    @hand = []
    @points
  end

  def update
    unless @hand.size.nil?
      @points = @hand.inject(0) {|sum, x| sum + x.points}
    end
    puts @points
  end

  def draw
    @max = 320 - (@hand.size * 140) / 2
    @hand.each_with_index do |card, x|
      if card.coords.nil?
        card.coords = [@max + (x * 140), 290, 0]
      end
      if x == 0 and card.hidden
        @image = Gosu::Image.new("media/cardBack_red3.png")
      else
        @image = Gosu::Image.new("media/#{card.value}.png")
      end
      card.coords = [@max + (x * 140), card.coords[1], 0]
      @image.draw(@max + (x * 140), card.coords[1], card.coords[2])
    end
  end
end


class Card
  attr_accessor :value, :coords, :points, :hidden

  def initialize(value)
    @value = value
    @points = points
    @hidden = true
  end

  def flip
    @hidden = false
    if @points == 11
      @points = 1
    elsif @points == 1
      @points = 11
    end
  end
end


class Opponent
  attr_accessor :hand, :points, :turn

  def initialize
    @hand = []
    @points
    @turn = false
  end

  def update
    unless @hand.find {|x| x.points == 1}.nil?
      @hand.find {|x| x.points == 1}.points = 11
    end

    unless @hand.size.nil?
      @points = @hand.inject(0) {|sum, x| sum + x.points}
    end

    if @points < 17 and @turn
      $deck.give_cards(self, 1)
    end
  end

  def draw
    @max = 320 - (@hand.size * 140) / 2
    @hand.each_with_index do |card, x|
      if card.coords.nil?
        card.coords = [@max + (x * 140), 0, 0]
      end
      if x == 0 and card.hidden
        @image = Gosu::Image.new("media/cardBack_red3.png")
      else
        @image = Gosu::Image.new("media/#{card.value}.png")
      end
      card.coords = [@max + (x * 140), card.coords[1], 0]
      @image.draw(@max + (x * 140), card.coords[1], card.coords[2])
    end
  end
end


Blackjack.new.show
