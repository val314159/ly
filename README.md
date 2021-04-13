#|-*- mode:lisp -*-
:<<:>>/dev/null      # START Documentation

# ly
lisp yaml, improved from cl-yaml (reads whole files with multiple documents)

title
=====

# t1

## t2

### t3

#### t4

- 11 **22**

- 44 __55__

:
exec ros -Q -- $0 "$@" # |#
(require "asdf")
(in-package :asdf-user)

(require "uiop")
(require "cl-yaml")

(defsystem  :ly)
(defpackage :ly
  (:use :cl)
  (:depends-on "uiop" "cl-libyaml"))
(in-package :ly)

(defun main(&rest rest)
  (print 100)
  (print rest)
  t)

(if (uiop:getenv "TEST")
    (main))
