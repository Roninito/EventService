//
//  Events.swift
//  DragTestign
//
//  Created by leerie simpson on 3/6/21.
//

import Foundation
import Combine
import ServiceKit


public class Event: NSObject, Identifiable, NSSecureCoding {
	
	public static var supportsSecureCoding: Bool = true
	
    public var id: String
	
    @Published public var raised: [String: Any]
    
	
    public init(_ eventID: String) {
        self.id = eventID
        self.raised = [:]
    }
	
	public required init?(coder: NSCoder) {
			id = coder.decodeObject(of: NSString.self, forKey: "id")! as String
			raised = coder.decodeObject(of: NSDictionary.self, forKey: "raised") as! [String: Any]
	}

	public func encode(with coder: NSCoder) {
		coder.encode(NSString(utf8String: id), forKey: "id")
		coder.encode(NSDictionary(dictionary: raised), forKey: "raised")
	}
	
	
	
}

