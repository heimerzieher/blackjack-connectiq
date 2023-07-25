
class BlackjackEngine 
{

    private var decks_number;

    private var deck;

    private var dealer_cards;
    private var player_cards;

    private var playerHandPoints;
    private var dealerHandPoints;

    private var player_bet;
    private var player_money;

    public var status;

    //constructor
    public function initialize(nDecks, money, bet) 
    {
      decks_number = nDecks;

      deck = new Deck(decks_number);
      deck.shuffle();

      player_money = money;
      player_bet = bet;
      
      status = STATUS_IDLE;
    }

    public function getPlayerCards()
    {
      return player_cards;
    }

    public function getDealerCards()
    {
      return dealer_cards;
    }

    public function getPlayerPoints()
    {
      return playerHandPoints;
    }

    public function getDealerPoints()
    {
      return dealerHandPoints;
    }
  
    public function getBet()
    {
      return player_bet;
    }

    public function setBet(bet)
    {
      if(status != STATUS_ACTIVE_ROUND)
      {
        player_bet = bet;
      }
    }

    public function getMoney()
    {
      return player_money;
    }

    //start a new round
    public function startRound()
    {
        status = STATUS_ACTIVE_ROUND;

        playerHandPoints = 0;
        dealerHandPoints = 0;

        dealer_cards = new [2];
        player_cards = new [2];

        dealer_cards[0] = deck.drawCard();
        dealer_cards[1] = deck.drawCard();

        player_cards[0] = deck.drawCard();
        player_cards[1] = deck.drawCard();

        recalculatePoints();

        //System.println(dealer_cards[0].value + " Suit:" + dealer_cards[0].suit );
    }

    public function hit()
    {
        if(status == STATUS_ACTIVE_ROUND)
        {
          player_cards.add(deck.drawCard());

          recalculatePoints();

          if(playerHandPoints > 21)
          {
            status = STATUS_LOST;
            handleEndOfRound();
          }
        }
    }

    public function stand()
    {
        if(status == STATUS_ACTIVE_ROUND)
        {
          while(dealerHandPoints < 17)
          {
            dealer_cards.add(deck.drawCard());
            recalculatePoints();
          }

          if(dealerHandPoints < playerHandPoints)
          {
            status = STATUS_WON;
          }

          if(dealerHandPoints > 21)
          {
            status = STATUS_WON;
          }

          if(dealerHandPoints > playerHandPoints && dealerHandPoints <= 21)
          {
            status = STATUS_LOST;
          }

          if(dealerHandPoints == playerHandPoints)
          {
            status = STATUS_TIE;
          }

          //just for error handling
          if(playerHandPoints > 21)
          {
            status = STATUS_LOST;
          }

          handleEndOfRound();

          System.println("Game ended: "+status);
        }
    }

    private function recalculatePoints()
    {
        playerHandPoints = 0;
        dealerHandPoints = 0;

        var num_aces_player = 0;
        var num_aces_dealer = 0;

        for (var i = 0; i < player_cards.size(); i++)
        {
          var value = player_cards[i].blackjackValue();
          
          if(value == 1)
          {
            num_aces_player +=1;
          }
          
          else
          {
            playerHandPoints += value;
          }

          System.println("Player Hand Card: " + player_cards[i].value + " Suit:" + player_cards[i].suit);
        }

        for (var i = 0; i < num_aces_player; i++)
        {
          if(playerHandPoints + 11 <=21)
          {
            playerHandPoints += 11;
          }

          else
          {
            playerHandPoints += 1;
          }
        }

        System.println("Player Hand Points:" + playerHandPoints);

        for (var i = 0; i < dealer_cards.size(); i++)
        {
          var value = dealer_cards[i].blackjackValue();

          if(value == 1)
          {
            num_aces_dealer +=1 ;
          }
          
          else
          {
            dealerHandPoints += value;
          }

          System.println("Dealer Hand Card: " + dealer_cards[i].value + " Suit:" + dealer_cards[i].suit);
        }

        for (var i = 0; i < num_aces_dealer; i++)
        {
          if(dealerHandPoints + 11 <=21)
          {
            dealerHandPoints += 11;
          }

          else
          {
            dealerHandPoints += 1;
          }
        }

        System.println("Dealer Hand Points:" + dealerHandPoints);
    }

    private function handleEndOfRound()
    {
      if(status != STATUS_ACTIVE_ROUND)
      {
        //we handle the money stuff at the end of a round

        switch(status)
        {
          case STATUS_WON:
            player_money += player_bet;
            break;
          case STATUS_LOST:
            player_money -= player_bet;
            break;

          case STATUS_TIE:
            break;

          default:
            System.println("Unknown status at end of round:" + status);
            break;
        }
      }
    }

}

// numeric values are 2-10, jack=11, queen=12, king=13, ace=1
class Card 
{

  public var value;
  public var suit;

  public function initialize(v,s) 
  {
    value = v;
    suit = s;
  }

  function blackjackValue() 
  {
    if (value >= 10) 
    {
      return 10;
    }
    return value;
  }

  function valueName()
  {
    switch(value)
    {
      case 1:
        return "A";
      case 11:
        return "J";
      case 12:
        return "Q";
      case 13:
        return "K";
      default:
        return value;
    }
  }

}

class Deck 
{
  var cards;

  var top_card_index;

  public function initialize(nDecks) 
  {
    cards = new [52*nDecks];

    var c = 0; 
    
    //d decks
    for(var d = 0; d < nDecks; d++)
    {
      //suits s, v values
      for (var s = 0; s < 4; s++)
      {
        for (var v = 1; v < 14; v++ )
        {
          cards[c] =  new Card(v,s);
          c++;
        }
      }
    }

    top_card_index = c;

  }

  public function drawCard()
  {
    top_card_index--;
    //if the deck is finished shuffle all cards again and draw a new one, bug: it is possible to draw a card that has already been drawn in the same round
    if(top_card_index < 0)
    {
      top_card_index = cards.size() -1;
      shuffle();
    }

    System.println("Index:"+top_card_index+" Size:"+cards.size());


    return cards[top_card_index];
    
  }

  public function shuffle()
  {
    var size = cards.size() - 1;

    for (var i = 0; i < size; i++)
    {
      var j = Math.rand() % (i+1);

      //exchange the ith with a random jth card 
      var c = cards[size - j];

      cards[size - j] = cards[size - i];
      cards[size - i] = c;

      
    }

    // for (var i = 0; i < cards.size(); i++)
    // {
    //   System.println(cards[i].value + " " + cards[i].suit);
    // }
  }
}

enum 
{
  SUIT_CLUBS = 0,
  SUIT_SPADES = 1,
  SUIT_HEARTS = 2,
  SUIT_DIAMONDS = 3
}

enum
{
  STATUS_LOST = 0,
  STATUS_WON = 1,
  STATUS_TIE = 2,
  STATUS_ACTIVE_ROUND = 3,
  STATUS_IDLE = 4

}
