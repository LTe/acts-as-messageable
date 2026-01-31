# [1.9.0][] (2020-12-12)

## Added

- Added support for repeatable srb runs from the sorbet gem.

# [1.8.0][] (2019-09-02)

## Added

- v2.6 Kernel#Complex
- v2.6 Kernel#Float
- v2.6 Kernel#Integer
- v2.6 Kernel#Rational
- v2.6 Array#to_h
- v2.6 Hash#to_h
- v2.6 Enumerable#to_h
- v2.6 OpenStruct#to_h
- v2.6 Struct#to_h

# [1.7.0][] (2019-02-17)

## Added

- v2.6 Array#difference
- v2.6 Array#union
- v2.6 Hash#merge!
- v2.6 Hash#update
- v2.6 String#split

# [1.6.0][] (2019-02-01)

## Added

- v2.6 Hash#merge
- v2.5 Kernel#then

# [1.5.0][] (2018-12-30)

## Added

- v2.5 Array#append
- v2.5 Array#prepend
- v2.5 Set#===
- v2.5 Set#to_s

# [1.4.0][] (2018-09-09)

## Added

- v2.5 String#each_grapheme_cluster
- v2.5 String#grapheme_clusters
- v2.5 Struct.new

# [1.3.0][] (2018-03-20)

## Added

- v2.5 Enumerable#all?
- v2.5 Enumerable#any?
- v2.5 Enumerable#none?
- v2.5 Enumerable#one?
- v2.3 Array#bsearch_index
- v2.3 Hash#<
- v2.3 Hash#<=
- v2.3 Hash#>
- v2.3 Hash#>=

# [1.2.0][] (2018-03-05)

## Added

- v2.5 BigDecimal#clone
- v2.5 BigDecimal#dup
- v2.5 Dir.children
- v2.5 Dir.each_child
- v2.5 Integer.sqrt
- v2.5 Time.at
- v2.3 Prime.prime?
- v2.2 Math.log
- v2.2 Prime.prime?

# [1.1.0][] (2018-02-23)

## Added

 - The verison now uses Gem::Version for easier comparisons
 - v2.5 Integer#allbits?
 - v2.5 Integer#anybits?
 - v2.5 Integer#ceil
 - v2.5 Integer#floor
 - v2.5 Integer#nobits?
 - v2.5 Integer#round
 - v2.5 Integer#truncate
 - v2.5 Hash#slice
 - v2.5 Hash#transform_keys
 - v2.5 Kernel#yield_self
 - v2.5 String#casecmp
 - v2.5 String#casecmp?
 - v2.5 String#delete_prefix
 - v2.5 String#delete_prefix!
 - v2.5 String#delete_suffix
 - v2.5 String#delete_suffix!
 - v2.5 String#start_with?

## Fixed

The following threw a `NoMethodError` instead of a `TypeError` when an
incorrect type was passed:

 - v2.4 Float#ceil
 - v2.4 Float#floor
 - v2.4 Float#truncate
 - v2.4 Integer#ceil
 - v2.4 Integer#digits
 - v2.4 Integer#floor
 - v2.4 Integer#round
 - v2.4 Integer#truncate
 - v2.4 String#casecmp?

# [1.0.1][] (2017-06-03)

## Fixed

 - v2.3 String.new attempted to convert the encoded string instead of forcing
   the encoding.

# [1.0.0][] (2017-05-15)

 - Bumped to show stablization of the API

# [0.10.0][] (2017-05-15)

## Added

 - v2.3 Numeric#negative?
 - v2.3 Numeric#positive?

# [0.9.0][] (2017-05-05)

## Added

 - v2.2 Enumerable#max
 - v2.2 Enumerable#max_by
 - v2.2 Enumerable#min
 - v2.2 Enumerable#min_by
 - v2.2 Vector#@+
 - Polyfill.get can now be used with `prepend`

## Fixed

 - Enumerable should add to Matrix and Vector as well

# [0.8.0][] (2017-04-27)

## Changed

 - `Polyfill()` is no longer used with `include` or `extend`. Instead `Polyfill.get` should
   be used.

## Added

 - Polyfill.get for getting modules to include or extend
 - v2.2 Enumerable#slice_when

## Fixed

 - v2.3 Enumerable#chunk_while and v2.2 Enumerable#slice_after should not require `count`
 - v2.4 Array#sum should not use `each` (the Enumerable version does)
 - load modules before classes so they don't override the local method

