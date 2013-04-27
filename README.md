# Snipp
[![Gem Version](https://badge.fury.io/rb/snipp.png)](http://badge.fury.io/rb/snipp)
[![Coverage Status](https://coveralls.io/repos/yulii/snipp/badge.png?branch=master)](https://coveralls.io/r/yulii/snipp)
[![Build Status](https://travis-ci.org/yulii/snipp.png)](https://travis-ci.org/yulii/snipp)

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snipp'
```
And then execute:
```sh
$ bundle
```
Or install it yourself as:
```sh
$ gem install snipp
```
## Usage
### Breadcrumbs
```html+ruby
<%= breadcrumb [:root, :food, :food_fruit, :food_fruit_red, :food_fruit_red_apple], s: "/" %>
```

link to `root_path`, `food_path`, `food_fruit_path`, `food_fruit_red`, `food_fruit_red_apple`

Link text
```yaml
en:
  views:
    breadcrumb:
      # Sample
      root: "Top"
      food: "Food"
      food_fruit: "Fruit"
      food_fruit_red: "Red"
      food_fruit_red_apple: "Apple"
```

more https://github.com/yulii/snipp/blob/master/app/views/snipp/index.html.erb

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## LICENSE
(The MIT License)

Copyright © 2013 yulii. See LICENSE.txt for further details.
