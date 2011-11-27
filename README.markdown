# Gync

by Sergey Potapov

## Description

This tool allows you to synchronize application data using git version system.

For example I use [rednotebook](http://rednotebook.sourceforge.net) and
[gnucash](http://www.gnucash.org). I have a number of devices(PC, laptop,etc.).
When I open rednotebook on my laptop I want to see changes done on my PC.


## Get started

I suppose you have already a git repository. You can use github if you don't care about privacy.

Install gync:

    gem install gync

Create config file in you home directory `$HOME/.gync.yml`. For example:

    rednotebook:
      local:  "/absolute/path/to/directory/you/want/to/synchonize"
      remote: "/path/to/already/created/remote/git/repository"
    gnucash:
      local:  "/local/path/to/gnucash/data"
      local:  "/remote/repo/for/gnucash"

Then just run your application:

    gync rednotebook

When you run it this way gync pulls changes before your applications started
and pushes when it is finished.

For convenience you can create aliases in your `.bashrc`(or any other shell rc file):

    alias rednotebook="gync rednotebook"
    alias gnucash="gync gnucash"

## Contributing to gync
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 Potapov Sergey. See LICENSE.txt for
further details.
