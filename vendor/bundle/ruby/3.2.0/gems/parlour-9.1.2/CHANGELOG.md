# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [9.1.2] - 2025-07-07
### Fixed
- Fixed a possible hang when getting a file list from Sorbet during type loading. (Thanks @apiology
  and @ojgarcia)

## [9.1.1] - 2025-05-28
### Fixed
- Replaced YARD `@abstract` directives, as they now conflict with Sorbet's `abstract!` directives
  when using Tapioca

## [9.1.0] - 2025-03-03
### Added
- Constants can now be generated or parsed with heredoc strings. (Thanks @apiology)

### Fixed
- `T.proc` types with no parameters are now emitted correctly. Previously, they emitted an invalid
  call to `params()` - now they emit no usage of `params`. (Thanks @apiology)

## [9.0.0] - 2024-06-04
### Changed
- Updated Commander dependency to 5.0, to remove `abbrev` deprecation warning. 
  **As a result, the minimum supported Ruby version is now 3.0.**

## [8.1.0] - 2023-01-01
### Added
- Parsed method definitions can now have a modifier before the `def` keyword.

### Fixed
- Use `File#exist?` instead of `File#exists?` in CLI, fixing an exception on
  Ruby 3.2.0.
- Resolved incorrect code generation for `T::Enum`s with only one variant.

## [8.0.0] - 2022-05-10
### Changed
- The parser now loads untyped methods named `initialize` as returning `void`, rather than
  `untyped`. Potentially breaking if you are relying on this behaviour, though Sorbet now considers
  this an error.

## [7.0.0] - 2022-04-18
### Added
- `#describe` now uses a new, clearer format.
- Added `#describe_tree`, which produces `#describe` output for a node and all
  of its children.
- Added `#find` and `#find_all` for retrieving a node's children based on
  criteria.

### Changed
- Parlour now uses the new block-based `type_member` syntax internally.
  **Potentially breaking** if you pin an older version of Sorbet which doesn't
  support this syntax!
- Improved error message when unable to retrieve the file table from Sorbet.
- `#inspect` and `#to_s` now call `#describe`.

## Fixed
- Fixed some incorrect YARD documentation tags.

## [6.0.1] - 2021-02-28
### Changed
- Disabled runtime type checking for `TypedObject#name`, resulting in a
  significant decrease in the time taken to run the conflict resolver.

## [6.0.0] - 2021-02-28
### Changed
- The RBI previously included with the Parlour gem has been removed,
  as it was causing issues with Sorbet. **If you were relying on Parlour's
  bundled RBI while type-checking your project, you will now need to use the
  RBI from sorbet-typed or the Parlour repo.**
- `Namespace#path` will now work much more reliably for classes and
  modules which replace methods from `Module` and `Class`, such as
  `#name`.

## [5.0.0] - 2020-12-26
### Added
- Added RBS generation support! This includes:
  - The new `RbsGenerator` class
  - `RbsObject` and a set of subclasses representing different RBS components
  - **Note:** RBS does not yet support Parlour plugins and some other features.
    Refer to the README for a full breakdown!
- Added the `Types` module, which is used to describe types agnostic of the
  underlying type system
  - Added `RbiGenerator::Namespace#generalize_from_rbi!` to convert RBI string
    types into `Types` types
  - **Specifying types as strings is still currently supported, but may be
    phased out in future, and should be avoided in new projects**.
- Added conversion from RBI to RBS type trees
- Added a couple of classes to deduplicate functionality between type systems:
  - `TypedObject`, which `RbiObject` and `RbsObject` both inherit from
  - `Generator`, which `RbiGenerator` and `RbsGenerator` both inherit from
- Added RBI type aliases
- Added `sealed!` for RBI namespaces
- Added `abstract!` for RBI modules

### Changed
- `Parlour::RbiGenerator::Options` is now `Parlour::Options`. An alias exists
  for now, but **`Parlour::RbiGenerator::Options` is deprecated** and could be
  removed in future versions.
- Updated README and gem metadata to refer to Parlour as a type information
  generator, rather than just an RBI generator

