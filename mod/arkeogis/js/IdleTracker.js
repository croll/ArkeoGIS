/*
Class: Idle Tracker
Author: Brad Kellett
Version: 1.0
Date: 17/12/09
Built For: Mootools 1.2.4
Website: http://bradkellett.com/p/mootools-idle-tracker-class
*/

var IdleTracker = new Class({
    Implements: [Options, Events],
    options: {
        idleTime: 30, // How long with no activity should be classed as idle? (sec)
        mouseMoveSensitivity: 8, // number of pixels the mouse must move before resetting idle
        mouseMoveTimespan: 2 // number of seconds the mouse sensitivity must be met within
        //onIdle: $empty // Event fired when user scrolls to a page
        //onIdleReturn: $empty // Event fired when a user becomes active again
    },

    isIdle: false,
    intervalCounter: 0,
    mouseMoveCounter: 0,

    initialize: function(options) {
        this.setOptions(options);

        setInterval(this.idleIncrement.bind(this), 1000);
        setInterval(this.resetMouseMove.bind(this), this.options.mouseMoveTimespan*1000);
        $(document).addEvent("mousemove", this.mouseMove.bind(this));
        $(window).addEvent("focus", this.idleReset.bind(this));
    },

    idleIncrement: function() {
        this.intervalCounter++;
        if (this.intervalCounter > this.options.idleTime && !this.isIdle) {
            this.isIdle = true;
            this.fireEvent('idle');
        }
    },

    idleReset: function() {
        if (this.isIdle) {
            this.isIdle = false;
            this.fireEvent('idleReturn');
        }

        this.intervalCounter = 0;
        this.mouseMoveCounter = 0;
    },

    // Count mouse move events to implement sensitivity
    // This is needed because IE7 likes to trigger phantom mouse move
    mouseMove: function() {
        this.mouseMoveCounter++;
        if(this.mouseMoveCounter > this.options.mouseMoveSensitivity)
            this.idleReset();
    },

    resetMouseMove: function() {
        this.mouseMoveCounter = 0;
    }

});
