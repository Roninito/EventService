import Foundation
import Combine
import ServiceKit
import JavaScriptCore


struct EventService {
    var text = "!"
}

@objc public protocol EventsJSExports: JSExport {
	var identifier: String { get }
	var registeredEvents: [String] { get }
	var numberOfRegisteredEvents: Int { get }
}

@objc public class Events: NSObject, ObservableObject, Serviceable, NSSecureCoding, EventsJSExports {
	public static var supportsSecureCoding: Bool = true
    public typealias ServiceProvider = Events
    public var provider: Events { self }
	private var manifest: [String: Event] = [:]

	public lazy var queue: OperationQueue = {
		let q = OperationQueue()
		q.name = identifier
		q.qualityOfService = .userInitiated
		return q
	}()
	
    @Published public var announcement: String = "Event Service Ready"
	@objc public dynamic var identifier: String = ""
	
	@objc public dynamic var numberOfRegisteredEvents: Int { manifest.count }
	@objc public dynamic var registeredEvents: [String] { manifest.keys.sorted() }
	public var didRegisterEvent = PassthroughSubject<Event, Never>()
	public var eventRaised = PassthroughSubject<Event, Never>()

    
	public init(identifier: String = "com.astra.genericEventService", isService: Bool = true) {
		super.init()
		self.identifier = identifier
		if isService == true {
			registerAsServiceable()			
		}
	}
    
	
	public func encode(with coder: NSCoder) {
		coder.encode(NSDictionary(dictionary: manifest), forKey: "manifest")
		coder.encode((identifier as NSString), forKey: "identifier")
	}
	
	
	public required init?(coder: NSCoder) {
		manifest = coder.decodeObject(of: NSDictionary.self, forKey: "manifest") as! [String: Event]
		identifier = coder.decodeObject(of: NSString.self, forKey: "identifier")! as String
	}
	
    
    private func register(event: Event) {
		queue.addOperation { [unowned self] in
			queue.addBarrierBlock {
				manifest[event.id] = event
				DispatchQueue.main.async {
					didRegisterEvent.send(event)
				}
			}
		}
    }
    
    
    private func event(_ eventID: String) -> Event? {
		return manifest[eventID]
    }
    
    
    public subscript(_ key: String = "") -> Event? {
        get { event(key) }
        set {
			register(event: newValue!)
		}
    }
    
    
    public func raise(by: Any, _ eventID: String, info: [String: Any]) {
		queue.addOperation { [unowned self] in
			if let theEvent = event(eventID) {
				DispatchQueue.main.async {
					announcement = "Event: \(eventID) raised by: \(String(describing: by)) with info: \(info)"
					theEvent.raised = info
					eventRaised.send(theEvent)
				}
			}
			else {
				print("Unable to raise the Event with ID: \(eventID)")
			}
		}
    }
}
