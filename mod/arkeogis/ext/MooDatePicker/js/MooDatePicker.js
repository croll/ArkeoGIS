/*
---
script: MooDatePicker.js

description: a date picker for Mootools

license: MIT-style license.

authors:
 - Yannick Croissant

requires:
 core/1.3: '*'
 more/1.3: Date
 more/1.3: Date.Extras
 more/1.3: Object.Extras
 more/1.3: Element.Measure
 more/1.3: Locale
 more/1.3: Locale.en-US.Date

provides: [MooDatePicker]

...
*/

var MooDatePicker = new Class({
	
	Implements: [Options, Events],

	options: {/*
		onShow: function(){},
		onHide: function(){},
		onPick: function(date){}, */
		prefix: 'moodatepicker-',
		offset: {x: 5, y: -3},
		templates: {
			global: '<div class="{prefix}container">{header}{calendar}</div>', // Variables: {prefix}, {header}, {calendar}
			header: '<div class="{prefix}header"><h1 class="{prefix}title">{month}</h1><ul><li><button type="button" class="{prefix}prev"><span>«</span></button></li><li><button type="button" class="{prefix}next"><span>»</span></button></li></ul></div>', // Variables: {prefix}, {month}
			calendar: '<table class="{prefix}calendar"><thead><tr>{dayHeader}</tr></thead><tbody class="{prefix}calendar-inner">{week}</tbody></table>', // Variables: {prefix}, {dayHeader}, {week}
			dayHeader: '<th>{dayLabel}</th>', // Variables: {prefix}, {dayLabel}
			week: '<tr>{day}</tr>', // Variables: {prefix}, {day}
			day: '<td><button type="button" class="{prefix}day {today} {selected}">{number}</button></td>', // Variables: {prefix}, {today}, {selected}, {number}
			dayEmpty: '<td></td>' // Variables: {prefix}
		},
		labelLength: 1
	},

	/*
	 * Contructor
	 */
	initialize: function(elements, options){
		// Init vars
		this.elements = typeOf(elements) == 'elements' ? elements : new Elements([elements]);
		this.setOptions(options);
		this.now = new Date().clearTime();
		Locale.use(Locale.getCurrent().name); // Recompile the current language
		
		this.makeCalendar();
		this.setEvents();
	},
	
	/*
	 * Make the calendar using the user-defined templates and inject it in the document
	 */
	makeCalendar: function(){
		var dayHeader = '',
			days = Locale.get('Date' + '.days');
		days.push(days.shift());

		// Calendar header
		var header = this.options.templates.header.substitute({
			prefix: this.options.prefix
		});
		
		// Table header
		days.forEach(function(label){
			dayHeader += this.options.templates.dayHeader.substitute({
				prefix: this.options.prefix,
				dayLabel: this.options.labelLength ? label.substring(0, this.options.labelLength) : label
			});
		}.bind(this));

		// Table
		var calendar = this.options.templates.calendar.substitute({
			prefix: this.options.prefix,
			dayHeader: dayHeader
		});

		// Container
		this.picker = new Elements.from(this.options.templates.global.substitute({
			prefix: this.options.prefix,
			header: header,
			calendar: calendar
		}))[0].inject(document.body);
	},
	
	/*
	 * Set the event listeners on the elements
	 */
	setEvents: function(){
		// Display the calendar on focus/click on the targeted elements
		this.elements.addEvents({
			focus: function(e){
				var el = document.id(e.target);
				this.show(el);
				return false;
			}.bind(this),
			click: function(e){
				e.stopPropagation();
				return false;
			}
		}).set('readonly', true);
		
		// Try to init 'data-moodatepicker-value' with the field value
		this.elements.forEach(function(el){
			try {
				el.set('data-moodatepicker-value', Date.parse(el.value).getTime());
			} catch(e){}
		});
		 
		// Hide the calendar if you click outside of the calendar
		document.getElement('html').addEvent('click', function(e){
			if (this.picker.getStyle('display') != 'block' || Date.now() - this.displayTime < 200) return;
			this.hide();
		}.bind(this));
		
		// Avoid the calendar to hide when you click on it
		this.picker.addEvent('click', function(e){
			e.stopPropagation();
			return false;
		});
		
		// Hide the calendar and launch the callback when you choose a day
		this.picker.addEvent('click:relay(.' + this.options.prefix + 'day)', function(e, el){
			this.date.set('date', el.get('text'));
			this.element.set('data-moodatepicker-value', this.date.getTime());
			this.fireEvent('onPick', this.date);
			this.hide();
		}.bind(this));
		
		// Set the event on the previous/next buttons
		this.picker.getElement('.' + this.options.prefix + 'prev').addEvent('click', function(){
			this.updateCalendar(this.date.decrement('month', 1));
		}.bind(this));
		
		this.picker.getElement('.' + this.options.prefix + 'next').addEvent('click', function(){
			this.updateCalendar(this.date.increment('month', 1));
		}.bind(this));
	},
	
	/*
	 * Display the calendar
	 */
	show: function(el){
		this.element = el; // Set the active element
		var elCoords = el.getCoordinates(),
			elSize = el.getSize(),
			bodySize = document.getElement('body').getSize(),
			date = this.element.get('data-moodatepicker-value');
		
		// Get the good month to show
		if (date) this.date = new Date(date.toInt());
		else this.date = new Date().clearTime();
		
		this.selected = this.date.clone();
		this.displayTime = Date.now();
		this.updateCalendar(this.date);
		
		// Place the calendar at left or right of the element, depending of the available space
		var pickerSize = this.picker.getDimensions(),
			pickerCoords = elCoords.left + elSize.x + this.options.offset.x + pickerSize.width;
		
		if (pickerCoords < bodySize.x) var left = elCoords.left + elSize.x + this.options.offset.x;
		else var left = elCoords.left - pickerSize.width + this.options.offset.x * -1;
			
		// Display the calendar
		this.picker.setStyles({
			display: 'block',
			left: left + 'px',
			top: (elCoords.top + this.options.offset.y) + 'px',
			'z-index': 1000
		});
		this.fireEvent('onShow');
		return this;
	},
	
	/*
	 * Hide the calendar
	 */
	hide: function(){
		this.picker.setStyles({
			display: '',
			top: '',
			left: '',
			'z-index': ''
		});
		this.fireEvent('onHide');
		return this;
	},
	
	/*
	 * Update the month in the calendar
	 */
	updateCalendar: function(newDate){
		this.date = newDate.clone();
		var firstDay = newDate.set('date', 1).getDay(),
			firstDay = firstDay == 0 ? 6 : firstDay - 1,                     // Get the first day of the month
			dayCount = newDate.get('lastdayofmonth'),                       // Get the number of days in the month
			cellCount = Math.ceil((dayCount + firstDay) / 7) * 7;            // Get the number of cells to write in the calendar

		newDate.set('date', - firstDay);

		// Day loop
		for (var i = 1, days = weeks = ''; i <= cellCount; i++) {
			newDate.increment('day');
			
			days += this.options.templates[i <= firstDay || i > dayCount + firstDay ? 'dayEmpty' : 'day'].substitute({
				prefix: this.options.prefix,
				number: i - firstDay,
				today: this.now.getTime() == newDate.getTime() ? 'today' : '',
				selected: this.selected && this.selected.getTime() == newDate.getTime() ? 'selected' : ''
			});
			
			// Make a new week every 7 days
			if (!(i % 7) && i != 0) {
				weeks += this.options.templates.week.substitute({
					prefix: this.options.prefix,
					day: days
				});
				days = '';
			}
		}
		new Elements.from(weeks).inject(this.picker.getElement('.' + this.options.prefix + 'calendar-inner').empty());
		this.picker.getElement('.' + this.options.prefix + 'title').set('text', Locale.get('Date' + '.months')[this.date.getMonth()] + ' ' + this.date.getFullYear());
		return this;
	}
	
});