# USAGE

`./exif-extractor.rb help process` to see all options

Output can be specified with `-o` option or by piping output to a file like `./exif-extractor.rb > out.csv`. Warnings (if any) will be written to stderr and not present in the final output.

# ruby-cli-project

This is our first week's project where we will bring together the skills we've practiced so far:

- Ruby scripts
- Ruby conventions and best practices
- writing tests with minitest

This repository contains two projects:

- Hello world project
- Main project

We'll use [Thor's](https://github.com/rails/thor) gem to create the CLIs.

Note: for each project, please create a new repository here on GitHub so you can share them later. They will also serve as references for your next steps with Ruby :)

## Hello world project: get familiar with Thor

For this first project, your project is to follow the tutorial from the Thor documentation page.

You can find the tutorial [here](http://whatisthor.com/). It contains a Getting Started and other advanced options to explore. Feel free to explore around and write tests, when it makes sense.

## Main project: build a CLI to extract images EXIF GPS Data

Using Ruby and the Thor gem, create a command line application that:

- recursively reads all of the images from the supplied directory of images (available in this project as `gps_images.zip`)
- extracts their EXIF GPS data (longitude and latitude)
- and then writes the name of that image and any GPS co-ordinates it finds to a CSV file

This utility should be executable from the command line using the Thor gem.

With no parameters, the utility should default to scanning from the current directory. It should take an optional parameter that allows any other directory to be passed in.

As a bonus, output either CSV or HTML, based on a parameter passed in via the command line.

Feel free to use any gem(s) you like in your submission. Recommended gems:

- [EXIF](https://github.com/tonytonyjan/exif) - The fastest Ruby EXIF reader.
- [Builder](https://github.com/jimweirich/builder) - Provide a simple way to create XML markup and data structures.

You'll probably need to have [libexif](https://libexif.github.io/) installed.

Note: write tests using minitest. We recommend TDD'ing the project. We encourage you to think about the edge cases, the happy and unhappy paths. Remember to check out the testing resources available and ask for help in your pod channel/mentors for your pod.

## Resources

- [Thor's Wiki](https://github.com/rails/thor/wiki)
- [Testing Thor Ruby Required Options](https://www.hexdevs.com/posts/thor-ruby-options-testing/) - this post uses RSpec but gives you a boilerplate for testing Thor

You'll have two days to work on these projects. Take your time to get familiar with Thor, using Ruby gems, and writing tests with minitest. We highly encourage you to ask questions and share your progress on Slack, and pair with teammates.

Don't forget to share the repository links so we can discuss them. Have fun!
