// Copyright (c) 2016 Anarchy Tools Contributors.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//   http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

// NOTE: This is the crappiest test thing ever... but it works for now.

extension String : ErrorType {}

enum test {
    static func assert(condition: Bool, functionName: String = __FUNCTION__) throws {
        print("  \(functionName): \(condition ? "PASSED" : "**FAILED**")")
        if !condition { throw "clj.tests.failed" }
    }
}

protocol Test {
    init()
    func runTests()
    
    var tests: [() throws -> ()] { get }
    var filename: String { get }
}

extension Test {
    func runTests() {
        print("Tests for \(filename)")
        for test in tests {
            let _ = try? test()
        }
    }
}

print()

let tests: [Test] = [
    // NOTE: Add your test classes here...
    
    RingBufferTests(),
    ScannerTests(),
    LexerTests()
]

for test in tests {
    test.runTests()
}

print()