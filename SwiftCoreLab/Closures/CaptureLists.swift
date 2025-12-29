//
//  CaptureLists.swift
//  SwiftCoreLab
//
//  Created by Vidhi Rana on 29/12/25.
//
//  This file demonstrates how closures can create retain cycles when capturing `self`
//  and how to fix them using `[weak self]` in a capture list.
//

import Foundation

// MARK: - 1. Demonstrating Retain Cycle with Closure Capturing `self` (Memory Leak)

/// A class that might hold a closure.
class DataProcessor {
    var processingCompletion: (() -> Void)?
    let id: Int

    init(id: Int) {
        self.id = id
        print("DataProcessor \(id) initialized")
    }

    deinit {
        print("DataProcessor \(id) deinitialized")
    }

    func performProcessing(onComplete: @escaping () -> Void) {
        print("DataProcessor \(id) is performing operations...")
        // In a real scenario, this closure would be called later (e.g., after an async task).
        // For demonstration, we just store it.
        self.processingCompletion = onComplete
    }
}

/// A class that owns a `DataProcessor` and provides a completion handler.
class ViewModelWithLeak {
    var processor: DataProcessor?
    let name: String

    init(name: String) {
        self.name = name
        print("ViewModelWithLeak \(name) initialized")
    }

    deinit {
        print("ViewModelWithLeak \(name) deinitialized")
    }

    func startDataFlow() {
        let dataProcessor = DataProcessor(id: 1)
        self.processor = dataProcessor

        // This closure is assigned to `dataProcessor.processingCompletion`.
        // The closure, by default, strongly captures any external references it uses.
        // Here, it captures `self` (the `ViewModelWithLeak` instance).

        dataProcessor.performProcessing {
            // Because `self` is used inside this closure, and there's no capture list,
            // the closure implicitly creates a strong reference to `self`.
            //
            // This creates a STRONG REFERENCE CYCLE (retain cycle):
            // ViewModelWithLeak -(strong)-> DataProcessor -(strong)-> Closure -(strong)-> ViewModelWithLeak
            //
            // 📌 Why a memory leak happens:
            // ---------------------------
            // 1. `ViewModelWithLeak` has a strong reference to `DataProcessor` (`self.processor`).
            // 2. `DataProcessor` has a strong reference to the closure (`processingCompletion`).
            // 3. The closure has an implicit strong reference back to `ViewModelWithLeak` (`self`).
            //
            // Even when the local `viewModelWithLeak` variable goes out of scope,
            // the strong references within the cycle prevent their reference counts
            // from ever reaching zero. Thus, `deinit` is never called for either instance,
            // and their memory is never reclaimed (a memory leak).
            print("\(self.name): Data processing finished!")
        }
        print("ViewModelWithLeak \(name): Data flow started. Closure set up.")
    }
}

/// Function to demonstrate the leak.
func demonstrateRetainCycle() {
    print("\n--- Demonstrating Retain Cycle ---")
    var viewModelWithLeak: ViewModelWithLeak? = ViewModelWithLeak(name: "Leaky ViewModel")
    viewModelWithLeak?.startDataFlow()

    // Setting viewModelWithLeak to nil should deallocate it,
    // but due to the retain cycle, its deinit will NOT be called.
    print("Setting viewModelWithLeak to nil...")
    viewModelWithLeak = nil
    print("Expected: ViewModelWithLeak deinitialized. Actual: NOT deinitialized (memory leak).")
}

// MARK: - 2. Fixing the Retain Cycle using `[weak self]`

/// A class that might hold a closure (same as DataProcessor).
class DataProcessorFixed {
    var processingCompletion: (() -> Void)?
    let id: Int

    init(id: Int) {
        self.id = id
        print("DataProcessorFixed \(id) initialized")
    }

    deinit {
        print("DataProcessorFixed \(id) deinitialized")
    }

    func performProcessing(onComplete: @escaping () -> Void) {
        print("DataProcessorFixed \(id) is performing operations...")
        self.processingCompletion = onComplete
    }
}

/// A class that owns a `DataProcessorFixed` and uses `[weak self]` to prevent leaks.
class ViewModelFixed {
    var processor: DataProcessorFixed?
    let name: String

    init(name: String) {
        self.name = name
        print("ViewModelFixed \(name) initialized")
    }

    deinit {
        print("ViewModelFixed \(name) deinitialized")
    }

    func startDataFlow() {
        let dataProcessor = DataProcessorFixed(id: 2)
        self.processor = dataProcessor

        dataProcessor.performProcessing { [weak self] in
            // 📌 Fix using [weak self]:
            // ------------------------
            // The `[weak self]` in the capture list ensures that the closure
            // creates a WEAK reference to `self` (the `ViewModelFixed` instance).
            //
            // A weak reference does NOT increase the reference count of the captured instance.
            // This breaks the strong reference cycle:
            // ViewModelFixed -(strong)-> DataProcessorFixed -(strong)-> Closure -(weak)-> ViewModelFixed
            //
            // Since the closure's reference to `self` is weak, it no longer contributes
            // to `ViewModelFixed`'s strong reference count.
            //
            // `weak self` makes `self` an optional, so you must unwrap it (`self?` or `guard let`).
            guard let self = self else {
                print("ViewModelFixed has already been deinitialized. Closure skipped.")
                return
            }
            print("\(self.name): Data processing finished (fixed)!")
        }
        print("ViewModelFixed \(name): Data flow started. Closure set up.")
    }
}

