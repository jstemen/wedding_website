#!/bin/bash

bundle exec rake assets:clobber && bundle exec rake assets:precompile && eb deploy
