# Parlour

[![Build Status](https://travis-ci.org/AaronC81/parlour.svg?branch=master)](https://travis-ci.org/AaronC81/parlour)
![Gem](https://img.shields.io/gem/v/parlour.svg)

Parlour is a Ruby type information generator, merger and parser, supporting both
**Sorbet RBI files and Ruby 3/Steep RBS files**. It consists of three key parts:

  - The generator, which outputs beautifully formatted RBI/RBS files, created 
    using an intuitive DSL.

  - The plugin/build system, which allows multiple Parlour plugins to generate
    RBIs for the same codebase. These are combined automatically as much as
    possible, but any other conflicts can be resolved manually through prompts.

  - The parser (currently RBI-only), which can read an RBI and convert it back
    into a tree of generator objects.

## Why should I use this?

  - Parlour enables **much easier creation of RBI/RBS generators**, as
    formatting is all handled for you, and you don't need to write your own CLI.

  - You can **use many plugins together seamlessly**, running them all with a
    single command and consolidating all of their definitions into a single
    output file.

  - You can **effortlessly build tools which need to access types within an RBI**;
    no need to write your own parser!

  - You can **generate RBI/RBS to ship with your gem** for consuming projects to
    use ([see "RBIs within gems" in Sorbet's
    docs](https://sorbet.org/docs/rbi#rbis-within-gems)).

Please [**read the wiki**](https://github.com/AaronC81/parlour/wiki) to get
started!

## Feature Support

| Feature | RBI | RBS |
|---------|-----|-----|
| **GENERATION** |  |  |
| Classes | ✅ | ⚠️ (missing `extension`) |
| Modules | ✅ | ⚠️ (missing `extension`) |
| Interfaces | ✅ | ✅ |
| Attributes | ✅ | ✅ |
| Methods | ✅ | ✅ |
| Overloaded methods | ❌* | ✅ |
| Structs | ✅ | ✅† |
| Enums | ✅ | ✅† |
| Generation with plugins | ✅ | ❌ |
| **MANIPULATION** |  |  |
| Parsing | ✅ | ❌ |
| Merging | ✅ | ❌ |

- ✅ - Well supported
- ⚠️ - Some missing features
- ❌ - Not currently supported

- \* Only supported in stdlib types anyway
- † Not natively supported; available as a one-way conversion from RBI

## Creating Type Information

Each file format has its own type information generator class, so there are two
different generators you can use: `RbiGenerator` and `RbsGenerator`. Both
generators are similar to use, however they provide different object types and
parameters to match the functionality of their underlying type systems.

You can also convert your type information between formats; see
[converting between formats](#converting-between-formats).

### Using Just the Generator

Here's a quick example of how you can generate some type information. Here
we'll generate an RBI using the `RbiGenerator` classes:

```ruby
require 'parlour'

generator = Parlour::RbiGenerator.new
generator.root.create_module('A') do |a|
  a.create_class('Foo') do |foo|
    foo.create_method('add_two_integers', parameters: [
      Parlour::RbiGenerator::Parameter.new('a', type: 'Integer'),
      Parlour::RbiGenerator::Parameter.new('b', type: 'Integer')
    ], return_type: 'Integer')
  end

  a.create_class('Bar', superclass: 'Foo')
end

generator.rbi # => Our RBI as a string
```

This will generate the following RBI:

```ruby
module A
  class Foo
    sig { params(a: Integer, b: Integer).returns(Integer) }
    def add_two_integers(a, b); end
  end

  class Bar < Foo
  end
end
```

Using the RBS generator looks similar, but has an intermediary 
`MethodSignature` class to support RBS' method overloading:

```ruby
require 'parlour'

generator = Parlour::RbsGenerator.new
generator.root.create_module('A') do |a|
  a.create_class('Foo') do |foo|
    foo.create_method('add_two_integers', [
      Parlour::RbsGenerator::MethodSignature.new(
        [
          Parlour::RbsGenerator::Parameter.new('a', type: 'Integer'),
          Parlour::RbsGenerator::Parameter.new('b', type: 'Integer')
        ],
        'Integer'
      )
    ])
  end

  a.create_class('Bar', superclass: 'Foo')
end

generator.rbs # => Our RBS as a string
```

This generates an equivalent RBS file:

```ruby
module A
  class Foo
    def add_two_integers: (Integer a, Integer b) -> Integer
  end

  class Bar < Foo
  end
end
```

### Writing a Plugin
Plugins are better than using the generator alone, as your plugin can be
combined with others to produce larger files without conflicts.

We could write the above example as an RBI plugin like this:

```ruby
require 'parlour'

class MyPlugin < Parlour::Plugin
  def generate(root)
    root.create_module('A') do |a|
      a.create_class('Foo') do |foo|
        foo.create_method('add_two_integers', parameters: [
          Parlour::RbiGenerator::Parameter.new('a', type: 'Integer'),
          Parlour::RbiGenerator::Parameter.new('b', type: 'Integer')
        ], return_type: 'Integer')
      end

      a.create_class('Bar', superclass: 'Foo')
    end
  end
end
```

(Obviously, your plugin will probably examine a codebase somehow, to be more
useful!)

You can then run several plugins, combining their output and saving it into one
RBI file, using the command-line tool. The command line tool is configurated
using a `.parlour` YAML file. For example, if that code was in a file
called `plugin.rb`, then using this `.parlour` file and then running `parlour`
would save the RBI into `output.rbi`:

```yaml
output_file:
  rbi: output.rbi

relative_requires:
  - plugin.rb
  - app/models/*.rb

plugins:
  MyPlugin: {}
```

The `{}` indicates that this plugin needs no extra configuration. If it did need
configuration, this could be specified like so:

```yaml
plugins:
  MyPlugin:
    foo: something
    bar: something else
```

You can also use plugins from gems. If that plugin was published as a gem called
`parlour-gem`:

```yaml
output_file:
  rbi: output.rbi

requires:
  - parlour-gem

plugins:
  MyPlugin: {}
```

The real power of this is the ability to use many plugins at once:

```yaml
output_file:
  rbi: output.rbi

requires:
  - gem1
  - gem2
  - gem3

plugins:
  Gem1::Plugin: {}
  Gem2::Plugin: {}
  Gem3::Plugin: {}
```

Currently, only plugins which generate RBI files are supported. However, you can
use [Parlour's type conversion](#converting-between-formats) to convert the RBI
types into RBS types:

```yaml
output_file:
  rbi: output.rbi
  rbs: output.rbs
```

## Using Types

The most important part of your type information is the types themselves, which
you'll be specifying for method parameters, method returns, and attributes. 
These include simple types like `String`, up to more complex types like
"an array of elements which are one of `Integer`, `String`, or nil".

There are two ways to represent these types in Parlour:

1. As **generalized types**; that is, instances of classes in the
   `Parlour::Types` namespace. This is the **recommended way**, as it is
   format-agnostic and can be compiled to RBI or RBS. For more information
   about these types and how to use them, see
   [this wiki page](https://github.com/AaronC81/parlour/wiki/The-Types-namespace).

2. As **strings of code** written in the format that your type system expects.
   The given strings are directly inserted into the final type file. These types
   are **not portable across formats**, and as such are
   **not recommended and may be phased out** in the future.

Currently most type values within Parlour are typed as `Types::TypeLike`,
which accepts a `String` or a `Types::Type` subclass.

```ruby
include Parlour

# Two ways to express an attribute called 'example', which is:
#   an array of nilable strings or integers

# 1. With generalised types - type is agnostic to the underlying type system
root.create_attr_accessor('example', type:
  Types::Array.new(
    Types::Nilable.new(
      Types::Union.new(['String', 'Integer'])
    )
  )
)

# 2. With string types - format depends on type system
#    If using RBI...
root.create_attr_accessor('example', type:
  'T::Array[T.nilable(T.any(String, Integer))]'
)
#    If using RBS...
root.create_attr_accessor('example', type:
  'Array[?(String | Integer)]'
)
```

### Generalizing String Types

If you have loaded an RBI project or created a structure of nodes on an
`RbiGenerator`, you can use `#generalize_from_rbi!` on your root namespace
to attempt to permanently convert the RBI string types into generalized types:

```ruby
# Build up an RBI tree with string types
root.create_attr_accessor('example', type:
  'T::Array[T.nilable(T.any(String, Integer))]'
)

# Generalize it
root.generalize_from_rbi!

# Take a look at our generalized type!
pp root.children.first.type
# => #<Parlour::Types::Array:0x0000557cdcebfdf8
#     @element=
#      #<Parlour::Types::Nilable:0x0000557cdcef8c70
#       @type=
#        #<Parlour::Types::Union:0x0000557cdcea0a70
#         @types=
#          [#<Parlour::Types::Raw:0x0000557cdcea1920 @str="String">,
#           #<Parlour::Types::Raw:0x0000557cdcea0ae8 @str="Integer">]>>>
```

## Parsing RBIs

You can either parse individual RBI files, or point Parlour to the root of a
project and it will locate, parse and merge all RBI files.

Note that Parlour isn't limited to just RBIs; it can parse inline `sigs` out
of your Ruby source too!

```ruby
require 'parlour'

# Return the object tree of a particular file
Parlour::TypeLoader.load_file('path/to/your/file.rbis')

# Return the object tree for an entire Sorbet project - slow but thorough!
Parlour::TypeLoader.load_project('root/of/the/project')
```

The structure of the returned object trees is identical to those you would
create when generating an RBI, built of instances of `RbiObject` subclasses.

## Generating RBI for a Gem

Include `parlour` as a development_dependency in your `.gemspec`:

```ruby
spec.add_development_dependency 'parlour'
```

Run Parlour from the command line:

```ruby
bundle exec parlour
```

Parlour is configured to use sane defaults assuming a standard gem structure
to generate an RBI that Sorbet will automatically find when your gem is included
as a dependency. If you require more advanced configuration you can add a
`.parlour` YAML file in the root of your project (see this project's `.parlour`
file as an example).

To disable the parsing step entire and just run plugins you can set `parser: false`
in your `.parlour` file.

## Converting Between Formats

_For more information, see the [wiki page](https://github.com/AaronC81/parlour/wiki/Converting-between-RBI-and-RBS)._

Currently, only RBI to RBS conversion is supported, and if you've used string
types (or are using a freshly-loaded project) you
**must [generalize them](#generalizing-string-types) first**.

Then, all you need to do is create an `RbsGenerator` (which the converter will
add your converted types to) and a `Conversion::RbiToRbs` instance (which 
performs the conversion). Then you can convert each object at your
`RbiGenerator`'s root namespace:

```ruby
rbi_gen = Parlour::RbiGenerator.new
# Then, after populating the RbiGenerator with types...

# Create an RbsGenerator and a converter
rbs_gen = Parlour::RbsGenerator.new
converter = Parlour::Conversion::RbiToRbs.new(rbs_gen)

# Convert each item at the root of the RbiGenerator and it to the root of the RbsGenerator
converter.convert_all(rbi_gen.root, rbs_gen.root)
```

## Parlour Plugins

_Have you written an awesome Parlour plugin? Please submit a PR to add it to this list!_

  - [Sord](https://github.com/AaronC81/sord) - Generate RBIs from YARD documentation
  - [parlour-datamapper](https://github.com/AaronC81/parlour-datamapper) - Simple plugin for generating DataMapper model types
  - [sorbet-rails](https://github.com/chanzuckerberg/sorbet-rails) - Generate RBIs for Rails models, routes, mailers, etc.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/AaronC81/parlour. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

After making changes, you may wish to regenerate the RBI definitions in the `sorbet` folder by running these `srb rbi` commands:

```
srb rbi gems
srb rbi sorbet-typed
```

You should also regenerate the parlour.rbi file by running `bundle exec parlour`. Don't edit this file manually, as your changes will be overwritten!

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Parlour project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/AaronC81/parlour/blob/master/CODE_OF_CONDUCT.md).
