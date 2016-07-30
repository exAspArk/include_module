# include_module

[![Build Status](https://travis-ci.org/exAspArk/include_module.svg)](https://travis-ci.org/exAspArk/include_module)

There are some general problems with mixins, and a lot of people complain about them:

* [7 Patterns to Refactor Fat ActiveRecord Models](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) (Ruby)
>  Using mixins like this is akin to “cleaning” a messy room by dumping the clutter into six separate junk drawers and slamming them shut. Sure, it looks cleaner at the surface, but the junk drawers actually make it harder to identify and implement the decompositions and extractions necessary to clarify the domain model.

* [Mixins considered harmful/1](http://www.artima.com/weblogs/viewpost.jsp?thread=246341) (Python)
> Injecting methods into a class namespace is a bad idea for a very simple reason: every time you use a mixin, you are actually polluting your class namespace and losing track of the origin of your methods.

* [Mixins Considered Harmful](https://facebook.github.io/react/blog/2016/07/13/mixins-considered-harmful.html) (JavaScript)
> * Mixins introduce implicit dependencies
> * Mixins cause name clashes
> * Mixins cause snowballing complexity

The **include_module** gem was created to avoid these problems with mixins, aka `module` in Ruby. It is a simple library with just 100 LOC

## Usage

TODO

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'include_module'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install include_module

## Development

Install development dependencies:

    gem install bundler
    bundle install

Run tests:

    make test

To release a new version, update the version number in `include_module.gemspec`, and then run:

    make release

Which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/exAspArk/include_module.

To open a pull request:

1. [Fork it](https://github.com/exAspArk/include_module/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create [a new Pull Request](https://github.com/exAspArk/include_module/compare)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
