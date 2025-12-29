//
//  StructExamples.swift
//  SwiftCoreLab
//
//  Created by Vidhi Rana on 29/12/25.
//
//  This file demonstrates how Swift structs are VALUE types.
//  Assigning a struct to another variable creates a COPY.
//  Mutating one copy does NOT affect the other.
//

import Foundation

// MARK: - Value Type: Struct

/// `User` is a VALUE type because it's a struct.
/// When you assign, pass, or return a `User`, Swift creates a copy.
struct User {
    var id: Int
    var name: String
    var age: Int
}

// MARK: - Examples of Value Semantics

func demonstrateStructCopyBehavior() {
    // Create an initial User instance.
    var originalUser = User(id: 1, name: "Alice", age: 30)
    
    // Assigning `originalUser` to `copiedUser` creates a NEW, INDEPENDENT COPY.
    // After this line, `originalUser` and `copiedUser` hold separate data.
    var copiedUser = originalUser
    
    // Mutate the copy.
    copiedUser.name = "Bob"
    copiedUser.age = 25
    
    // At this point:
    // - `originalUser.name` is still "Alice"
    // - `copiedUser.name` is "Bob"
    //
    // This shows that changing `copiedUser` does NOT affect `originalUser`
    // because struct assignment copies the value.
}

func demonstrateStructPassingToFunction() {
    var user = User(id: 2, name: "Charlie", age: 40)
    
    // Passing `user` into a function also passes a COPY (by value).
    // Mutations inside the function will NOT change this variable
    // unless we explicitly pass it as `inout`.
    incrementAgeForCopy(user: user)
    
    // After this call:
    // - Inside `incrementAgeForCopy`, the age was modified on a local copy.
    // - Here, `user.age` is still 40.
    
    // To actually mutate the original `user`, we must use `inout`:
    incrementAgeInPlace(user: &user)
    // After this call:
    // - `user.age` is now 41 because we explicitly allowed in-place mutation.
}

/// This function receives a COPY of the `User`.
/// Changes here do NOT affect the original instance.
func incrementAgeForCopy(user: User) {
    var localUser = user
    localUser.age += 1
    // `localUser` is modified, but the caller's `user` is unchanged.
}

/// This function receives the `User` as `inout`,
/// which means it can mutate the caller's instance directly.
func incrementAgeInPlace(user: inout User) {
    user.age += 1
    // This mutation changes the original instance held by the caller.
}

// You can call these functions from somewhere else, e.g. in main or in tests:
// demonstrateStructCopyBehavior()
// demonstrateStructPassingToFunction()
