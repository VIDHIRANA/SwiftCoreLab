# SwiftCoreLab 🚀
# Phase 1 The Core Foundations. 🧱🍎

Welcome to SwiftCoreLab, a dedicated repository for mastering the deep internals of the Swift programming language and iOS Core Foundations.

This repository is part of the iOS Swift Revision Series, designed to bridge the gap between "knowing syntax" and "engineering scalable solutions." Instead of full applications, this lab focuses on isolated, professionalgrade implementations of core concepts that every Senior iOS Developer must master.

 🎯 Purpose

The goal of this repo is to demonstrate a deep understanding of Swift's memory management, type system, and concurrency models. Each module is documented with the "Why" behind the implementation, making it a perfect reference for technical interviews and peer reviews.

 📂 Repository Structure

The repo is organized into logical modules to ensure clean separation of concerns:

```text
SwiftCoreLab/
│
├── 🧠 ValueVsReference/      # Structs vs. Classes, CopyonWrite behavior
├── 🛡️ MemoryManagement/      # ARC, Strong/Weak/Unowned, Retain Cycles
├── 🪝 Closures/              # Capture Lists, Escaping vs. Nonescaping
├── ⚠️ ErrorHandling/         # Result types, Throws, Custom Errors
├── 🏗️ Protocols/             # ProtocolOriented Design (POP)
└── 📜 README.md              # Project documentation
```

# 🚀 Phase 1: Core Modules

# 1\. Value vs. Reference Types (`/ValueVsReference`)

  * Concepts: Implementation of `struct` vs `class`.
  * Objective: Demonstrating how memory is allocated (Stack vs. Heap) and how copy behavior differs between value types and reference types.
  * Key Files: `StructExamples.swift`, `ClassExamples.swift`.

# 2\. ARC & Memory Management (`/MemoryManagement`)

  * Concepts: Automatic Reference Counting (ARC) and memory safety.
  * Objective: Intentionally creating retain cycles between two objects and resolving them using the `weak` keyword.
  * Key Files: `RetainCycleDemo.swift`, `ARCExamples.swift`.

# 3\. Closures & Capture Lists (`/Closures`)

  * Concepts: Heapallocated blocks and scope.
  * Objective: Proving how `self` is captured in a closure and using `[weak self]` to prevent memory leaks. Includes explanations on when `unowned` is dangerous.
  * Key Files: `CaptureLists.swift`.

# Your Goal : Complete these 3 critical modules.

1️⃣ Value vs. Reference Types ⚖️
  * File: StructExamples.swift & ClassExamples.swift

  * Task: Implement a struct User and a class UserAccount.

  * The Challenge: Modify values in both and use comments to explain the copy behavior vs. shared reference. No print-only demos—explain the "why"!

2️⃣ ARC & Retain Cycles 🛡️
  * File: RetainCycleDemo.swift

  * Task: Create two classes that reference each other to intentionally trigger a memory leak.

  * The Fix: Implement weak to break the cycle.

  * The Challenge: Add comments explaining exactly why the leak happened and why weak was the solution.

3️⃣ Closures & Capture Lists (Most Important!) 🧠
File: CaptureLists.swift

  * Task: Create a closure capturing self.

  * The Challenge: Demonstrate a retain cycle and fix it using [weak self].

  * Pro Tip: Explain in your comments when unowned becomes dangerous!

 🧼 Senior Code Quality Rules

# Every file in this repository adheres to highlevel engineering standards:

  * Meaningful Naming: No ambiguous variables; code is selfdocumenting.
  * Zero Force Unwraps: Safety is prioritized via `if let` and `guard`.
  * The "Why" Rule: Comments don't explain *what* the code is doing—they explain *why* a specific engineering choice was made.
  * No Massive Functions: Logic is broken down into small, testable units.


 💡 How to Use This Lab

1.  Clone the repo: `git clone https://github.com/VIDHIRANA/SwiftCoreLab.git`
2.  Open in Xcode: Simply drag the files into a Swift Playground or a commandline tool project.
3.  Read the Comments: The value of this repo lies in the documentation within the files.


 🤝 Join the Journey

This project is updated daily as part of the iOS Swift Revision Series on LinkedIn.

  * Author: [Vidhi Rana](https://www.google.com/search?q=https://www.linkedin.com/in/vidhirana2010/)
  * Series Start Date: December 30, 2025

If you find this helpful for your own revision, feel free to ⭐ the repo and follow along\!



*Built with ❤️ and Swift.*

