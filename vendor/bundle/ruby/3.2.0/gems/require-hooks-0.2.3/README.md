[![Gem Version](https://badge.fury.io/rb/require-hooks.svg)](https://rubygems.org/gems/require-hooks)
[![Build](https://github.com/ruby-next/require-hooks/workflows/Build/badge.svg)](https://github.com/palkan/require-hooks/actions)
[![JRuby Build](https://github.com/ruby-next/require-hooks/workflows/JRuby%20Build/badge.svg)](https://github.com/ruby-next/require-hooks/actions)
[![TruffleRuby Build](https://github.com/ruby-next/require-hooks/workflows/TruffleRuby%20Build/badge.svg)](https://github.com/ruby-next/require-hooks/actions)

# Require Hooks

Require Hooks is a library providing universal interface for injecting custom code into the Ruby's loading mechanism. It works on MRI, JRuby, and TruffleRuby.

Require hooks allows you to interfere with `Kernel#require` (incl. `Kernel#require_relative`) and `Kernel#load`.

<a href="https://evilmartians.com/">
<img src="https://evilmartians.com/badges/sponsored-by-evil-martians.svg" alt="Sponsored by Evil Martians" width="236" height="54"></a>

## Examples

- [Ruby Next][ruby-next]
- [Freezolite](https://github.com/ruby-next/freezolite)
- [Tapioca](https://github.com/Shopify/tapioca)

## Installation

Add to your Gemfile:

```ruby
gem "require-hooks"
```

or gemspec:

```ruby
spec.add_dependency "require-hooks"
```

## Usage

To enable hooks, you need to load `require-hooks/setup` before any code that you want to pre-process via hooks:

```ruby
require "require-hooks/setup"
```

For example, in an application (e.g., Rails), you may want to only process the source files you own, so you must activate Require Hooks after loading the dependencies (e.g., in the `config/application.rb` file right after `Bundler.require(*)`).

If you want to pre-process all files, you can activate Require Hooks earlier.

Then, you can add hooks:

- **around_load:** a hook that wraps code loading operation. Useful for logging and debugging purposes.

```ruby
# Simple logging
RequireHooks.around_load(patterns: ["/gem/dir/*.rb"]) do |path, &block|
  puts "Loading #{path}"
  block.call.tap { puts "Loaded #{path}" }
end

# Error enrichment.
# No patterns — all files are affected.
RequireHooks.around_load do |path, &block|
  block.call
rescue SyntaxError => e
  raise "Oops, your Ruby is not Ruby: #{e.message}"
end
```

The return value MUST be a result of calling the passed block.

- **source_transform:** perform source-to-source transformations.

```ruby
RequireHooks.source_transform(patterns: ["/my_project/*.rb"], exclude_patterns: ["/my_project/vendor/*"]) do |path, source|
  source ||= File.read(path)
  "# frozen_string_literal: true\n#{source}"
end
```

The return value MUST be either String (new source code) or `nil` (indicating that no transformations were performed). The second argument (`source`) MAY be `nil``, indicating that no transformer tried to transform the source code.

- **hijack_load:** a hook that is used to manually compile byte code for VM to load it.

```ruby
# Pattern can be a Proc. If it returns `true`, the hijacker is used.
RequireHooks.hijack_load(patterns: ["/my_project/*.rb"]) do |path, source|
  source ||= File.read(path)
  if defined?(RubyVM::InstructionSequence)
    RubyVM::InstructionSequence.compile(source)
  elsif defined?(JRUBY_VERSION)
    JRuby.compile(source)
  end
end
```

The return value is platform-specific. If there are multiple _hijackers_, the first one that returns a non-`nil` value is used, others are ignored.

**NOTE:** The `patterns` and `exclude_patterns` arguments accept globs as recognized by [File.fnmatch](https://rubyapi.org/3.2/o/file#method-c-fnmatch).

## Modes

Depending on the runtime conditions, Require Hooks picks an optimal strategy for injecting the code. You can enforce a particular _mode_ by setting the `REQUIRE_HOOKS_MODE` env variable (`patch`, `load_iseq` or `bootsnap`). In practice, only setting to `patch` may makes sense.

### Via `#load_iseq`

If `RubyVM::InstructionSequence` is available, we use more robust way of hijacking code loading—`RubyVM::InstructionSequence#load_iseq`.

Keep in mind that if there is already a `#load_iseq` callback defined, it will only have an effect if Require Hooks hijackers return `nil`.

### Kernel patching

In this mode, Require Hooks monkey-patches `Kernel#require` and friends. This mode is used in JRuby by default.

### Bootsnap integration

[Bootsnap][] is a great tool to speed-up your application load and it's included into the default Rails Gemfile. And it uses `#load_iseq`. Require Hooks activates a custom Bootsnap-compatible mode, so you can benefit from both tools.

You can use require-hooks with Bootsnap to customize code loading. Just make sure you load `require-hooks/setup` after setting up Bootsnap, for example:

```ruby
require "bootsnap/setup"
require "require-hooks/setup"
```

The _around load_ hooks are executed for all files independently of whether they are cached or not. Source transformation and hijacking is only done for non-cached files.

Thus, if you introduce new source transformers or hijackers, you must invalidate the cache. (We plan to implement automatic invalidation in future versions.)

## Limitations

- `Kernel#load` with a wrap argument (e.g., `load "some_path", true` or `load "some_path", MyModule)`) is not supported (fallbacked to the original implementation). The biggest challenge here is to support constants nesting.
- Some very edgy symlinking scenarios are not supported (unlikely to affect real-world projects).

## Performance

We conducted a benchmark to measure the performance overhead of Require Hooks using a large Rails project with the following characteristics:

```sh
$ find config/ lib/ app/ -name "*.rb" | wc -l

2689
```

```sh
$ bundle list | wc -l

427
```

Total number of `#require` calls: **12741**.

We activated Require Hooks in the very start of the program (`config/boot.rb`).

There is a single around load hook to count all the calls:

```ruby
counter = 0
RequireHooks.around_load do |_, &block|
  counter += 1
  block.call
end

at_exit { puts "Total hooked calls: #{counter}" }
```

## Results

All tests made with `eager_load=true`.

Test script: `time bundle exec rails runner 'puts "done"'`.

|                                     |              |
|-------------------------------------|--------------|
| baseline                            |    29s       |
| baseline w/bootsnap                 |    12s       |
| rhooks (iseq)                       |    30s       |
| rhooks (patch)                      |    **8m**    |
| rhooks (bootsnap)                   |    12s       |

You can see that requiring tons of files with Require Hooks in patch mode is very slow for now. Why? Mostly because we MUST check `$LOADED_FEATURES` for the presence of the file we want to load and currently we do this via `$LOADED_FEATURES.include?(path)` call, which becomes very slow when `$LOADED_FEATURES` is huge. Thus, we recommend activating Require Hooks after loading all the dependencies and limiting the scope of affected files (via the `patterns` option) on non-MRI platforms to avoid this overhead.

**NOTE:** Why Ruby's internal implementations is fast despite from doing the same checks? It uses an internal hash table to keep track of the loaded features (`vm->loaded_features_realpaths`), not an array. Unfortunately, it's not accessible from Ruby.

Here are the numbers for the same project with scoped hooks (only some folders) activated after `Bundler.require(*)`:

- 732 files affected: 2m36s (vs. 30s w/o hooks)
- 153 files affected: 55s (vs. 30s w/o hooks)

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/ruby-next/require-hooks](https://github.com/ruby-next/require-hooks).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

[Bootsnap]: https://github.com/Shopify/bootsnap
[ruby-next]: https://github.com/ruby-next/ruby-next
