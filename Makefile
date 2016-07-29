.PHONY: test

test:
	bundle exec m test/include_module_test.rb
release:
	bundle exec rake release
