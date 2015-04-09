// ScheduleInserter = new Mongo.Collection("schedules");
if (Meteor.isClient) {
    window.scheduleArray = [
        {
            "day": "monday",
            "slots": [
                { "start": "9:00", "end": "21:00" }
            ]
        },{
            "day": "tuesday",
            "slots": [
                { "start": "11:00", "end": "16:00" },
                { "start": "18:00", "end": "21:00" }
            ]
        },{
            "day": "wednesday",
            "slots": [
                { "start": "12:00", "end": "21:00" }
            ]
        },{
            "day": "thursday",
            "slots": [
                { "start": "12:00", "end": "16:00" },
                { "start": "18:00", "end": "21:00" }
            ]
        },{
            "day": "friday",
            "slots": [
                { "start": "9:00",  "end": "15:30" },
                { "start": "19:00", "end": "21:00" }
            ]
        },{
            "day": "saturday",
            "slots": [
                { "start": "9:00", "end": "17:00" }
            ]
        },{
            "day": "sunday",
            "slots": []
        }
    ];
    
    // var monday, sched, db;
    
    // try {
    //     sched = Mongo.Collection.get('schedules')
    //     if (sched) {
    //         monday = sched.findOne({ day: 'monday' })
    //     }
    //     db = (sched !== undefined || monday !== undefined);
    // }
    // catch (e) {
    //     console.log(e)
    // }
    // finally {
    //     if (db === undefined && /sunsethoops/i.test(location.hostname)) {
            
    //         console.log('attempting to insert schedule')
            
    //         ScheduleInserter = new Mongo.Collection("schedules");
            
    //         scheduleArray.forEach( function(day) {
    //             console.log(day)
    //             ScheduleInserter.insert(day)
    //         })
            
    //     } else {
    //         console.log('local, not inserting stuff')
    //     }
    // }
}