# blackjack

My first GUI ever. Built using Gosu

## Pre-requirements
* ruby

## To get started

1. `cd` into your project directory with `cd /blackjack/`
2. run `bundle install` to install all of the gem dependencies
3. finally, run `ruby game.rb` in a terminal to start playing!


**Start of Game**

![Start Game](https://imgur.com/r1hOrLO.png)

**Click your facedown card to flip it**

![Flip Card](https://imgur.com/AndLwVB.png)

**Hit 'Stand' to start dealers turn, or 'Hit' to get another card**

![Stand](https://imgur.com/n0o9TXI.png)

## To build a Windows executable
1. `gem install ocra`
2. run `ocra game.rb media/**/*.png  --gemfile Gemfile --windows --chdir-first`


