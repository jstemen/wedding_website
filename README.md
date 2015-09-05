Wedding Website
================
[![Build Status](https://semaphoreapp.com/api/v1/projects/c40331c6-c0cc-4fb6-b6b5-63be2d22e595/359615/badge.png)](https://semaphoreapp.com/jstemen/wedding_website)

Overview
-------------

This application is a small Ruby on Rails project.  Its purpose is to provide wedding details to wedding guests and allow them to RSVP to events.  It is currently hosted on Elastic Beanstalk with a MySQL RDS instance here: [palakandjared.com](https://palakandjared.com)  

Getting Started
---------------

Currently the application requires ruby 2.2.2, so install that and then do 

*gem install bundler
*bundle install
*rake db:migrate
*rake db:seed
*bundle exec guard

This is will bring up automated testing and the development version of the website.


License
-------
The MIT License (MIT)

Copyright (c) 2015 Jared Stemen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
