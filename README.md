# ly
====

lisp yaml, improved from *cl-yaml* (reads whole files with multiple documents)

## Install

you can just pop the `.lisp` file into `~/common-lisp` as an `.asd` file

    cp ly.lisp ~/common-lisp/ly.asd

## Compile

    ros build ly.lisp

## Running

    common-lisp/ly.asd 11 22

## Importing

    (require :ly)

