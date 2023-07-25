import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.WatchUi;

class BlackjackView extends WatchUi.View {

    function initialize() {
        View.initialize();
    }

    var heart_bitmap;
    var diamond_bitmap;
    var spade_bitmap;
    var club_bitmap;

    // Load your resources here
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));

        //myBitmap = WatchUi.loadResource(Rez.Drawables.playCard) as Bitmap;

        heart_bitmap = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.heart
        });

        diamond_bitmap = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.diamond
        });

        spade_bitmap = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.spade
        });

        club_bitmap = new WatchUi.Bitmap({
            :rezId=>Rez.Drawables.club
        });

    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // Update the view
    function onUpdate(dc as Dc) as Void {
        View.onUpdate(dc);

        var status = getApp().engine.status;

        var screen_width = dc.getWidth();
        var screen_height = dc.getHeight();
        var center_x = screen_width/2;
        var center_y = screen_height/2;

        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

        dc.drawText(center_x,screen_height/12, Graphics.FONT_XTINY,"Bet: "+getApp().engine.getBet() + " €",Graphics.TEXT_JUSTIFY_CENTER);

        if(status != STATUS_IDLE)
        {
            var player_cards =  getApp().engine.getPlayerCards();
            var dealer_cards =  getApp().engine.getDealerCards();

            if(status == STATUS_ACTIVE_ROUND)
            {
                dc.drawText(screen_width/4,screen_height/6, Graphics.FONT_XTINY,"Dealer",Graphics.TEXT_JUSTIFY_LEFT);
                
                dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI),center_y + (screen_height/2.0-25.0)*Math.sin(Math.PI), Graphics.FONT_XTINY,"Hit!",Graphics.TEXT_JUSTIFY_CENTER);
                dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI*(5.0/6.0)),center_y + (screen_height/2.0-25.0)*Math.sin(Math.PI*(5.0/6.0)), Graphics.FONT_XTINY,"Stand!",Graphics.TEXT_JUSTIFY_CENTER);
            }

            else 
            {   
                //draw dealer points only when round finished
                dc.drawText(screen_width/4,screen_height/6, Graphics.FONT_XTINY,"Dealer: "+getApp().engine.getDealerPoints(),Graphics.TEXT_JUSTIFY_LEFT);
            }

            for(var i = 0 ; i < dealer_cards.size(); i++)
            {
                //only draw the first card in active round
                if(i > 0 && status == STATUS_ACTIVE_ROUND)
                {
                    drawCard(dc, screen_width/4+(35*i),screen_height/6+20, 30,50,dealer_cards[i].valueName(),dealer_cards[i].suit,true);
                }

                else
                {
                    drawCard(dc, screen_width/4+(35*i),screen_height/6+20, 30,50,dealer_cards[i].valueName(),dealer_cards[i].suit,false);
                }
            }

            dc.drawText(screen_width/4,screen_height/1.7, Graphics.FONT_XTINY,"Player: "+getApp().engine.getPlayerPoints(),Graphics.TEXT_JUSTIFY_LEFT);

            for(var i = 0 ; i < player_cards.size(); i++)
            {
                drawCard(dc, screen_width/4+(35*i), screen_height/1.7 + 20, 30, 50, player_cards[i].valueName(),player_cards[i].suit, false);
            }

            var status_label;

            switch(status)
            {
                case STATUS_ACTIVE_ROUND:
                    status_label = "";
                    //status_label = "Playing";
                    break;
                case STATUS_LOST:
                    status_label = "Lost!";
                    break;
                case STATUS_WON:
                    status_label = "Won!";
                    break;
                case STATUS_TIE:
                    status_label = "Tie!";
                    break;
                default:
                    status_label = status;
                    break;
            }

            dc.drawText(center_x,center_y-10, Graphics.FONT_TINY,status_label,Graphics.TEXT_JUSTIFY_CENTER);

        }

        else
        {
            //dc.drawText(center_x,center_y, Graphics.FONT_XTINY,"Press Start to Play!",Graphics.TEXT_JUSTIFY_CENTER);
        }

        //draw labels for bets and starting next round
        if(status != STATUS_ACTIVE_ROUND)
        {
            dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI),center_y + (screen_height/2.0-25.0)*Math.sin(Math.PI), Graphics.FONT_XTINY,"Bet+",Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI*(5.0/6.0)),center_y + (screen_height/2.0-25.0)*Math.sin(Math.PI*(5.0/6.0)), Graphics.FONT_XTINY,"Bet-",Graphics.TEXT_JUSTIFY_CENTER);
            dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI*(-1.0/6.0)),center_y + (screen_height/2.0-25.0)*Math.sin(-Math.PI*(1.0/6.0)), Graphics.FONT_XTINY,"Play!",Graphics.TEXT_JUSTIFY_CENTER);

        }

        dc.drawText(center_x,screen_height - 20, Graphics.FONT_XTINY,getApp().engine.getMoney()+" €",Graphics.TEXT_JUSTIFY_CENTER);

    }

    function drawCard(dc,x,y,width,height,value,suit, flip)
    {
        
        if(flip)
        {
            dc.setColor(Graphics.COLOR_LT_GRAY, Graphics.COLOR_BLACK);
            dc.fillRectangle(x, y, width, height);
        }

        else
        {
            dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
            dc.fillRectangle(x, y, width, height);

            var suit_bitmap;

            switch(suit)
            {
                case SUIT_HEARTS:
                    suit_bitmap = heart_bitmap;
                    break;

                case SUIT_SPADES:
                    suit_bitmap = spade_bitmap;
                        break;

                case SUIT_CLUBS:
                    suit_bitmap =  club_bitmap;
                    break;

                case SUIT_DIAMONDS:
                    suit_bitmap = diamond_bitmap;
                    break;

                default:
                    suit_bitmap = heart_bitmap;
                    break;
            }
            
            dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_WHITE);

            var text = value;
            dc.drawText(x,y, Graphics.FONT_XTINY,text,Graphics.TEXT_JUSTIFY_LEFT);

            suit_bitmap.locX = x+20;
            suit_bitmap.locY = y;
            suit_bitmap.draw(dc);

        }
    
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