<details>
  <summary>5.0.0 pre-releases</summary>
  
  ## [5.0.0.beta.6] - 2020-10-04
  ### Fixed
  - Fixed collection types sometimes generating as `T::::Array`

  ## [5.0.0.beta.5] - 2020-10-03
  ### Added
  - Added `Types::Generic` for user-defined generic types

  ## [5.0.0.beta.4] - 2020-09-22
  ### Added
  - Added support for parsing type aliases from RBI
  - Added conversion from RBI to RBS type aliases

  ## [5.0.0.beta.3] - 2020-09-15
  ### Changed
  - Changed the RBS keyword warning to come from "RBS generation" rather than
    "Type generalization"
  - Added many more of RBS' keywords which are detected and prefixed with an
    underscore to avoid syntax errors

  ## [5.0.0.beta.2] - 2020-09-14
  ### Added
  - Added `Types::Type#describe` for simple text descriptions of types
  - Added `Types::Self` for RBI's `T.self_type` or RBS' `self`

  ### Fixed
  - Fixed `RbiGenerator::Namespace#create_method`'s `returns:` kwarg only
    accepting String types
  - Fixed lack of spacing between argument lists and blocks in RBS
  - Fixed RBS attributes not having comments

  ## [5.0.0.beta.1] - 2020-09-13
  ### Added
  - Added RBS generation support! This includes:
    - The new `RbsGenerator` class
    - `RbsObject` and a set of subclasses representing different RBS components
  - Added the `Types` module, which is used to describe types agnostic of the
    underlying type system
    - Added `RbiGenerator::Namespace#generalize_from_rbi!` to convert RBI string
      types into `Types` types
    - **Specifying types as strings is still currently supported, but may be
      phased out in future, and should be avoided in new projects**.
  - Added conversion from RBI to RBS type trees
  - Added a couple of classes to deduplicate functionality between type systems:
    - `TypedObject`, which `RbiObject` and `RbsObject` both inherit from
    - `Generator`, which `RbiGenerator` and `RbsGenerator` both inherit from
  - Added RBI type aliases

### Changed
- `Parlour::RbiGenerator::Options` is now `Parlour::Options`. An alias exists
  for now, but **`Parlour::RbiGenerator::Options` is deprecated** and could be
  removed in future versions.
- Updated README and gem metadata to refer to Parlour as a type information
  generator, rather than just an RBI generator
</details>

## [4.0.1] - 2020-08-05
### Fixed
- Fixed duplicate includes and extends.
- Fixed the block return type for `#resolve_conflicts` not being nilable.

## [4.0.0] - 2020-05-23
### Added
- Parlour now defaults to loading the current project when running its command
  line tool, allowing it to be used as a "`sig` extractor" when run without
  plugins! **Breaking if you invoke Parlour from its command line tool** - to
  revert to the old behaviour of having nothing loaded into the root namespace
  initially, add `parser: false` to your `.parlour` file.
- Generating constants in an eigenclass context (`class << self`) is now
  supported.

## [3.0.0] - 2020-05-15
### Added
- `T::Struct` classes can now be generated and parsed.
- `T::Enum` classes can now be parsed.
- Constants are now parsed.
- `TypeParser` now detects and parses methods which do not have a `sig`.
  **Potentially breaking if there is a strict set of methods you are expecting Parlour to detect.**

### Fixed
- "Specialized" classes, such as enums and now structs, have had many erroneous
  conflicts with standard classes or namespaces fixed.
- Attributes writers and methods with the same name no longer conflict incorrectly.

## [2.1.0] - 2020-03-22
### Added
- Files can now be excluded from the `TypeLoader`.

### Changed
- A block argument in the definition but not in the signature no longer causes
an error in the `TypeParser`.
- Sorting of namespace children is now a stable sort.

### Fixed
- Type parameters are now parsed by the `TypeParser`.

## [2.0.0] - 2020-02-10
### Added
- Parlour can now load types back out of RBI files or Ruby source files by
parsing them, using the `TypeLoader` module.
- The `sort_namespaces` option has been added to `RbiGenerator` to
alphabetically sort all namespace children.
- Added `DetachedRbiGenerator`, which can be used to create instances of 
`RbiObject` which are not bound to a particular set of options. This is
used internally for `TypeLoader`.
- Parlour will now create a polyfill for `then` on `Kernel`.
- Added `NodePath#sibling`.

### Changed
- Version restrictions on _rainbow_ and _commander_ have been slightly relaxed.
- The version of _sorbet-runtime_ is now restricted to `>= 0.5` after previously
being unrestricted.
- Instances of `Namespace` can now be merged with instances of `ClassNamespace`
or `MethodNamespace`.
- A method and a namespace can now have the same name without causing a merge
conflict.

### Fixed
- Parameter names are no longer nilable.
**Potentially breaking if you were doing something cursed with Parameter names.**

## [1.0.0] - 2019-11-22
### Added
- `T::Enum` classes have been implemented, and can be generated using
`#create_enum_class`.
- Methods and namespaces can now be made final using the `final:` keyword
argument.
- Type aliases can be created on namespaces using `#create_type_alias`.
- The `.parlour` file can now have globs in `relative_requires` to load many
files matching a pattern at once.

