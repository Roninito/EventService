import Cocoa
import EventService
import PlaygroundSupport

PlaygroundSupport.PlaygroundPage.current.needsIndefiniteExecution = true
//: This starts the Events service
let events = Events()
//: This is how you register an event with the system.
events[] = Event("some.event.name")
//: This is how events are subscribed to. Subscriptions are annonymous from the point of view of the Events system.
let subscription = events["some.event.name"]?.$raised.sink(receiveValue: { info in
    print("Event Raised with info: \(info.description)")
})
//: Anyone can report any event. In general objects should not report events on behalf of other objects but it is totally fine to do so.
let reporter = "Charlie"
//: Rasing an event requires the reporter, the event title and an Dictionary.
events.raise(by: reporter, "some.event.name", info: ["Name" : "Bob"])
//: This just shows the event being raised in a second to show that it works.
DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
    events.raise(by: reporter, "some.event.name", info: ["Name" : "Jane"])
}
