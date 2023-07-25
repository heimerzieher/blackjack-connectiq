import Toybox.Lang;
import Toybox.System;
import Toybox.WatchUi;

class BlackjackMenuDelegate extends WatchUi.MenuInputDelegate {

    function initialize() {
        MenuInputDelegate.initialize();
    }

    function onMenuItem(item as Symbol) as Void {
        if (item == :item_1) {
            System.println("item 1");
            System.exit();
        } else if (item == :item_2) {
            System.println("item 2");
        }
    }

    // // Detect Menu button input
    // function onKey(keyEvent) {
    //     System.println(keyEvent.getKey()); // e.g. KEY_MENU = 7
    //     return true;
    // }

}