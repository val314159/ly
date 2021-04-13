(require :cl-libyaml)
(defpackage yaml-example
  (:use :cl)
  (:import-from :libyaml.macros
                :with-parser
                :with-event)
  (:import-from :libyaml.event
                :event-type))
(in-package :yaml-example)

(defun parse (string)
  (with-parser (parser string)
    (with-event (event)
      (loop do
        (when (libyaml.parser:parse parser event)
          (let ((type (event-type event)))
            (print type)
            (when (eql type :stream-end-event)
              (return-from parse nil))))))))

(defun main ()
  (print (parse "[1,2,3]"))
  (print (parse (uiop:read-file-string (open "11.yml"))))
  (terpri))

	    
