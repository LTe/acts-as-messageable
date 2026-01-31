---
safe_type
---
[![Gem Version](https://badge.fury.io/rb/safe_type.svg)](https://badge.fury.io/rb/safe_type)
[![Build Status](https://travis-ci.org/chanzuckerberg/safe_type.svg?branch=master)](https://travis-ci.org/chanzuckerberg/safe_type)
[![Maintainability](https://api.codeclimate.com/v1/badges/7fbc9a4038b86ef639e1/maintainability)](https://codeclimate.com/github/chanzuckerberg/safe_type/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/7fbc9a4038b86ef639e1/test_coverage)](https://codeclimate.com/github/chanzuckerberg/safe_type/test_coverage)

While working with environment variables, routing parameters, network responses, or other Hash-like objects that require parsing, we often need type coercion to assure expected behaviors.

***safe_type*** provides an intuitive type coercion interface and type enhancement.

# Installation

We can install `safe_type` using `gem install`: 

```bash
gem install safe_type
```

Or we can add it as a dependency in the `Gemfile` and run `bundle install`:

```ruby
gem 'safe_type'
```

# Use Cases
## Environment Variables
```ruby
require 'safe_type/mixin/hash' # symbolize_keys

ENV["DISABLE_TASKS"] = "true"
ENV["API_KEY"] = ""
ENV["BUILD_NUM"] = "123"
SAFE_ENV = SafeType::coerce(
  ENV,
  {
    "DISABLE_TASKS" => SafeType::Boolean.default(false),
    "API_KEY" => SafeType::String.default("SECRET"),
    "BUILD_NUM" => SafeType::Integer.strict,
  }
).symbolize_keys

SAFE_ENV[:DISABLE_TASKS]    # => true
SAFE_ENV[:API_KEY]          # => SECRET
SAFE_ENV[:BUILD_NUM]        # => 123
```
## Routing Parameters
```ruby
class FallSemesterStartDate < SafeType::Date
  # implement `is_valid?` method
end

current_year = Date.today.year
params = {
  "course_id" => "101",
  "start_date" => "#{current_year}-10-01"
}

rules = {
  "course_id" => SafeType::Integer.strict,
  "start_date" => FallSemester.strict
}

SafeType::coerce!(params, rules)

params["course_id"]       # => 101
params["start_date"]      # => <Date: 2018-10-01 ((2458393j,0s,0n),+0s,2299161j)>
```
## Ruby Hashes
```ruby
json = {
  "names" => ["Alice", "Bob", "Chris"],
  "info" => [
    {
      "type" => "dog",
      "age" => "5",
    },
    {
      "type" => "cat",
      "age" => "4",
    },
    {
      "type" => "fish",
      "age" => "6",
    }
  ]
}

SafeType::coerce!(json, {
  "names" => [SafeType::String.strict],
  "info" => [
    {
      "type" => SafeType::String.strict,
      "age" => SafeType::Integer.strict
    }
  ]
})
```
## Network Responses 
```ruby
class ResponseType; end

class Response < SafeType::Rule
  def initialize(type: ResponseType, default: "404")
    super
  end

  def before(uri)
    # make request
    return ResponseType.new 
  end
end

Response.coerce("https://API_URI")   # => #<ResponseType:0x000056005b3e7518>
```

# Overview 
A `Rule` describes a single transformation pipeline. It's the core of this gem.
```ruby
class Rule
  def initialize(type:, default: nil, required: false)
```
The parameters are
- the `type` to transform into
- the `default` value when the result is `nil`
- `required` indicates whether empty values are allowed

## `strict` vs `default`
The primitive types in `SafeType` provide `default` and `strict` mode, which are
- `SafeType::Boolean`
- `SafeType::Date`
- `SafeType::DateTime`
- `SafeType::Float`
- `SafeType::Integer`
- `SafeType::String`
- `SafeType::Symbol`
- `SafeType::Time`

Under the hood, they are all just `Rule` classes with parameters:
- `default`: a rule with default value specified
- `strict`: a rule with `required: true`, so no empty values are allowed, or it throws `EmptyValueError`

## Apply the Rules
As we've seen in the use cases, we can call `coerce` to apply a set of `SafeType::Rule` classes.
`Rule` classes can be bundled together as elements in an array or values in a hash.

### `coerce` vs `coerce!`
- `SafeType::coerce` returns a new object, corresponding to the rules. The unspecified fields will not be included in the new object.
- `SafeType::coerce!` coerces the object in place. The unspecified fields will not be modified.
Note `SafeType::coerce!` cannot be used on a simple object, otherwise it will raise `SafeType::InvalidRuleError`. 

To apply the rule on a simple object, we can call the `coerce` method as well.
```ruby
SafeType::Integer.default.coerce("1")    # => 1
SafeType::Integer.coerce("1")            # => 1
```
Note those two examples are equivalent:
```ruby
SafeType::coerce(ENV["PORT"], SafeType::Integer.default(3000))
SafeType::Integer.default(3000).coerce(ENV["PORT"])
``` 
For the `SafeType` primitive types, applying the rule on the class itself will use the default rule.

## Customized Types
We can inherit from a `SafeType::Rule` to create a customized type.
We can override following methods if needed:
- Override `initialize` to change the default values, types, or add more attributes.
- Override `before` to update the input before convert. This method should take the input and return it after processing.
- Override `is_valid?` to check the value after convert. This method should take the input and return `true` or `false`.
- Override `after` to update the input after validate. This method should take the input and return it after processing.
- Override `handle_exceptions` to change the behavior of exceptions handling (e.g: send to the logger, or no exception) 
- Override `default` or `strict` to modify the default and strict rule.

## Prior Art
`safe_type` pulls heavy inspiration from [dry-types](https://github.com/dry-rb/dry-types) and [rails_param](https://github.com/nicolasblanco/rails_param).
The interface in `safe_type` looks similar to the interface in `dry-types`, however, `safe_type` supports some additional features such as in-place coercion
using the Ruby bang method interface and the ability to define schemas using Ruby hashes and arrays. `safe_type` also borrows some concepts from `rails_param`, 
but with some fundamental differences such as `safe_type` not relying  on Rails and `safe_type` not having a focus on only typing Rails controller parameters.
The goal of `safe_type` is to provide a good tradeoff between complexity and flexibility by enabling type checking through a clean and easy-to-use interface.
`safe_type` should be useful when working with any string or hash where the values could be ambiguously typed, such as `ENV` variables, rails `params`, or network responses..

# License
The `safe_type` project is licensed and available open source under the terms of the [MIT license](http://opensource.org/licenses/MIT). 
