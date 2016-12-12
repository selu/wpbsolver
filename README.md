# WPBSolver

This little program is created to find non-deterministic solutions for [Weighing Pool Balls Puzzle](https://www.mathsisfun.com/pool_balls.html).
As of now it can be used only by running `bin/console`:

```ruby
p = WPBSolver::Problem.new(12,3)
p.solve
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'wpbsolver'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install wpbsolver

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/selu/wpbsolver.

