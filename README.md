## Pinterest Spammer

Official Pinterest API doesn't support pin creation. This script allows you to do that.

## Usage Example

Open Terminal, go to project folder and write:
```
irb
require './lib/pinterest_spammer.rb'
agent = PinterestSpammer.new
agent.sign_in 'your_username','your_password'
agent.get_boards  # get boards list, that contains board_id (for example - 455708124733779520)
agent.create_pin(455708124733779520, 'https://xyz.xyz/', 'http://rubyonrails.org/images/rails.png', 'Spammer!')

```
