//
//  RetainCycleDemo.swift
//  SwiftCoreLab
//
//  Created by Vidhi Rana on 29/12/25.
//
//  This file demonstrates how a retain cycle (strong reference cycle)
//  between two class instances causes a memory leak,
//  and how using `weak` breaks that cycle so ARC can deallocate them.
//

import Foundation

// MARK: - Example 1: Retain cycle (memory leak)

// In this example, `Owner` strongly references `Pet`,
// and `Pet` strongly references `Owner`.
// Because both references are strong, ARC will NEVER
// be able to reduce their reference counts to zero,
// so neither instance will be deallocated.

class Owner {
    let name: String
    
    // Strong reference to Pet (default).
    // `var pet: Pet?` is the same as `var pet: Pet?` with `strong` semantics.
    var pet: Pet?
    
    init(name: String) {
        self.name = name
        print("Owner $name) initialized")
    }
    
    deinit {
        print("Owner $name) deinitialized")
    }
}

class Pet {
    let name: String
    
    // Strong reference back to Owner.
    // This forms a STRONG REFERENCE CYCLE when `Owner.pet` also strongly
    // points to this `Pet` instance.
    var owner: Owner?
    
    init(name: String) {
        self.name = name
        print("Pet $name) initialized")
    }
    
    deinit {
        print("Pet $name) deinitialized")
    }
}

/// This function creates a retain cycle ON PURPOSE to demonstrate
/// how a memory leak can happen.
///
/// Explanation:
/// 1. `owner` and `pet` are local strong references within this function.
/// 2. `owner.pet` strongly references `pet`.
/// 3. `pet.owner` strongly references `owner`.
/// 4. At the end of this function, the local variables `owner` and `pet`
///    go out of scope and their strong references are removed.
/// 5. HOWEVER, `owner` and `pet` still strongly reference each other,
///    so their reference counts never drop to zero.
/// 6. As a result, ARC cannot deallocate them, and their `deinit` methods
///    are NEVER called ⇒ memory leak.
func createRetainCycle() {
    let owner = Owner(name: "Alice")
    let pet = Pet(name: "Fluffy")
    
    // Establish mutual strong references (retain cycle).
    owner.pet = pet          // Owner strongly retains Pet
    pet.owner = owner        // Pet strongly retains Owner
    
    // When this function returns:
    // - The local variables `owner` and `pet` disappear,
    //   but the objects they pointed to remain in memory
    //   because they still strongly reference each other.
    //
    // ARC sees:
    //   Owner instance: strong count >= 1 (from Pet.owner)
    //   Pet instance:   strong count >= 1 (from Owner.pet)
    //
    // Since neither count reaches 0, ARC will NOT call `deinit`.
    // This is the classic strong reference cycle / retain cycle.
}



// MARK: - Example 2: Fix with `weak` (no memory leak)

// To fix the retain cycle, we break the "strong–strong" pattern.
// Typically, one side of the relationship is "owning/parent",
// and the other is "child/secondary".
//
// Here, we treat `Owner` as the "owner" of `Pet`:
// - Owner strongly owns Pet.
// - Pet has a non-owning reference back to Owner.
//
// We express "non-owning" with `weak`, meaning:
// - `weak` references do NOT increase the strong reference count.
// - ARC is free to deallocate the object even if `weak` references still point to it.
// - When ARC deallocates the object, all `weak` references are automatically
//   set to `nil` to avoid dangling pointers.

class OwnerFixed {
    let name: String
    
    // Strong reference to Pet (Owner "owns" the Pet).
    var pet: PetFixed?
    
    init(name: String) {
        self.name = name
        print("OwnerFixed $name) initialized")
    }
    
    deinit {
        print("OwnerFixed $name) deinitialized")
    }
}

class PetFixed {
    let name: String
    
    // `weak` is required to be optional (must be a reference type, optional).
    // This is a NON-OWNING reference:
    // - It does NOT increase the strong reference count of `OwnerFixed`.
    // - It prevents the retain cycle because now only OwnerFixed strongly
    //   retains PetFixed, but PetFixed does NOT strongly retain OwnerFixed.
    weak var owner: OwnerFixed?
    
    init(name: String) {
        self.name = name
        print("PetFixed $name) initialized")
    }
    
    deinit {
        print("PetFixed $name) deinitialized")
    }
}

/// This function shows the corrected pattern using `weak`.
///
/// Explanation:
/// 1. `owner` strongly references `OwnerFixed`.
/// 2. `owner.pet` strongly references `PetFixed`.
/// 3. `pet.owner` is a `weak` reference to `OwnerFixed`,
///    so it does NOT increment the strong reference count.
/// 4. When the function returns, the local variables `owner` and `pet`
///    go out of scope, removing their strong references.
/// 5. Now:
///    - OwnerFixed has no strong references ⇒ deallocated.
///    - PetFixed has no strong references ⇒ deallocated.
/// 6. Both `deinit` methods are called, proving no leak.
func createNoRetainCycleWithWeak() {
    let owner = OwnerFixed(name: "Bob")
    let pet = PetFixed(name: "Buddy")
    
    owner.pet = pet          // OwnerFixed strongly retains PetFixed
    pet.owner = owner        // PetFixed holds a WEAK reference to OwnerFixed
    
    // At the end of this function:
    // - The strong references from these local variables go away.
    // - Only strong references left are within the object graph itself:
    //     OwnerFixed.pet  → strong → PetFixed
    //     PetFixed.owner → weak  → OwnerFixed
    //
    // ARC sees:
    //   OwnerFixed instance: strong count == 1 (from local `owner`),
    //   PetFixed instance:   strong count == 1 (from OwnerFixed.pet).
    //
    // After scope exit:
    //   - local `owner` and `pet` references are removed.
    //   - OwnerFixed strong count drops to 1 → then to 0 (no more strong refs).
    //   - ARC deallocates OwnerFixed, calling its `deinit`.
    //   - Because `PetFixed.owner` is `weak`, it is automatically set to nil.
    //   - PetFixed now has strong count == 0, so it is also deallocated,
    //     calling its `deinit`.
    //
    // The key point:
    //   `weak` breaks the strong–strong cycle, turning it into strong–weak.
    //   ARC can then correctly reclaim memory.
}



// MARK: - How to run this demo (example usage)

// Call these from somewhere like `main.swift` or a playground:
//
// createRetainCycle()
//   - You will see the init messages printed.
//   - You will NOT see `deinit` messages for `Owner` and `Pet`
//     because of the retain cycle (memory leak).
//
// createNoRetainCycleWithWeak()
//   - You will see both init and deinit messages for
//     `OwnerFixed` and `PetFixed`.
//   - This shows that using `weak` solved the retain cycle.
