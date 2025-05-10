# SXG Checker

[![Gem Version](https://badge.fury.io/rb/sxg_checker.svg)](https://badge.fury.io/rb/sxg_checker)

A library and command-line tool for checking the Google Signed Exchanges (SXG) cache for the presence of a document and its subresources.

It verifies if your web page and its resources are properly available in Google's SXG cache,
helping you troubleshoot SXG implementation issues with detailed status reporting for each resource.

SXG enables websites to optimize Largest Contentful Paint (LCP) by allowing prefetching directly from the Google search results page.
For a step-by-step guide, see my [SXG tutorial](https://www.pawelpokrywka.com/p/how-i-took-lcp-down-under-350ms).
This tool is also referenced in the section on [monitoring and measuring SXG](https://www.pawelpokrywka.com/p/measuring-signed-exchanges-impact).

## Status indicators

| Symbol | Status | Description |
|--------|---------|-------------|
| ✓ | ok | Resource exists and is valid |
| ? | missing | Resource not found in SXG cache |
| x | invalid | Resource exists but its signature is invalid |
| ! | parsing_error | Unable to parse the SXG resource |
| ~ | links_mismatch | The subresources specified in SXG don't match subresources to be prefetched from SXG cache |
| ≠ | integrity_mismatch | Subresource integrity hash mismatch |

## Installation

Make sure to install [dump-signedexchange](https://github.com/WICG/webpackage/blob/main/go/signedexchange/README.md).

If you intend to use it as a library for your app, add to your `Gemfile`:
```ruby
gem "sxg_checker"
```

Otherwise, to make the command-line tool available to all users in the system, run:
```shell
sudo gem install sxg_checker
```

If you prefer to make it available to yourself only, execute instead:
```shell
gem install --user-install sxg_checker
```

In case of user-specific installation, make sure to add the directory containing the executable to your `$PATH`.
You can find the executable location by running:

```shell
gem contents sxg_checker | grep sxg-checker
```

## Usage

### Command line

To check a URL in Google's SXG cache:

```shell
sxg-checker validate https://www.yourwebsite.com/your-page
```

To get full usage instructions, run:

```shell
sxg-checker --help
```

### In Ruby applications

You can also use SXG Checker as a library in your Ruby applications:

```ruby
require 'sxg_checker'

checker = SxgChecker::Checker.new(tool: '/usr/local/bin/dump-signedexchange') # The `tool` parameter is optional
document = checker.validate(url)

# Access the results
puts document.url    # The URL of the cached document
puts document.status # The status symbol (:ok, :missing, etc.)

# Iterate through subresources
document.subresources.each do |subresource|
  puts "#{subresource.url}: #{subresource.status}"
end

# If you want to skip validating subresources
result = checker.validate(url, subresources: false)

# If you want to only warm the SXG cache for a given URL
checker.warm_cache(url)

```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `bundle exec rake spec` to run the tests.
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To build the gem, run `bundle exec rake build`. To release a new version, update the version number in `version.rb`,
and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag,
and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at [https://github.com/pepawel/sxg_checker].
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere
to the code of conduct.

## Author

My name is Paweł Pokrywka and I'm the author of SXG Checker.

If you want to contact me or get to know me better, check out
[my blog](https://www.pawelpokrywka.com).

## License

The software is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
