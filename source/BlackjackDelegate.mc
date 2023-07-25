import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

using Toybox.System;
using Toybox.WatchUi;

class BlackjackDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new BlackjackMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

    // Detect Menu button input
    function onKey(keyEvent) {
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

        WatchUi.requestUpdate();
        
        return true;
    }

}