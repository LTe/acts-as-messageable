## Contributing

There are many ways to contribute. You can [file a bug], improve the
[documentation], or submit [new code](#code). Finding all the changes
for any given Ruby version can be difficult. If something is missing
please add it to the documentation.

### Code

A list of changes can be found at:

 * https://raw.githubusercontent.com/ruby/ruby/v2_6_0/NEWS
 * https://raw.githubusercontent.com/ruby/ruby/v2_5_0/NEWS
 * https://raw.githubusercontent.com/ruby/ruby/v2_4_2/NEWS
 * https://raw.githubusercontent.com/ruby/ruby/v2_3_4/NEWS
 * https://raw.githubusercontent.com/ruby/ruby/v2_2_7/NEWS

Specific changes can be found by going to the [Ruby bug/feature tracker].

These are the steps that you'll need to follow for submitting code:

1. [Fork](#fork)
2. [Tests](#tests)
3. [Lib](#lib)
4. [Push and Submit](#push-and-submit)
5. [Refine Until Merged](#refine-until-merged)

#### Fork

[Fork] the repo.

#### Tests

The goal is to produce code that is identical to the real method. To
ensure that nothing breaks and the new code is good we need tests! One
of the best places to find examples is the [Ruby Spec Suite]. If they
have tests for the new functionality then make sure those same cases
are covered.

If this is a change that adds to an existing feature make sure to have
a basic test of the old functionality and then test all of the new
functionality. These tests are typically grouped into two contexts.

```ruby
RSpec.describe 'Obj#method' do
  context 'existing behavior' do
    # smoke test or two here
  end
  
  context '2.4' do
    # changes added in 2.4
  end
end
```

Also make sure that your code passes rubocop. You can run
`bundle exec rake` to execute the tests and run rubocop. If there's
a good reason to violate rubocop (e.g. an optimization) then please
bring it up and we'll figure it out.

#### Lib

Instance methods can be added or updated directly in a module of the
same name. All class methods will be in a nested module named
`ClassMethods`. The class methods should be instance methods within
that module.

```ruby
module Polyfill
  module V2_4
    module Array
      module ClassMethods
        def example_class_method
          # ...
        end
      end
      
      def example_instance_method
        # ...
      end
    end
  end
end
```

Reusing the names of core classes means that in your methods you'll
need to make sure you reference the top level class by preceding it
with `::` (e.g. `::File`). This can be a frustrating mistake so be
mindful.

Partial implementations of features are welcome as long as they
bring value. Generally it's only ok to leave out part of the feature
when that part is very hard and/or secondary to the primary 
functionality. What constitutes "value", "hard", and what gets
accepted may seem a bit arbitrary. If you're unsure, please reach out
and we'll discuss. I'd hate to see a bunch of work done only to get
rejected.

#### Push and Submit

Push your branch up to your fork. Submit a pull request via
GitHub.

#### Refine Until Merged

There are weird edge cases and particulars that might need to be
changed. Don't worry if you get a lot of comments on your pull
request. That's why we have code reviews. People miss things and more
eyes catch more issues. After everything is fixed: VICTORY!

[file a bug]: https://github.com/AaronLasseigne/polyfill/issues/new
[documentation]: README.md
[Fork]: https://github.com/AaronLasseigne/polyfill/fork
[Ruby Spec Suite]: https://github.com/ruby/spec
[Ruby bug/feature tracker]: https://bugs.ruby-lang.org
