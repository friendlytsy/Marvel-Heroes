//
//  AsyncOperation.swift
//  Marvel Heroes
//
//  Created by Александр Цыганков on 27.10.2021.
//

import Foundation

class AsyncOperation : Operation {
    enum State : String {
        case ready, executing, finished
        
        var keyPath: String {
            return "is" + rawValue.capitalized
        }
    }
    
    var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        return super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        return state == .executing
    }
    
    override var isFinished: Bool {
        return state == .finished
    }
    
    private var _isCancelled = false {
        willSet {
            willChangeValue(forKey: "isCancelled")
        }
        didSet {
            didChangeValue(forKey: "isCancelled")
        }
    }
    
    override var isCancelled: Bool {
        get {
            return _isCancelled
        }
    }
    
    override var isAsynchronous: Bool {
       return true
    }
    
    override func start() {
        guard isCancelled == false else {
            state = .finished
            return
        }
        main()
        state = .executing
    }
    
    override func cancel() {
        _isCancelled = true
    }
}
