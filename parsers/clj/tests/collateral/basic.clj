;; This is the most basic of sample files.

(project
  :name "basic"
  :version "0.1.0-dev"
  
  :tasks {:build {:tool "lldb-build"
                  :name "json-swift"
                  :output-type "lib" 
                  :source [ "src/**.swift" ]}}
)