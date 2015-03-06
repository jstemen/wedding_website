#!/bin/bash
git pull
sudo service passenger-fussion stop
rake assets:clobber &&RAILS_ENV=production bin/rake assets:precompile

sudo service passenger-fussion start