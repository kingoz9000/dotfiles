#!/bin/bash

KANJI=$(cat /tmp/random_kanji.txt)
qutebrowser --target window "https://jisho.org/search/$KANJI"