/// Function to demonstrate the fix.
func demonstrateFixedCycle() {
    print("\n--- Demonstrating Fixed Cycle with [weak self] ---")
    var viewModelFixed: ViewModelFixed? = ViewModelFixed(name: "Fixed ViewModel")
    viewModelFixed?.startDataFlow()

    // Setting viewModelFixed to nil should now successfully deallocate it
    // because the retain cycle has been broken.
    print("Setting viewModelFixed to nil...")
    viewModelFixed = nil
    print("Expected: ViewModelFixed deinitialized. Actual: Deinitialized (no memory leak).")
}

// MARK: - 3. When to use `weak` vs. `unowned` and when `unowned` is dangerous

/*
 📌 When to use `weak`:
 ---------------------
 Use `[weak self]` when:
 -   The captured instance (`self`) might be deallocated *before* the closure itself is deallocated.
 -   It's possible for `self` to be `nil` at the time the closure executes.
 -   This is the most common and safest option for breaking retain cycles involving `self` in asynchronous operations or delegate patterns where the delegate (e.g., `self`) might be removed before the task completes.
 -   `weak self` results in an *optional* `self` inside the closure, requiring you to handle the `nil` case (e.g., `guard let self = self else { return }`).

 📌 When to use `unowned`:
 -------------------------
 Use `[unowned self]` when:
 -   The captured instance (`self`) will *never* be deallocated *before* the closure itself is deallocated.
 -   You are absolutely certain that `self` will always be present when the closure runs.
 -   This is often appropriate in scenarios like closure-based delegates where the delegate and delegator have strictly defined lifetimes (e.g., a "parent" view controller always outlives its "child" view controller, or when a view controller's closure reference is released before the view controller itself).
 -   `unowned self` results in a *non-optional* `self` inside the closure, meaning you can use `self.` directly without unwrapping.

 📌 When `unowned` is dangerous:
 -------------------------------
 `unowned` is dangerous when your assumption that `self` will always be present is *wrong*.
 -   If the instance captured as `unowned` is deallocated *before* the closure runs and attempts to access it, you will encounter a **runtime crash (fatal error)**. This is because `unowned` is an implicitly unwrapped optional under the hood; accessing it after it has been deallocated is like force-unwrapping a `nil` value.
 -   Therefore, `unowned` should only be used when the lifetimes are very clear and you can guarantee the unowned reference will always be valid during the closure's execution. When in doubt, always prefer `weak`.
 */

// MARK: - Example of an `unowned` scenario (safe usage typically in parent-child or synchronous contexts)

class Parent {
    let name: String
    var child: Child?

    init(name: String) {
        self.name = name
        print("Parent \(name) initialized")
    }

    deinit {
        print("Parent \(name) deinitialized")
    }

    func setupChild(childName: String) {
        // Child is expected to be strongly held by Parent,
        // and its closure will not outlive the Parent.
        self.child = Child(name: childName, parentAction: { [unowned self] in
            // Here, it's generally safe to use `unowned self` because:
            // 1. The `Parent` instance (`self`) strongly owns the `Child` instance.
            // 2. The `Child` instance (and its `parentAction` closure) will be deallocated
            //    *before* or *at the same time as* the `Parent` instance.
            // Therefore, `self` will always be valid when this closure is called.
            print("Child is performing action for parent \(self.name).")
        })
    }
}

class Child {
    let name: String
    let parentAction: () -> Void

    init(name: String, parentAction: @escaping () -> Void) {
        self.name = name
        self.parentAction = parentAction
        print("Child \(name) initialized")
    }

    deinit {
        print("Child \(name) deinitialized")
    }

    func triggerParentAction() {
        parentAction()
    }
}

func demonstrateUnowned() {
    print("\n--- Demonstrating Unowned Capture ---")
    var parent: Parent? = Parent(name: "Main Parent")
    parent?.setupChild(childName: "First Child")
    parent?.child?.triggerParentAction()

    print("Setting parent to nil...")
    parent = nil
    print("Expected: Parent and Child deinitialized. Actual: Deinitialized (no memory leak with unowned).")
}


// MARK: - How to run this demo (example usage)

// To see these demonstrations in action, uncomment the calls below.
// Run this code in a Swift Playground or a simple command-line project.

// demonstrateRetainCycle()
// // You will notice "ViewModelWithLeak Leaky ViewModel deinitialized" is NOT printed,
// // indicating a memory leak.

// demonstrateFixedCycle()
// // You will see "ViewModelFixed Fixed ViewModel deinitialized" is printed,
// // indicating the retain cycle was successfully broken.

// demonstrateUnowned()
// // You will see "Parent Main Parent deinitialized" and "Child First Child deinitialized"
// // are printed, showing safe unowned usage in this specific lifetime context.
