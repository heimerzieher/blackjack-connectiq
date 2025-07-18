import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.System;
using Toybox.WatchUi;

class BlackjackDelegate extends WatchUi.BehaviorDelegate {

    function initialize() 
    {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean 
    {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new BlackjackMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    // Detect Menu button input
    function onKey(keyEvent) 
    {
        //System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
        System.println("Key:" + keyEvent.getKey());

        if(getApp().engine.status == STATUS_ACTIVE_ROUND)
            {
            // hit
            if(keyEvent.getKey() == KEY_UP)
            {
                System.println("HIT");

                if(getApp().engine.status == STATUS_ACTIVE_ROUND)
                {
                    getApp().engine.hit();
                }

                if(getApp().engine.status == STATUS_LOST)
                {
                    System.println("LOST");

                }
            }

            // stand
            if(keyEvent.getKey() == KEY_DOWN)
            {
                System.println("STAND");

                if(getApp().engine.status == STATUS_ACTIVE_ROUND)
                {
                    getApp().engine.stand();
                }

                if(getApp().engine.status == STATUS_WON)
                {
                    System.println("WON");

                }

                if(getApp().engine.status == STATUS_LOST)
                {
                    System.println("LOST");

                }
            }

            if(keyEvent.getKey() == KEY_ESC)
            {
                WatchUi.popView(WatchUi.SLIDE_RIGHT);

                // System.exit();
            }
        }

        else
        {
            // increase bet
            if(keyEvent.getKey() == KEY_UP)
            {
                getApp().engine.setBet(getApp().engine.getBet() + 1);
            }

            // decrease bet
            if(keyEvent.getKey() == KEY_DOWN)
            {
                getApp().engine.setBet(getApp().engine.getBet() - 1);
            }

            // start new game using START_STOP_KEY, TODO find enum
            if(keyEvent.getKey() == 4)
            {
                System.println("REQUEST NEW GAME");

                if(getApp().engine.status != STATUS_ACTIVE_ROUND)
                {
                    System.println("STARTING NEW GAME");
                    getApp().engine.startRound();

                }

            }
            
        }

        if( getApp().engine.getBet() < 0)
        {
            getApp().engine.setBet(0);   
        }

        WatchUi.requestUpdate();
        
        return true;
    }

    function onTap(clickEvent)
    {
        var x = clickEvent.getCoordinates()[0];
        var y = clickEvent.getCoordinates()[1];

        System.println("x:" +x);
        System.println("y:" + y);

        // getApp().view.handleTap(x, y);

        if(getApp().engine.status == STATUS_ACTIVE_ROUND)
            {
            // hit             // if(keyEvent.getKey() == KEY_UP)

            if (x >= getApp().view.hit_button_pos[0] && x <= getApp().view.hit_button_pos[0]  + getApp().view.hit_button_pos[2] &&
                y >= getApp().view.hit_button_pos[1] && y <= getApp().view.hit_button_pos[1]  + getApp().view.hit_button_pos[3]) 
            {
                System.println("HIT");

                if(getApp().engine.status == STATUS_ACTIVE_ROUND)
                {
                    getApp().engine.hit();
                }

                if(getApp().engine.status == STATUS_LOST)
                {
                    System.println("LOST");

                }
            }

            // stand
            if (x >= getApp().view.stand_button_pos[0] && x <= getApp().view.stand_button_pos[0]  + getApp().view.stand_button_pos[2] &&
                y >= getApp().view.stand_button_pos[1] && y <= getApp().view.stand_button_pos[1]  + getApp().view.stand_button_pos[3]) 
            {
                System.println("STAND");

                if(getApp().engine.status == STATUS_ACTIVE_ROUND)
                {
                    getApp().engine.stand();
                }

                if(getApp().engine.status == STATUS_WON)
                {
                    System.println("WON");

                }

                if(getApp().engine.status == STATUS_LOST)
                {
                    System.println("LOST");

                }
            }

            // split
            if (x >= getApp().view.split_button_pos[0] && x <= getApp().view.split_button_pos[0]  + getApp().view.split_button_pos[2] &&
                y >= getApp().view.split_button_pos[1] && y <= getApp().view.split_button_pos[1]  + getApp().view.split_button_pos[3]) 
            {
                System.println("SPLIT");

                if(getApp().engine.status == STATUS_ACTIVE_ROUND)
                {
                    getApp().engine.split();
                }

                // if(getApp().engine.status == STATUS_WON)
                // {
                //     System.println("WON");

                // }

                // if(getApp().engine.status == STATUS_LOST)
                // {
                //     System.println("LOST");

                // }
            }
        }

        else
        {
            // increase bet
            if (x >= getApp().view.hit_button_pos[0] && x <= getApp().view.hit_button_pos[0]  + getApp().view.hit_button_pos[2] &&
                y >= getApp().view.hit_button_pos[1] && y <= getApp().view.hit_button_pos[1]  + getApp().view.hit_button_pos[3]) 
            {
                getApp().engine.setBet(getApp().engine.getBet() + 1);
                System.println("Bet+");
            }

            // decrease bet
            if (x >= getApp().view.stand_button_pos[0] && x <= getApp().view.stand_button_pos[0]  + getApp().view.stand_button_pos[2] &&
                y >= getApp().view.stand_button_pos[1] && y <= getApp().view.stand_button_pos[1]  + getApp().view.stand_button_pos[3]) 
            {
                getApp().engine.setBet(getApp().engine.getBet() - 1);
                System.println("Bet-");

            }

            // start new game using START_STOP_KEY, TODO find enum
            if (x >= getApp().view.deal_button_pos[0] && x <= getApp().view.deal_button_pos[0]  + getApp().view.deal_button_pos[2] &&
                y >= getApp().view.deal_button_pos[1] && y <= getApp().view.deal_button_pos[1]  + getApp().view.deal_button_pos[3]) 
            {
                System.println("REQUEST NEW GAME");

                if(getApp().engine.status != STATUS_ACTIVE_ROUND)
                {
                    System.println("STARTING NEW GAME");
                    getApp().engine.startRound();

                }

            }
            
        }

        if( getApp().engine.getBet() < 0)
        {
            getApp().engine.setBet(0);   
        }

        WatchUi.requestUpdate();

        return true;
    }


}