# Contributing 

## Issues
If there are any issues, feel free to create an issue on the GitHub repository issue page.

## Development 
After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to rubygems.org.

If there are issues with running the `bin` files, try to `chmod +x bin/*` the files first.

## Contribution Guidelines
1.  Make commits that are logically well isolated and have descriptive commit messages.
 
2.  Make sure that there are tests in the [spec](./spec) directory for the code you wrote.

3.  Make sure that changes to public methods or interfaces are documented in this README.

4.  Run tests and address any errors.

5.  Open a pull request with a descriptive message that describes the change, the need, and verification that the change is tested.
