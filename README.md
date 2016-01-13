# atbuild

The Anarchy Tools Build Tool.

```bash
$ atbuild build
$ atbuild build-tests
$ atbuild run-tests
```

The configuration file defines *tasks*, which are entrypoints on the CLI.  `build`, `build-tests`, and `run-tests` are *tasks*.

This runs a task called `default`:

```bash
$ atbuild
```

Configurations could look like this:

```bash
$ atbuild run-tests --platform linux
```

```yaml
package:
  name: "sample"
  description: "A configuration sample"
  
  # Dependencies aren't resolved by the build tool (you want the package manager), but they look like this:
  
  dependencies:
    - "https://github.com/apple/swift-lldb", “2.2-SNAPSHOT”
    
  # We can declare custom tools.
  tools:
    xctest-runner:
      type: shell
      profiles:
        #specify custom behavior for osx/linux
        platform:
          osx:
            script: "xctest $outputdir/$testlib"
          linux:
            script: "xctest-linux $outputdir/$testlib"
  
tasks:
  
  #There's no magic; this is just a task called "build"
	build:
	  #A tool that compiles the swift module
		tool: atllbuild
		
		#The rest of these settings are just options for that tool
		name: json-swift
		output-type: library
		
		#walk the src directory and recursively find all swift files
		source: ["src/**.swift"] 
		profiles:
		  #override custom settings for swift/linux
      platform:
			  linux:
				  deps: ["build-foundation"]
				  linkflags: ["-lFoundation"]
			  osx:
				  linkflags: ["-Framework Foundation"]
			  default:
				  tool: "abort"
				  message = "You need to specify --profile [osx|linux]"
		
		#A second task, named "build-test"
		#This builds a test target
		build-test:
		  deps: ["build"] #Build the main target first
		  tool: "lldb-build"
		  name: "test"
		  output-type: "XCTest"
		  source: ["tests/**.swift"]
		
		#A third task, that runs the test
		run-tests:
		  deps: ["build-test"] #build them first
		  tool: xctest-runner #use the xctest-runner tool we created
		  testlib: tests.xctest #pass this argument
```

In the example above, there are three built-in tools: “lldb-build”, "abort", and “shell”. These tools take in the parameters from the configuration file for their respective usages. In addition, there is another tool defined, “xctest-runner”, that is just an alias of sorts to invoke the “shell” tool in a specific way.

The package file is a set of metadata to describe how the build process should work, and push all the actual work out to separate tools. There are a set of tools that are built-in that provide some of the standard behavior we want to support. At the same time, there are extension points to defining new tools as well. These tools can be defined within the package file or within source code for more advanced tools.

