#!/bin/bash
# Checks that the RBI in rbi/parlour.rbi is up-to-date with committed changes.
# This is done by generating a new RBI and comparing it with the committed RBI.
set -ev

bundle install
mv rbi/parlour.rbi rbi/parlour-committed.rbi
bundle exec parlour
cmp -s rbi/parlour.rbi rbi/parlour-committed.rbi