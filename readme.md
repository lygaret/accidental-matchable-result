---
name:    matchable_result
version: 0.0.1
summary: dry-monads Result, but with pattern matching
dependencies:
  - "dry-monads"
devDependencies:
  - "minitest"
---

Subclasses of `dry-monads`' Result monad, with the addition of ruby pattern 
matching deconstructors. This allows the use of ruby native pattern matching on 
`Result` values.

## Usage

Add this repo to your `Gemfile`:

```ruby
gem "matchable_result", "~> 0", git: "https://github.com/lygaret/accidental-matchable-result"
```

Then:

```ruby
require 'accidental/matchable_result'

include Accidental::MatchableResult

result = begin
  raise "oh no"
  
  # get nice success/failure methods with the include
  success("some value")    # great!
  failure(:error_code)     # no exception
rescue => ex 
  failure(:error_code, ex) # with exception
end

# use ruby pattern matching to deconstruct the result values
case result
in { success: }
  puts "success! #{success}"

# failure, but exception is nil, so not an error
in { failure:, exception: nil }
  puts "failure! #{failure}"

# failure, and exception can be anything
# _but_ it already fell through above, so we know exception is not nil
in { failure:, exception: }
  puts "error! #{failure} #{exception}"

# completeness, but shouldn't ever be hit
else
  puts "unreachable"
end

#=>
# error! :error_code "oh no"
```
