Wedding Website
================
[![Build Status](https://semaphoreapp.com/api/v1/projects/c40331c6-c0cc-4fb6-b6b5-63be2d22e595/359615/badge.png)](https://semaphoreapp.com/jstemen/wedding_website)

Overview
-------------

This application is a small Ruby on Rails project.  Its purpose is to provide wedding details to wedding guests and allow them to RSVP to events.  It is currently hosted on Elastic Beanstalk with a MySQL RDS instance here: [palakandjared.com](https://www.palakandjared.com)  

The [Save the Date Game](https://www.palakandjared.com/pages/save_the_date) is a [Phaser](http://phaser.io/) powered HTML5 game.

The site is designed to work in conjunction with paper invitations.  The designed work-flow is as follows:
1. The couple sends out a paper invitations to guests' households with a unique random code.  Each paper invitation may be for multiple guests at the household.  Each guest may be invited to a different set of wedding events.
2. When the guest family receives the invitation, one member enters the family's unique code on the website.  
3. The family member selects which events each family member plans to attend and clicks submit.
4. The website administrator can login to the admin part of the website and view which guests are coming to which events.


Getting Started
---------------

Currently the application requires ruby 2.2.2, so install that and then do 

* gem install bundler
* bundle install
* rake db:reset
* bundle exec guard

This is will bring up automated testing and the development version of the website.  The default admin email address and password are both 'admin@example.com'.


Environment Variables
---------------------
The website expects the following environment variables to be defined to operate fully:

* GOOGLE_ANALYTICS_TRACKING_ID
* WEDDING_WEBSITE_SECRET_DB_HOST
* WEDDING_WEBSITE_SECRET_DB_PASSWORD
* WEDDING_WEBSITE_SECRET_DB_USERNAME

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
