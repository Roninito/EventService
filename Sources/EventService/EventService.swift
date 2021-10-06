import Foundation
import Combine
import ServiceKit


struct EventService {
    var text = "!"
}


public class Events: NSObject, ObservableObject, Serviceable, NSSecureCoding {
	public static var supportsSecureCoding: Bool = true
	
    
    public typealias ServiceProvider = Events
    public var provider: Events { self }
    private var manifest: [String: Event] = [:]
	
	private lazy var queue: OperationQueue = {
		let q = OperationQueue()
		q.name = identifier
		q.qualityOfService = .default
		return q
	}()
	
    @Published public var announcement: String = "Event Service Ready"
	private var identifier: String = "Generic Event Service"
	
	public var numberOfRegisteredEvents: Int { manifest.count }
	public var registeredEvents: [String] { manifest.keys.sorted() }
    
    
	public init(identifier: String?, isService: Bool = true) {
		super.init()
		self.identifier = identifier ?? self.identifier
		if isService == true { registerAsServiceable() }
	}
    
	
	public func encode(with coder: NSCoder) {
		coder.encode(NSDictionary(dictionary: manifest), forKey: "manifest")
	}
	
	
	public required init?(coder: NSCoder) {
		manifest = coder.decodeObject(of: NSDictionary.self, forKey: "manifest") as! [String: Event]
	}
	
    
    private func register(event: Event) {
		queue.addOperation { [unowned self] in
			manifest[event.id] = event
		}
        
    }
    
    
    private func event(_ eventID: String) -> Event? {
        manifest[eventID]
    }
    
    
    public subscript(_ key: String = "") -> Event? {
        get { event(key) }
        set {
			queue.addOperation { [unowned self] in
				register(event: newValue!)
			}
		}
    }
    
    
    public func raise(by: Any, _ eventID: String, info: [String: Any]) {
		queue.addOperation { [unowned self] in
			announcement = "Event: \(eventID) raised by: \(String(describing: by)) with info: \(info)"
			event(eventID)?.raised = info
		}
    }
}
