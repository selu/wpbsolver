# Weighing Pool Balls Puzzle Solver

This little program is created to find determined solutions for [Weighing Pool Balls Puzzle](https://www.mathsisfun.com/pool_balls.html).

## Installation

First of all you have to install ruby (if you don't have it already) using [rbenv](https://github.com/fesplugas/rbenv-installer) on Linux or [rubyinstaller] on Windows. Or you can use [jruby](http://jruby.org/) on both Linux and Windows.

If you start with rbenv, you need to install the latest ruby with `rbenv install 2.4.0` or even it can be used to instal jruby with `rbenv install jruby-9.1.6.0`.

You will need bundler and it's not installed automatically: `gem install bundler`.

Finally download wpbsolver and install dependencies:

```
git clone https://github.com/selu/wpbsolver.git
cd wpbsolver
bundle install
```

## Usage

One way is to start `./bin/console` and run the following ruby codes:

```ruby
p = WPBSolver::Problem.new(3,12)  # start with 12 balls and 3
                                  # measures
p.solve_simple                    # find one solution with a simple
                                  # algorithm
p.solve_all                       # find all possible solutions
                                  # it simply return with an array
                                  # of solutions yet
```

The other way is to run same codes directly from ruby:

```
bundle exec ruby -rbundler/setup -rwpbsolver -e "WPBSolver::Problem.new(3).solve_simple"

bundle exec ruby -rbundler/setup -rwpbsolver -e "puts WPBSolver::Problem.new(3).solve_all.count"
```

Currently the fastest solution is implemented in `WPBSolver::Problem#solve_all_fast`.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/selu/wpbsolver.
