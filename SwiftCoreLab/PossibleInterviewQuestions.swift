//
//  PossibleInterviewQuestions.swift
//  SwiftCoreLab
//
//  Created by Vidhi Rana on 29/12/25.
//
//
//Let's break down these Swift concepts in a straightforward manner:



/*
 1️⃣ Why are structs preferred in Swift?

Structs are often preferred in Swift for several reasons, primarily due to their value type semantics, which leads to predictable behavior and often better performance:

*   Value Semantics: When you pass a struct around or assign it to a new variable, Swift creates a copy of that struct. This means that changes made to the copy do not affect the original, making data flow more predictable and easier to reason about.
*   Immutability: When a struct's properties are declared as `let`, the entire struct becomes immutable. This encourages writing code that avoids unintended side effects, especially in concurrent environments.
*   Performance: For smaller data structures, structs can often live on the stack (a region of memory that is fast to access), rather than the heap (where classes reside). This can lead to performance benefits because allocating and deallocating memory on the stack is faster. Additionally, without reference counting overhead for each copy, they can be more efficient for simple data.
*   Thread Safety: Because structs are copied, each thread working with a struct gets its own independent copy. This inherently makes structs safer for multithreading, as you don't have to worry about multiple threads simultaneously modifying the same instance of data.
*   Simplicity: They are great for encapsulating data that doesn't require identity or shared mutable state. Examples include `Int`, `String`, `Array`, `Dictionary`, `CGRect`, etc.

In essence, you prefer structs when you care about the *value* of the data rather than a shared *identity* of an object.



 2️⃣ What is ARC?

ARC stands for Automatic Reference Counting.

It's Swift's (and Objective-C's) system for automatically managing memory. Here's how it works:

*   Reference Counting: When you create an instance of a class, ARC allocates memory for it. It then keeps a count of how many "strong references" currently point to that instance.
*   Strong References: A "strong reference" is like saying, "I need this object, please don't get rid of it!" Every time you assign a class instance to a new variable or property (by default), you create a strong reference, and ARC increments the instance's reference count.
*   Deallocation: When an instance's strong reference count drops to zero, it means no one is holding onto it with a "strong string" anymore. At this point, ARC automatically deallocates the instance's memory, making it available for reuse. The `deinit` method of the class is called just before deallocation.

Purpose: ARC frees you from manually tracking and releasing memory, which is a common source of bugs in languages like C++. You don't have to call `free()` or `delete()`; ARC handles it behind the scenes, preventing most memory leaks and dangling pointers.



 3️⃣ What causes retain cycles?

A retain cycle (or strong reference cycle) occurs when two or more class instances have strong references to each other, creating a closed loop where neither instance's strong reference count can ever reach zero, even if they are no longer needed by the rest of your application.

*   The Problem: Because their strong reference counts never drop to zero, ARC believes they are still in use. As a result, ARC will never deallocate their memory, leading to a memory leak. The `deinit` methods of the involved instances will never be called.
*   Analogy: As discussed, it's like two people holding each other with strong strings. Even if everyone else lets go, they're stuck in an endless loop, unable to leave because they're holding onto each other.

    Common Scenarios:
*   Parent-Child Relationships: A parent object strongly holds a child object, and the child object strongly holds a reference back to its parent (e.g., a `UITableViewCell` strongly holding its `delegate` which is a `UIViewController`).
*   Closures: A class instance strongly captures `self` within a closure, and that closure is then strongly held by another property of the same class instance, or by another object that the class instance itself strongly holds.



 4️⃣ Difference between weak and unowned

Both `weak` and `unowned` are ways to break retain cycles by creating non-strong references. The core difference lies in how they handle the possibility of the referenced instance being `nil`.

    `weak` references:

*   Optionality: A `weak` reference *must* be an optional type.
*   Lifetime: You use `weak` when the referenced instance might be deallocated before the referencing instance (i.e., it might become `nil` at some point).
*   Safety: If the referenced instance is deallocated, the `weak` reference automatically becomes `nil`. This is safe because you must handle the optional (`self?` or `guard let self = self`) when accessing it.
*   Use Case: Ideal for delegate patterns, situations where an object might asynchronously complete a task after the "owner" has already been deallocated, or any scenario where the referenced object might not exist anymore when you try to access it.

    `unowned` references:

*   Optionality: An `unowned` reference is not an optional type.
*   Lifetime: You use `unowned` when you are certain that the referenced instance will always have the same or a longer lifetime than the referencing instance. In other words, the `unowned` reference will *never* be `nil` when you try to access it.
*   Safety: If you try to access an `unowned` reference after the instance it refers to has been deallocated, your app will crash at runtime with a fatal error. This makes `unowned` less safe than `weak` if your lifetime assumptions are incorrect.
*   Use Case: Appropriate for scenarios where there's a clear "parent-child" relationship, and the child is guaranteed to be deallocated at or before the parent. For example, a closure that's always called *before* the object that owns the closure is deallocated.

*   General Guideline: When in doubt about lifetimes, always prefer `weak` because it provides runtime safety by becoming `nil`. Only use `unowned` when you are absolutely certain about the relative lifetimes of the two instances and performance is extremely critical (though the performance difference is often negligible).
 
 */
