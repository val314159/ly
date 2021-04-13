#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
;;#+quicklisp(ql:quickload '(:cl-libyaml) :silent t)
;;(progn ;;init forms
;;  (ros:ensure-asdf)
;;  #+quicklisp(ql:quickload '() :silent t)
;;  )

;;(require :asdf)
;;(require :uiop)
;;(require :cl-libyaml)
;;(in-package :asdf-user)

(defsystem #:ly
  :description "Describe ly here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (:uiop :cl-libyaml)
  :components ((:file ly)))
