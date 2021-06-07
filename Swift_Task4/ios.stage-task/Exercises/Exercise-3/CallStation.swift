import Foundation

final class CallStation {
    var usersArray: [User] = []
    var callsArray: [Call] = []
}

extension CallStation: Station {
    func users() -> [User] {
        return usersArray
    }
    
    func add(user: User) {
        if !usersArray.contains(user) {
            usersArray.append(user)
        }
    }
    
    func remove(user: User) {
        let delUser = usersArray.firstIndex(of: user)!
        usersArray.remove(at: delUser)

    }
    
    func execute(action: CallAction) -> CallID? {
        
        switch action {
        
        case let .start(from: userTransmitter, to: userReceiver):

            if !(usersArray.contains(userTransmitter) || usersArray.contains(userReceiver)) {
                return nil
            }
                    let callID = CallID()
                    var callStatus: CallStatus
            
                    if !usersArray.contains(userTransmitter) || !usersArray.contains(userReceiver) {
                        callStatus = .ended(reason: .error)
                    } else if calls(user: userReceiver).filter({ $0.status == .talk || $0.status == .calling }).count > 0 {
                        callStatus = .ended(reason: .userBusy)
                    } else {
                        callStatus = .calling
                    }
                    callsArray.append(Call(id: callID, incomingUser: userReceiver, outgoingUser: userTransmitter, status: callStatus))
                    
                    return callID
            
        
        case let .answer(from: userReceiver):
        
                guard let call = callsArray.filter({ $0.incomingUser == userReceiver && $0.status == .calling }).first else {
                return nil }
            
                for user in [call.incomingUser, call.outgoingUser] {
                    if !usersArray.contains(user) {
                        for brokenCall in calls(user: user) {
                            newStatusRec(for: brokenCall, to: .ended(reason: .error))
                        }
                        return nil
                    }
                }
                newStatusRec(for: call, to: .talk)
                return call.id
        
        case let .end(from: user):
                guard let call = calls(user: user).filter({ $0.status == .talk ||  $0.status == .calling }).first else { return nil }
                    
                        let end: CallEndReason = call.status == .talk ? .end : .cancel
                        newStatusRec(for: call, to: .ended(reason: end))
                        return call.id
        }
    }
    
    func calls() -> [Call] {
            callsArray
        }
        
        func calls(user: User) -> [Call] {
            callsArray.filter { $0.incomingUser.id == user.id || $0.outgoingUser.id == user.id}
        }
        
        func call(id: CallID) -> Call? {
            callsArray.filter { $0.id == id }.first
        }
        
        func currentCall(user: User) -> Call? {
            calls(user: user).filter { $0.status == .calling || $0.status == .talk }.first
        }
    
     private func newStatusRec(for call: Call, to status: CallStatus) {
            callsArray = callsArray.filter { $0.id != call.id }
            callsArray.append(Call(id: call.id, incomingUser: call.incomingUser, outgoingUser: call.outgoingUser, status: status))
        }
    
}
