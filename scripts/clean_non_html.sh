#!/bin/bash

#Remove top level pages such as bios and index
rm volume/*/*/*.html

#rmeove any resource files. Should be images but might 
#also contain html source that we do not want
rm -rf volume/*/*/*/resources
