#|-*- mode:lisp -*-|#

(defsystem #:ly
  :description "Describe ly here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :depends-on (:uiop :cl-libyaml)
  :components ((:file ly)))
