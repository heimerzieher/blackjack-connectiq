import Toybox.Graphics;
import Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.WatchUi;

class BlackjackView extends WatchUi.View {

    function initialize() 
    {
        View.initialize();
    }

    var heart_bitmap;
    var diamond_bitmap;
    var spade_bitmap;
    var club_bitmap;

    public var hit_button_pos;
    public var stand_button_pos;
    public var split_button_pos;
    public var deal_button_pos;

    private var button_text_size = Graphics.FONT_XTINY;
    private var button_text_color = 0xffaa00;

    private var scale_factor = 1;

    var background_color = 0x006a4e;

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
    function onUpdate(dc as Dc) as Void 
    {
        View.onUpdate(dc);

        var status = getApp().engine.status;

        var screen_width = dc.getWidth();
        var screen_height = dc.getHeight();
        var center_x = screen_width/2;
        var center_y = screen_height/2;

        scale_factor = screen_width/280.0;


        dc.setColor(Graphics.COLOR_WHITE, background_color);

        dc.clear();


        // dc.drawText(center_x,screen_height/12, Graphics.FONT_XTINY,"Bet: "+getApp().engine.getBet() + " €",Graphics.TEXT_JUSTIFY_CENTER);

        dc.drawText(center_x,center_y, Graphics.FONT_XTINY,  "€ "  + getApp().engine.getBet(),Graphics.TEXT_JUSTIFY_CENTER);


        if(status != STATUS_IDLE)
        {
            var player_cards =  getApp().engine.getPlayerCards();
            var player_cards_split1 =  getApp().engine.getPlayerCards_split1();
            var player_cards_split2 =  getApp().engine.getPlayerCards_split2();

            var dealer_cards =  getApp().engine.getDealerCards();

            if(status == STATUS_ACTIVE_ROUND)
            {
                dc.setColor(button_text_color, background_color);

                //Draw hit Button
                hit_button_pos = [center_x + (screen_height/2.0-(20.0*scale_factor))*Math.cos(Math.PI*(-5.0/6.0)),center_y + (screen_height/2.0-(20.0*scale_factor))*Math.sin(Math.PI*(-5.0/6.0)), 40, 25];
                // dc.drawRectangle(hit_button_pos[0], hit_button_pos[1], hit_button_pos[2], hit_button_pos[3]);
                dc.drawText(hit_button_pos[0] + hit_button_pos[2]/2, hit_button_pos[1], button_text_size, "Hit", Graphics.TEXT_JUSTIFY_CENTER);


                //Draw stand button
                stand_button_pos = [center_x + (screen_height/2.0-(20.0*scale_factor))*Math.cos(Math.PI*(5.0/6.0)),center_y + (screen_height/2.0-(20.0*scale_factor))*Math.sin(Math.PI*(5.0/6.0)), 40, 25];
                // dc.drawRectangle(stand_button_pos[0], stand_button_pos[1], stand_button_pos[2], stand_button_pos[3]);
                dc.drawText(stand_button_pos[0] + stand_button_pos[2]/2, stand_button_pos[1], button_text_size, "Stand",Graphics.TEXT_JUSTIFY_CENTER);


                //Draw split button
                split_button_pos = [center_x + (screen_height/2.0-(20.0*scale_factor))*Math.cos(Math.PI),center_y + (screen_height/2.0-(20.0*scale_factor))*Math.sin(Math.PI), 40, 25];
                // dc.drawRectangle(split_button_pos[0], split_button_pos[1], split_button_pos[2], split_button_pos[3]);
                dc.drawText(split_button_pos[0] + split_button_pos[2]/2, split_button_pos[1], button_text_size, "Split",Graphics.TEXT_JUSTIFY_CENTER);

                dc.setColor(Graphics.COLOR_WHITE, background_color);
            }

            else 
            {   
                //draw dealer points only when round finished
                dc.drawText(screen_width/3,screen_height/7, Graphics.FONT_XTINY, getApp().engine.getDealerPoints(),Graphics.TEXT_JUSTIFY_LEFT);
            }

            //draw dealer cards
            for(var i = 0 ; i < dealer_cards.size(); i++)
            {
                //only draw the first card in active round
                if(i > 0 && status == STATUS_ACTIVE_ROUND)
                {
                    drawCard(dc, screen_width/3+(35*scale_factor*i),screen_height/7+20*scale_factor, 30*scale_factor,50*scale_factor,dealer_cards[i].valueName(),dealer_cards[i].suit,true);
                }

                else
                {
                    drawCard(dc, screen_width/3+(35*scale_factor*i),screen_height/7+20*scale_factor, 30*scale_factor,50*scale_factor,dealer_cards[i].valueName(),dealer_cards[i].suit,false);
                }
            }


            //draw player cards

            if(getApp().engine.split_status == 0)
            {
                dc.drawText(screen_width/3, screen_height/1.7, Graphics.FONT_XTINY, getApp().engine.getPlayerPoints(),Graphics.TEXT_JUSTIFY_LEFT);

                for(var i = 0 ; i < player_cards.size(); i++)
                {
                    drawCard(dc, screen_width/3+(35*scale_factor*i), screen_height/1.7 + 20*scale_factor, 30*scale_factor, 50*scale_factor, player_cards[i].valueName(),player_cards[i].suit, false);
                }                            
            }

            else
            {
                dc.drawText(screen_width/3, screen_height/2.0, Graphics.FONT_XTINY, getApp().engine.getPlayerPoints_split1(),Graphics.TEXT_JUSTIFY_LEFT);

                for(var i = 0 ; i < player_cards_split1.size(); i++)
                {
                    drawCard(dc, screen_width/3+(35*scale_factor*i), screen_height/2.0 + 20*scale_factor, 30*scale_factor, 50*scale_factor, player_cards_split1[i].valueName(),player_cards_split1[i].suit, false);
                }

                dc.drawText(screen_width/3, screen_height/1.5 + 50*scale_factor+20, Graphics.FONT_XTINY, getApp().engine.getPlayerPoints_split2(),Graphics.TEXT_JUSTIFY_LEFT);

                for(var i = 0 ; i < player_cards_split2.size(); i++)
                {
                    drawCard(dc, screen_width/3+(35*scale_factor*i), screen_height/1.5 + 20*scale_factor, 30*scale_factor, 50*scale_factor, player_cards_split2[i].valueName(),player_cards_split2[i].suit, false);
                }
            }


            var status_label;
            var status_color = Graphics.COLOR_WHITE;

            switch(status)
            {
                case STATUS_ACTIVE_ROUND:
                    status_label = "";
                    //status_label = "Playing";
                    break;
                case STATUS_LOST:
                    status_label = "Lost!";
                    status_color = Graphics.COLOR_RED;
                    break;
                case STATUS_WON:
                    status_label = "Won!";
                    status_color = Graphics.COLOR_GREEN;
                    break;
                case STATUS_TIE:
                    status_label = "Tie!";
                    status_color = Graphics.COLOR_YELLOW;
                    break;
                case STATUS_BLACKJACK:
                    status_label = "Blackjack!";
                    status_color = Graphics.COLOR_GREEN;
                    break;
                default:
                    status_label = status;
                    break;
            }

            dc.setColor(status_color, background_color);
            dc.drawText(center_x,10*scale_factor, Graphics.FONT_TINY,status_label,Graphics.TEXT_JUSTIFY_CENTER);
            dc.setColor(Graphics.COLOR_WHITE, background_color);

        }

        else
        {
            //dc.drawText(center_x,center_y, Graphics.FONT_XTINY,"Press Start to Play!",Graphics.TEXT_JUSTIFY_CENTER);
        }

        //draw labels for bets and starting next round
        if(status != STATUS_ACTIVE_ROUND)
        {
            // dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI),center_y + (screen_height/2.0-25.0)*Math.sin(Math.PI), Graphics.FONT_XTINY,"Bet+",Graphics.TEXT_JUSTIFY_CENTER);
            // dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI*(5.0/6.0)),center_y + (screen_height/2.0-25.0)*Math.sin(Math.PI*(5.0/6.0)), Graphics.FONT_XTINY,"Bet-",Graphics.TEXT_JUSTIFY_CENTER);
            
            dc.setColor(button_text_color, background_color);

            //Draw bet+ Button
            hit_button_pos = [center_x + (screen_height/2.0-(20.0*scale_factor))*Math.cos(Math.PI*(-5.0/6.0)),center_y + (screen_height/2.0-(20.0*scale_factor))*Math.sin(Math.PI*(-5.0/6.0)), 40, 25];
            // dc.drawRectangle(hit_button_pos[0], hit_button_pos[1], hit_button_pos[2], hit_button_pos[3]);
            dc.drawText(hit_button_pos[0] + hit_button_pos[2]/2, hit_button_pos[1], button_text_size, "Bet+", Graphics.TEXT_JUSTIFY_CENTER);


            //Draw bet- button
            stand_button_pos = [center_x + (screen_height/2.0-(20.0*scale_factor))*Math.cos(Math.PI*(5.0/6.0)),center_y + (screen_height/2.0-(20.0*scale_factor))*Math.sin(Math.PI*(5.0/6.0)), 40, 25];
            // dc.drawRectangle(stand_button_pos[0], stand_button_pos[1], stand_button_pos[2], stand_button_pos[3]);
            dc.drawText(stand_button_pos[0] + stand_button_pos[2]/2, stand_button_pos[1], button_text_size, "Bet-",Graphics.TEXT_JUSTIFY_CENTER);
            
            
            //Draw Deal button
            deal_button_pos = [center_x + (screen_height/2.0-(35.0*scale_factor))*Math.cos(Math.PI*(-1.0/6.0)),center_y + (screen_height/2.0-(35.0*scale_factor))*Math.sin(-Math.PI*(1.0/6.0)), 40, 25];
            // dc.drawRectangle(deal_button_pos[0], deal_button_pos[1], deal_button_pos[2], deal_button_pos[3]);
            dc.drawText(deal_button_pos[0] + deal_button_pos[2]/2, deal_button_pos[1], button_text_size, "Deal",Graphics.TEXT_JUSTIFY_CENTER);

            dc.setColor(Graphics.COLOR_WHITE, background_color);

            // dc.drawText(center_x + (screen_height/2.0-25.0)*Math.cos(Math.PI*(-1.0/6.0)),center_y + (screen_height/2.0-25.0)*Math.sin(-Math.PI*(1.0/6.0)), Graphics.FONT_XTINY,"Deal",Graphics.TEXT_JUSTIFY_CENTER);
        }

        dc.drawText(center_x,screen_height - 20*scale_factor, Graphics.FONT_XTINY, "€ "  +getApp().engine.getMoney(), Graphics.TEXT_JUSTIFY_CENTER);

    }

    function drawCard(dc, x, y, width, height, value, suit, flip)
    {
        
        if(flip)
        {
            dc.setColor(Graphics.COLOR_LT_GRAY, background_color);
            dc.fillRectangle(x, y, width, height);
        }

        else
        {
            dc.setColor(Graphics.COLOR_WHITE, background_color);
            dc.fillRectangle(x, y, width, height);

            dc.setPenWidth(Math.round(1*scale_factor));
            dc.setColor(Graphics.COLOR_BLACK, background_color);
            dc.drawRectangle(x, y, width, height);

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
                    suit_bitmap = club_bitmap;
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
            dc.drawText(x+3*scale_factor, y, Graphics.FONT_XTINY, text, Graphics.TEXT_JUSTIFY_LEFT);

            suit_bitmap.locX = x;
            suit_bitmap.locY = y + 20*scale_factor;
            suit_bitmap.draw(dc);

        }
    
        dc.setColor(Graphics.COLOR_WHITE, background_color);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void 
    {

    }

}
