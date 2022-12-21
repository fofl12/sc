# Neu Epic Media Standard 2013
This document describes the structure Neu Epic Media Standard 2013 image file format.

## Clarifications
Image Size is an integer between 4 and 8, describing the size of the image. The image's width and height will be 2 raised to the power of Image Size.

## NEM3 File Header
------------
| 1 byte   |
------------
|Image Size|
------------