### Fixed
- Commander is now a gemspec dependency.

## [0.8.1] - 2019-09-27
### Added
- Running with the PARLOUR_DEBUG environment variable set will now print debug
output to the console during conflict resolution.

### Fixed
- Performance is now much faster when the conflict resolver needs to resolve a
conflict between many identical objects.

## [0.8.0] - 2019-09-14
### Added
- Methods can now have type parameters specified.

### Changed
- **Breaking change: The `implementation` qualifier is no longer genereated.**
Following Sorbet merging `implementation` and `override` into just `override`,
the `Method#implementation` and `Method#override` flags will now both generate 
the `override` qualifier.
- The Parlour codebase now uses `override` for both abstract implementation and
superclass overriding to conform to this change.

## [0.7.0] - 2019-09-11
### Added
- The strictness level can now be specified when generating an RBI, using an
optional positional argument to `RBIGenerator#generate`. The default strictness
is `strong`.
- Plugins can specify a strictness level they would prefer by setting
`Plugin#strictness` for themselves. If multiple plugins set conflicting 
strictnesses, the least strict will be used.
- Attributes can now specified as class attributes by setting
`Attribute#class_attribute` to `true`. This will wrap them in a `class << self`
block.

### Changed
- The `sorbet` directory is no longer included in the built gem.
- Generated files now end with a new line (`\n`).

### Fixed
- An instance method and a class method with the same name are no longer
considered conflicting.
- The signature for the constructor of `Attribute` previously typed the optional
initializer block as taking a `Method`. This has been corrected to taking an
`Attribute`.

## [0.6.1] - 2019-07-29
### Changed
- Various areas of the codebase have been made compatible with older Ruby
versions.

## [0.6.0] - 2019-07-25
### Changed
- **Breaking change: the `name: ` keyword argument is now positional instead.**
Instead of `create_method(name: 'A', returns: 'String')`, use
`create_method('A', returns: 'String')`.
- Altered some syntax to improve compatibility with previous Ruby versions.
(Full compatibility is still WIP.)

### Fixed
- Fixed some Sorbet type signatures.
- Fixed an RSpec warning.

## [0.5.2] - 2019-07-24
### Added
- Added the `Namespace#create_includes` and `Namespace#create_extends` methods
to add multiple `include` and `extend` calls at once.

### Changed
- Signatures for some methods using keyword parameters have been altered such
that those keywords are required. Previously, these parameters defaulted to
`nil`, and the Sorbet runtime would fail an assertion if they weren't present.

### Fixed
- Fixed some incorrect documentation for the `Namespace` methods `path` and
`create_constant`.
- Fixed a Sorbet signature for `Method#describe` which was causing an exception.

## [0.5.1] - 2019-07-21
### Added
- Added the `Namespace#path` method for plugins to use.

## [0.5.0] - 2019-07-20
### Added
- Added the `create_arbitrary` method for inserting arbitrary code into the
generated RBI file. This is intended for using constructs which Parlour does
not yet support.

### Changed
- Breaking change: `add_constant`, `add_include` and `add_extend` have been
replaced with `create_constant`, `create_include` and `create_extend`.

## [0.4.0] - 2019-07-10
### Changed
- Breaking change: The Parlour CLI tool no longer takes command-line arguments, and instead uses a `.parlour` configuration file. See the README!
- RBIs now begin with `# typed: strong`.
- Plugins now define a stub constructor to avoid an exception if they don't define one.

## [0.3.1] - 2019-07-09
### Changed
- Multi-line parameter lists no longer have a trailing comma.

## [0.3.0] - 2019-07-09
### Changed
- Breaking change: all `Namespace#create_` methods, and the `Parameter` constructor, now take entirely keyword arguments.
  For example, `create_method('A', [], 'String')` is now written as `create_method(name: 'A', returns: 'String')`.

## [0.2.2] - 2019-07-08
### Fixed
- Fixed a bug which occasionally caused includes and extends to generate incorrectly.

## [0.2.1] - 2019-07-08
### Added
- Added the `add_comment_to_next_child` method to namespaces.

## [0.2.0] - 2019-07-07
### Added
- Add support for plugins using the `parlour` command-line tool.
- Comments can now be added using `add_comment`.
- Attribute readers, writers and accessors can now be created, using the `create_attr_...` methods.
- All objects are now YARD documented.

### Changed
- The `RbiObject`, which is core to Parlour's internals, is now an abstract class rather than an interface.
- `ConflictResolver` now recurses to child namespaces.
- `create_method` now takes an initializer block like other `create_` methods.

## [0.1.1] - 2019-07-05
### Added
- Initial release!

_(0.1.0 was a blank gem.)_