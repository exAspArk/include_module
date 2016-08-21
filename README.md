# include_module

[![Build Status](https://travis-ci.org/exAspArk/include_module.svg)](https://travis-ci.org/exAspArk/include_module)
[![codecov](https://codecov.io/gh/exAspArk/include_module/branch/master/graph/badge.svg)](https://codecov.io/gh/exAspArk/include_module)
[![Code Climate](https://codeclimate.com/github/exAspArk/include_module/badges/gpa.svg)](https://codeclimate.com/github/exAspArk/include_module)

There are some general problems with mixins, and a lot of people complain about
them:

* [7 Patterns to Refactor Fat ActiveRecord Models](http://blog.codeclimate.com/blog/2012/10/17/7-ways-to-decompose-fat-activerecord-models/) (Ruby)
>  Using mixins like this is akin to “cleaning” a messy room by dumping the
>  clutter into six separate junk drawers and slamming them shut. Sure, it looks
>  cleaner at the surface, but the junk drawers actually make it harder to
>  identify and
>  implement the decompositions and extractions necessary to clarify the domain
>  model.

* [Mixins considered harmful/1](http://www.artima.com/weblogs/viewpost.jsp?thread=246341) (Python)
> Injecting methods into a class namespace is a bad idea for a very simple
> reason: every time you use a mixin, you are actually polluting your class
> namespace and losing track of the origin of your methods.

* [Mixins Considered Harmful](https://facebook.github.io/react/blog/2016/07/13/mixins-considered-harmful.html) (JavaScript)
> * Mixins introduce implicit dependencies
> * Mixins cause name clashes
> * Mixins cause snowballing complexity

The **include_module** gem was created to help you to use mixing (aka `module` in Ruby)
explicitly.
It is a simple library with just 100 LOC, with
zero dependencies, without any monkey patches and method overridings.

## Usage

There are 2 common ways to use mixins in Ruby.

1) [Module.included(base)](http://ruby-doc.org/core-2.3.1/Module.html#method-i-included)

```ruby
module UserMixin
  def self.included(base)
    base.extend(ClassMethods)
    base.class_eval do
      belongs_to :account
    end
  end

  module ClassMethods
    def top_user
      User.order(rating: :desc).first
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end

class User
  include UserMixin
end
```

This is a standard way of using mixins in Ruby. The problem here is that when
you look at the `User` you have no idea which methods the `UserMixin`
defines in the class.

2) [ActiveSupport::Concern](http://api.rubyonrails.org/classes/ActiveSupport/Concern.html)

```ruby
module UserMixin
  extend ActiveSupport::Concern

  included do
    belongs_to :account
  end

  class_methods do
    def top_user
      User.order(rating: :desc).first
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end

class User
  include UserMixin
end
```

By extending your module, you add `.class_methods` which basically hides
`ClassMethods` module inside, overrides `.append_features` and `.included` methods.
Additionally it keeps tracking how many times `.included`
was called to raise a custom exception about multiple "included" blocks.

But mostly `ActiveSupport::Concern` has the same problem as standard `Module.included`.
Why can't we define explicitly which methods we would like to use from a mixin?

### **include_module**

```ruby
module UserMixin
  INCLUDED = proc do
    belongs_to :account
  end

  module ClassMethods
    def top_user
      User.order(rating: :desc).first
    end
  end

  def name
    "#{first_name} #{last_name}"
  end
end

class User
  extend IncludeModule

  include_module UserMixin, included: true, class_methods: [:top_user], instance_methods: [:name]
end
```

Now when you look at the class you can see which methods "included_module" adds in it.
And it's all done without any monkey patches or method overridings.

It is almost in-place replacement for `ActiveSupport::Concern`. Here is a diff:

```ruby
 module UserMixin
-  extend ActiveSupport::Concern
-
-  included do
+  INCLUDED = proc do
     belongs_to :account
   end

 ...

 class User
+  extend IncludeModule
+
-  include_module UserMixin
+  include_module UserMixin, included: true, class_methods: [:top_user], instance_methods: [:name]
 end
```

You can also control which methods you would like to include, rename them
while including in order to avoid name clashes, etc. Please see more examples below.

## How Does It Work?

* Include no methods

When you add `extend IncludeModule`, you add just one public method called `include_module` in
your class.

```ruby
class User
  extend IncludeModule
  include_module UserMixin
end
```

By default when you call `include_module` without any options, it won't load anything.

* Include all methods

If you want to include everything from your module, you can pass the following options:

```ruby
class User
  extend IncludeModule
  include_module UserMixin, included: true, class_methods: :all, instance_methods: :all
end
```

It will `include` you module, `extend` your `ClassMethods` and `class_eval` your
`INCLUDED` proc without any changes.

* Include some methods

You can define explicitly which methods you want to include from you module:

```ruby
module TestModule
  def foo
    :foo
  end

  def bar
    :bar
  end
end

class TestClass
  extend IncludeModule
  include_module TestModule, instance_methods: [:foo]
end
```

In this case we have only `TestClass#foo` method implemented.
It basically creates a new anonymous module which contains only specified methods and includes it as usual.

* Rename included method

```ruby
class User
  extend IncludeModule
  include_module UserMixin, instance_methods: [name: :full_name]
end
```

We can rename methods while including a mixin by creating a new anonymous module as in the previous example.
So `User#full_name` method will be available instead of `User#name`.

## Installation

Install Ruby version >= 2.1.

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

To release a new version, update the version number in `include_module.gemspec`,
and then run:

    make release

Which will create a git tag for the version, push git commits and tags, and push
the `.gem` file to [rubygems.org](https://rubygems.org).

## What's New?

Please read the [changelog](./CHANGELOG.md).

## Contributing

Bug reports and pull requests are welcome on GitHub at
https://github.com/exAspArk/include_module.

To open a pull request:

1. [Fork it](https://github.com/exAspArk/include_module/fork)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create [a new Pull
Request](https://github.com/exAspArk/include_module/compare)

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
