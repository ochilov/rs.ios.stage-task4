import Foundation

final class CallStation {
	private var _users: [User] = []
	private var _calls: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
		return _users
    }
    
    func add(user: User) {
		if _users.firstIndex(of: user) != nil {
			return
		}
		_users.append(user)
    }
    
    func remove(user: User) {
		if let index = _users.firstIndex(of: user) {
			_users.remove(at: index)
			if let call = self.currentCall(user: user) {
				if let callIndex = _calls.firstIndex(of: call) {
					_calls.remove(at: callIndex)
				}
				_calls.insert(call.end(reason: .error), at: 0)
			}
		}
    }
    
	func execute(action: CallAction) -> CallID? {
		switch action {
		case .start(from: let from, to: let to):
			if _users.contains(from) {
				var callStatus: CallStatus = .calling
				if !_users.contains(to) {
					callStatus = .ended(reason: .error)
				} else if self.currentCall(user: to) != nil {
					callStatus = .ended(reason: .userBusy)
				}
				
				let call: Call = .init(
					id: UUID(),
					incomingUser: from,
					outgoingUser: to,
					status: callStatus)
				_calls.insert(call, at: 0)
				return call.id
			}
		case .answer(from: let from):
			if _users.contains(from) {
				for (index, call) in _calls.enumerated() {
					if (call.outgoingUser == from) {
						_calls.remove(at: index)
						_calls.insert(call.answer(), at: 0)
						return _calls.first?.id
					}
				}
			}
		case .end(from: let from):
			if _users.contains(from){
				for (index, call) in _calls.enumerated() {
					if (call.incomingUser == from || call.outgoingUser == from) {
						_calls.remove(at: index)
						_calls.insert(call.end(reason: call.status == .talk ? .end : .cancel), at: 0)
						return _calls.first?.id
					}
				}
			}
		}
        return nil
    }
    
    func calls() -> [Call] {
		return _calls
    }
    
    func calls(user: User) -> [Call] {
		var userCalls: [Call] = []
		for call in _calls {
			if call.incomingUser == user || call.outgoingUser == user {
				userCalls.append(call)
			}
		}
		return userCalls
    }
    
    func call(id: CallID) -> Call? {
		for call in _calls {
			if call.id == id {
				return call
			}
		}
		return nil
    }
    
    func currentCall(user: User) -> Call? {
		for call in _calls {
			if (call.status == .calling || call.status == .talk) {
				if (call.incomingUser == user || call.outgoingUser == user) {
					return call
				}
			}
		}
		return nil
    }
}

extension Call {
	func answer() -> Self {
		return .init(id: self.id,
					 incomingUser: self.incomingUser,
					 outgoingUser: self.outgoingUser,
					 status: .talk)
	}
	
	func end(reason: CallEndReason) -> Self {
		return .init(id: self.id,
					 incomingUser: self.incomingUser,
					 outgoingUser: self.outgoingUser,
					 status: .ended(reason: reason))
	}
}


extension Call: Equatable {
	static func == (lhs: Self, rhs: Self) -> Bool {
		return lhs.id == rhs.id
	}
}