# [0.7.0][] (2017-04-22)

## Changed

 - Sending no parameters to `Polyfill()` now returns nothing instead of everything.

## Added

 - Support for Ruby 2.1
 - v2.2 Enumerable#slice_after
 - v2.2 Kernel#itself
 - v2.3 Kernel#loop

# [0.6.0][] (2017-04-06)

## Fix

 - You can now use the `:version` option with no other specification

## Added

 - v2.3 Array#dig
 - v2.3 Enumerable#grep_v
 - v2.3 Enumerable#slice_before
 - v2.3 Enumerator::Lazy#grep_v
 - v2.3 Hash#dig
 - v2.3 Hash#fetch_values
 - v2.3 Hash#to_proc
 - v2.3 String#+@
 - v2.3 String#-@
 - v2.3 Struct#dig

# [0.5.0][] (2017-03-26)

## Added

 - Support for Ruby 2.2
 - `:version` option to limit the max acceptable version for changes
 - v2.3 String.new
 - v2.3 Enumerable#chunk_while

# [0.4.0][] (2017-03-24)

## Added

 - v2.4 Array#sum
 - v2.4 Enumerable#chunk
 - v2.4 Enumerable#sum
 - v2.4 Enumerable#uniq
 - v2.4 Enumerator::Lazy#chunk_while
 - v2.4 Enumerator::Lazy#uniq
 - v2.4 IO#lines
 - v2.4 IPAddr#==
 - v2.4 IPAddr#<=>
 - v2.4 Numeric#clone
 - v2.4 Numeric#dup
 - v2.4 Object#clone
 - v2.4 Pathname#empty?
 - v2.4 Regexp#match?
 - v2.4 String#casecmp?
 - v2.4 String#each_line
 - v2.4 String#lines
 - v2.4 String#match?
 - v2.4 String.new
 - v2.4 String#unpack1
 - v2.4 Symbol#casecmp?
 - v2.4 Symbol#match
 - v2.4 Symbol#match?

# [0.3.0][] (2017-03-19)

## Changed

 - New way to select methods that doesn't rely on knowing the module structure

## Added

 - v2.4 Dir.empty?
 - v2.4 File.empty?
 - v2.4 IO#each_line
 - v2.4 IO.foreach
 - v2.4 IO#gets
 - v2.4 IO#readline
 - v2.4 IO#readlines
 - v2.4 IO.readlines
 - v2.4 StringIO#each_line
 - v2.4 StringIO#gets
 - v2.4 StringIO#readline
 - v2.4 StringIO#readlines

# [0.2.0][] (2017-03-17)

## Changed

 - Modules are camel case instead of only uppercasing the first letter of the method name.
 - Modules for predicate methods now end with `Q` instead of `__Q`.
 - Modules for dangerous methods now end with `E` instead of `__E`.
 - Methods will no longer attempt to fix `#respond_to?`, `#methods`, or `.instance_methods`. This will be revisited later with a more comprehensive solution.

## Added

 - v2.4 MatchData#named_captures
 - v2.4 MatchData#values_at
 - v2.4 Hash#compact
 - v2.4 Hash#compact!
 - v2.4 Hash#transform_values
 - v2.4 Hash#transform_values!

# [0.1.0][] (2017-03-14)

 - v2.4 Array#concat
 - v2.4 Comparable#clamp
 - v2.4 Float#ceil
 - v2.4 Float#floor
 - v2.4 Float#truncate
 - v2.4 Integer#ceil
 - v2.4 Integer#digits
 - v2.4 Integer#floor
 - v2.4 Integer#round
 - v2.4 Integer#truncate
 - v2.4 Numeric#finite?
 - v2.4 Numeric#infinite?
 - v2.4 String#concat?
 - v2.4 String#prepend?

[1.9.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.8.0...v1.9.0
[1.8.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.7.0...v1.8.0
[1.7.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.6.0...v1.7.0
[1.6.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.5.0...v1.6.0
[1.5.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.3.0...v1.4.0
[1.3.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/AaronLasseigne/polyfill/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/AaronLasseigne/polyfill/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.10.0...v1.0.0
[0.10.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.9.0...v0.10.0
[0.9.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.6.0...v0.7.0
[0.6.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/AaronLasseigne/polyfill/compare/v0.0.0...v0.1.0
