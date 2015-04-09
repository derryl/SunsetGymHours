Schedule = new Mongo.Collection 'schedules'

if Meteor.isClient
    
    window.log = console.log.bind(console)
    
    days = [ 'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday' ]
    today = days[ new Date().getDay() - 1 ]
    # today = days[now-1]
    
    dayStart = 900
    dayEnd   = 2100
    dayRange = dayEnd - dayStart

    # '15:00' -> .5
    timeToDecimal = (time) ->
        parts = time.split(':').map (part) -> parseInt(part,10)
        hours = parts[0] * 100
        minutes = Math.floor(parts[1] * 100 / 60) # convert minutes to %
        time = minutes + hours
        return (time - dayStart) / dayRange
        
    # '15:00' -> 50
    timeToPercentage = (time) ->  
        timeToDecimal(time) * 100
        
    getTodaySlots = ->
        theSlots = Schedule.find({ day: today }).map( (doc) -> doc.slots )[0]
        if theSlots is undefined then return []
        theSlots.map (slot, i) -> _.extend slot, { firstItem: i == 0}
        
    isBetween = (z,x,y) -> 
        isb = (z >= x) and (z <= y)
        # if isb
        #     log "#{z} is between #{x} and #{y}"
        # else
        #     log "#{z} is NOT between #{x} and #{y}"
        # isb
        
    #################################################
    
    
    # time -> '9PM'
    Template.registerHelper 'prettyTime', (time) -> 
        if time.length is 4
            time = '0' + time
        moment('2013-02-08 ' + time).format 'hA'
    
    # Template.registerHelper 'getTodaySlots', () -> 
    #     theSlots = Schedule.find({ day: today }).map( (doc) -> doc.slots )[0]
    #     if theSlots is undefined then return []
    #     slots = theSlots.map (slot, i) -> _.extend slot, { firstItem: i == 0}
            
    # is gym open at all today?
    Template.registerHelper 'isGymClosed', (slots) -> 
        not slots or slots.length is 0
        
    Template.registerHelper 'isGymClosedNow', (slots) =>
        slots = getTodaySlots(true)
        if !slots or slots.length < 1 then return false
        now = timeToDecimal moment().format('HH:mm')
        if now > 1 then return false
        slots = _.map( slots, (slot) -> {
            start: timeToDecimal(slot.start)
            end:   timeToDecimal(slot.end)
        })
        _.every( slots, (slot) ->
            !isBetween( now, slot.start, slot.end )
        )
        
    Template.registerHelper 'today', ->
        doc = Schedule.findOne({ day: today })
        if not doc then '' else doc.day
        
    Template.registerHelper 'isTodayClass', (theDay) ->
        if theDay is today then 'currentDay' else ''
        
    Template.today.helpers
        dayName: ->
            doc = Schedule.findOne({ day: today })
            if not doc then '' else doc.day
        todayDate: ->
            moment().format('MMMM Do')
        slots: ->
            theSlots = Schedule.find({ day: today }).map( (doc) -> doc.slots )[0]
            if theSlots is undefined then return []
            theSlots.map (slot, i) -> _.extend slot, { firstItem: i == 0}

    Template.week.helpers
        days: ->
            days = Schedule.find().map( (doc, index, cursor) ->
                # log doc
                _.extend(doc , {index: index})
            )
            if days.length > 7 then days = days.slice(0,7)
            return days
            
        slotRangeCSS: (startTime, endTime) ->
            start = timeToPercentage startTime
            end   = timeToPercentage endTime
            width = end - start
            # return css
            return "left: #{start}%; width: #{width}%;"
        gymClosed: (slots) ->
            not slots or slots.length is 0

    Template.week.onRendered () ->
        document.body.setAttribute 'class', 'page-loaded'
            
    # Session.setDefault('counter', 0)

    # Template.hello.helpers
    #     counter: ->
    #         Session.get 'counter'
            
    #  Template.hello.events
    #     'click button': ->
    #         Session.set('counter', Session.get('counter') + 1)     
            
if Meteor.isServer

    Meteor.startup () ->
        # code to run on server at startup
