
class BlackjackEngine 
{

    private var decks_number;

    private var deck;

    private var dealer_cards;
    private var player_cards;
    private var player_cards_split1;
    private var player_cards_split2;

    private var playerHandPoints;
    private var playerHandPoints_split1;
    private var playerHandPoints_split2;
    private var dealerHandPoints;

    private var player_bet;
    private var player_money;

    public var status;

    public var split_status;

    //constructor
    public function initialize(nDecks, money, bet) 
    {
      decks_number = nDecks;

      deck = new Deck(decks_number);
      deck.shuffle();

      player_money = money;
      player_bet = bet;

      split_status = 0;
      
      status = STATUS_IDLE;
    }

    public function getPlayerCards()
    {
      return player_cards;
    }

    public function getPlayerCards_split1()
    {
      return player_cards_split1;
    }

    public function getPlayerCards_split2()
    {
      return player_cards_split2;
    }


    public function getDealerCards()
    {
      return dealer_cards;
    }

    public function getPlayerPoints()
    {
      return playerHandPoints;
    }

    public function getPlayerPoints_split1()
    {
      return playerHandPoints_split1;
    }

    public function getPlayerPoints_split2()
    {
      return playerHandPoints_split2;
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

        split_status = 0;

        playerHandPoints = 0;
        dealerHandPoints = 0;

        dealer_cards = new [2];
        player_cards = new [2];

        player_cards_split1 = new [0];
        player_cards_split2 = new [0];

        dealer_cards[0] = deck.drawCard();
        dealer_cards[1] = deck.drawCard();

        player_cards[0] = deck.drawCard();
        player_cards[1] = deck.drawCard();

        recalculatePoints();

        if(getPlayerPoints() == 21)
        {
          if(getDealerPoints() != 21)
          {
            status = STATUS_BLACKJACK;
            handleEndOfRound();
          }

          else 
          {
            status = STATUS_TIE;
            handleEndOfRound();            
          }
        }

        if(getDealerPoints() == 21)
        {
          if(getPlayerPoints() != 21)
          {
            status = STATUS_LOST;
            handleEndOfRound();
          }

          else 
          {
            status = STATUS_TIE;
            handleEndOfRound();            
          }
        }

        //System.println(dealer_cards[0].value + " Suit:" + dealer_cards[0].suit );
    }

    public function hit()
    {
        if(status == STATUS_ACTIVE_ROUND)
        {
          if(split_status == 0)
          {
            player_cards.add(deck.drawCard());

            recalculatePoints();

            if(playerHandPoints > 21)
            {
              status = STATUS_LOST;
              handleEndOfRound();
            }
          }

          else if(split_status == 1)
          {
            player_cards_split1.add(deck.drawCard());

            recalculatePoints();

            if(playerHandPoints_split1 > 21)
            {
              split_status = 2;
            }
          }

          else if(split_status == 2)
          {
            player_cards_split2.add(deck.drawCard());

            recalculatePoints();

            if(playerHandPoints_split1 > 21)
            {
              handleEndOfRound();
            }

            // if(playerHandPoints > 21)
            // {
            //   status = STATUS_LOST;
            //   handleEndOfRound();
            // }
          }
        }

    }

    public function stand()
    {
        if(status == STATUS_ACTIVE_ROUND)
        {
          if(split_status == 0)
          {
            while(dealerHandPoints < 17)
            {
              dealer_cards.add(deck.drawCard());
              recalculatePoints();
            }

            if(dealerHandPoints < playerHandPoints && playerHandPoints <= 21)
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

          else if (split_status == 2)
          {
            // split_status = 2;

            while(dealerHandPoints < 17)
            {
              dealer_cards.add(deck.drawCard());
              recalculatePoints();
            }

            if(dealerHandPoints < playerHandPoints_split1 && playerHandPoints_split1 <= 21)
            {
              status = STATUS_WON;
            }

            if(dealerHandPoints < playerHandPoints_split2 && playerHandPoints_split2 <= 21)
            {
              status = STATUS_WON;
            }

            if(dealerHandPoints > 21)
            {
              status = STATUS_WON;
            }

            if(dealerHandPoints > playerHandPoints_split1 && dealerHandPoints > playerHandPoints_split2 && dealerHandPoints <= 21)
            {
              status = STATUS_LOST;
            }

            if(dealerHandPoints == playerHandPoints_split1 && dealerHandPoints == playerHandPoints_split2)
            {
              status = STATUS_TIE;
            }

            //just for error handling
            if(playerHandPoints_split1 > 21 && playerHandPoints_split2 > 21)
            {
              status = STATUS_LOST;
            } 
            handleEndOfRound();

            System.println("Game ended: "+status);
          }

          else if (split_status == 1)
          {
            split_status = 2;
          }
        }
    }

    public function split()
    {
        player_cards_split1 = new [1];
        player_cards_split2 = new [1];

        player_cards_split1[0] = player_cards[0];
        player_cards_split2[0] = player_cards[1];

        split_status = 1;

        recalculatePoints();
    }
    

    private function calculatePointsHand(player_hand)
    {
        var num_aces_player = 0;

        var points = 0;

        for (var i = 0; i < player_hand.size(); i++)
        {
          var value = player_hand[i].blackjackValue();
          
          if(value == 1)
          {
            num_aces_player +=1;
          }
          
          else
          {
            points += value;
          }

          System.println("Player Hand Card: " + player_hand[i].value + " Suit:" + player_hand[i].suit);
        }

        for (var i = 0; i < num_aces_player; i++)
        {
          if(points + 11 <=21)
          {
            points += 11;
          }

          else
          {
            points += 1;
          }
        }

        return points;

        System.println("Player Hand Points:" + playerHandPoints);
    }

    private function recalculatePoints()
    {
        playerHandPoints = 0;
        playerHandPoints_split1 = 0;
        playerHandPoints_split2 = 0;
        dealerHandPoints = 0;

        playerHandPoints = calculatePointsHand(player_cards);
        playerHandPoints_split1 = calculatePointsHand(player_cards_split1);
        playerHandPoints_split2 = calculatePointsHand(player_cards_split2);


        // var num_aces_player = 0;
        // var num_aces_dealer = 0;

        // for (var i = 0; i < player_cards.size(); i++)
        // {
        //   var value = player_cards[i].blackjackValue();
          
        //   if(value == 1)
        //   {
        //     num_aces_player +=1;
        //   }
          
        //   else
        //   {
        //     playerHandPoints += value;
        //   }

        //   System.println("Player Hand Card: " + player_cards[i].value + " Suit:" + player_cards[i].suit);
        // }

        // for (var i = 0; i < num_aces_player; i++)
        // {
        //   if(playerHandPoints + 11 <=21)
        //   {
        //     playerHandPoints += 11;
        //   }

        //   else
        //   {
        //     playerHandPoints += 1;
        //   }
        // }

        // System.println("Player Hand Points:" + playerHandPoints);

        var num_aces_dealer = 0;

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
          case STATUS_BLACKJACK:
            player_money += Math.round((3/2)*player_bet).toNumber();
            System.println("Blackjack Payout:" + Math.round((3.0/2.0)*player_bet));

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
  STATUS_BLACKJACK = 2,
  STATUS_TIE = 3,
  STATUS_ACTIVE_ROUND = 4,
  STATUS_IDLE = 5
  

}
