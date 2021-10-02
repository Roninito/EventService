import Foundation
import Combine
import ServiceKit


struct EventService {
    var text = "Hello, World!"
}


public class Events: ObservableObject, Serviceable {
    
    public typealias ServiceProvider = Events
    public var provider: Events { self }
    private var manifest: [String: Event] = [:]
    @Published public var announcement: String = "Event Service Ready"
    
    
	public init(isService: Bool = true) {
		if isService == true { registerAsServiceable() }
	}
    
    
    private func register(event: Event) {
        manifest[event.id] = event
    }
    
    
    private func event(_ eventID: String) -> Event? {
        manifest[eventID]
    }
    
    
    public subscript(_ key: String = "") -> Event? {
        get { event(key) }
        set { register(event: newValue!) }
    }
    
    
    public func raise(by: Any, _ eventID: String, info: [String: Any]) {
        announcement = "Event: \(eventID) raised by: \(String(describing: by)) with info: \(info)"
        event(eventID)?.raised = info
    }
}
