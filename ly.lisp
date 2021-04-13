#|-*- mode:lisp -*-
exec ros -Q -- $0 "$@" # |#
(require "asdf")
(in-package :asdf-user)

(defsystem  :ly)
(require "uiop")
(require "cl-yaml")
(defpackage :ly
  (:use :cl)
  )
(in-package :ly)

(defun main(&rest rest)
  (print 100)
  (print rest)
  t)

(if (uiop:getenv "TEST") (main))
