import Toybox.Application;
import Toybox.Lang;
import Toybox.WatchUi;
import Toybox.Graphics;
using Toybox.System;


class BlackjackApp extends Application.AppBase {

    public var engine;

    public var view;

    function initialize() 
    {
        AppBase.initialize();
    }

    // onStart() is called on application start up
    function onStart(state as Dictionary?) as Void 
    {


        var money = Application.Storage.getValue("money");
        var bet = Application.Storage.getValue("bet");


        if(money==null) 
        {
            money = 100;
        }

        if(bet==null) 
        {
            bet = 10;
        }

        //TODO: Allow setting the number of decks
        engine = new BlackjackEngine(2,money, bet);

    }

    // onStop() is called when your application is exiting
    function onStop(state as Dictionary?) as Void 
    {   
        //save the money and the bet
        Application.Storage.setValue("money",engine.getMoney());
        Application.Storage.setValue("bet",engine.getBet());
    }

    // Return the initial view of your application here
    function getInitialView()
    {
        view = new BlackjackView();
        return [view, new BlackjackDelegate() ];
    }

}

function getApp() as BlackjackApp {
    return Application.getApp() as BlackjackApp;
}