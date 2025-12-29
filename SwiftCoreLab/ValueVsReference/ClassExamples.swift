//
//  ClassExamples.swift
//  SwiftCoreLab
//
//  Created by Vidhi Rana on 29/12/25.
//
//  This file demonstrates how Swift classes are REFERENCE types.
//  Assigning a class instance to another variable shares the SAME INSTANCE.
//  Mutating through one reference affects all references to that instance.
//

import Foundation

// MARK: - Reference Type: Class

/// `UserAccount` is a REFERENCE type because it's a class.
/// When you assign, pass, or return `UserAccount` instances,
/// Swift passes around references (pointers) to the SAME object.
class UserAccount {
    var username: String
    var email: String
    var isActive: Bool
    
    init(username: String, email: String, isActive: Bool = true) {
        self.username = username
        self.email = email
        self.isActive = isActive
    }
}

// MARK: - Examples of Reference Semantics

func demonstrateClassReferenceSharing() {
    // Create a UserAccount instance.
    let originalAccount = UserAccount(username: "alice123",
                                      email: "alice@example.com",
                                      isActive: true)
    
    // Assigning `originalAccount` to `sharedReference` does NOT create a copy.
    // Both variables now refer to the SAME underlying object in memory.
    let sharedReference = originalAccount
    
    // Mutate via the second reference.
    sharedReference.username = "alice_updated"
    sharedReference.isActive = false
    
    print("originalAccount.username: ", originalAccount.username) // alice_updated
    print("haredReference.username:", sharedReference.username) // alice_updated
    
    // At this point:
    // - `originalAccount.username` is "alice_updated"
    // - `sharedReference.username` is also "alice_updated"
    //
    // This shows that changing `sharedReference` ALSO affects `originalAccount`
    // because they both point to the same instance (shared reference).
}

func demonstrateClassPassingToFunction() {
    let account = UserAccount(username: "charlie777",
                              email: "charlie@example.com",
                              isActive: true)
    
    // Passing a `UserAccount` into a function passes a REFERENCE.
    // Mutations inside the function affect the same underlying object.
    deactivateAccount(account: account)
    
    // After this call:
    // - `account.isActive` is now false because the function mutated
    //   the shared instance through the passed-in reference.
}

/// This function receives a reference to `UserAccount`.
/// Mutating properties here changes the SAME instance the caller holds.
func deactivateAccount(account: UserAccount) {
    account.isActive = false
    // The caller sees this change because both sides share the same reference.
}

// MARK: - Demonstrating Reference Identity

func demonstrateClassIdentityComparison() {
    let accountA = UserAccount(username: "userA",
                               email: "a@example.com")
    
    // `accountB` is assigned from `accountA`, so they share the same instance.
    let accountB = accountA
    
    // `accountC` is a new, distinct instance with the same property values.
    let accountC = UserAccount(username: "userA",
                               email: "a@example.com")
    
    // Using the identity operator (`===`) checks if two references
    // point to the EXACT SAME instance in memory.
    
    let isASameAsB = (accountA === accountB)
    // `isASameAsB` is true because `accountA` and `accountB` share the same instance.
    
    let isASameAsC = (accountA === accountC)
    // `isASameAsC` is false because `accountC` is a different instance,
    // even though its property values match.
    
    // This demonstrates that classes have reference identity,
    // while structs only compare by their stored values (no reference identity).
}

// You can call these functions from somewhere else, e.g. in main or in tests:
// demonstrateClassReferenceSharing()
// demonstrateClassPassingToFunction()
// demonstrateClassIdentityComparison()
