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

import atpkg

/**
 * Provides the functionality of running a particular task from the build
 * configuration file. The primary work for the task is done via the tool
 * that is specified within the task.
 */
final public class TaskRunner {
    private init() {}

    static public func runTask(task: Task, package: Package) {
        for dependency in task.dependencies {
            guard let depTask = package.tasks[dependency] else { fatalError("The given dependency does not exist: \(dependency)") }
            TaskRunner.runTask(depTask, package: package)
        }
        
        print("Running task \(task.key)...")
        let tool = toolByName(task.tool)
        tool.run(task)
        print("Completed task \(task.key).")
    }
}