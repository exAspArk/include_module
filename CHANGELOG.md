# Changelog

The following are lists of the notable changes included with each release.
This is intended to help keep people informed about notable changes between
versions, as well as provide a rough history. Each item is prefixed with
one of the following labels: `Added`, `Changed`, `Deprecated`,
`Removed`, `Fixed`, `Security`. We also use [Semantic
Versioning](http://semver.org) to manage the versions of this gem so
that you can set version constraints properly.

#### [Unreleased](https://github.com/exAspArk/include_module/compare/v1.0.0...HEAD)

* WIP

#### [v1.0.0](https://github.com/exAspArk/include_module/compare/v0.1.0...v1.0.0) – 2016-09-16

* `Changed`: use `extend_module` for class methods:

```ruby
class Foo
  extend IncludeModule
  extend_module Bar::ClassMethods, methods: :all
end
```

Instead of:

```ruby
class Foo
  extend IncludeModule
  include_module Bar, class_methods: :all
end
```

#### [v0.1.0](https://github.com/exAspArk/include_module/compare/9bfa492...v0.1.0) – 2016-08-16

* `Added`: initial functional version with docs.
