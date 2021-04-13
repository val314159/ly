#!/bin/sh
#|-*- mode:lisp -*-|#
#|
exec ros -Q -- $0 "$@"
|#
;;(progn ;;init forms
;;  (ros:ensure-asdf)
;;  #+quicklisp(ql:quickload '() :silent t)
;;  )
(in-package :asdf-user)
;;(require :asdf)
(require :uiop)
(require :cl-libyaml)
;;(in-package :asdf-user)

(defsystem  :ly
  :depends-on (:uiop :cl-libyaml))

(defpackage :ly
  (:export parse-path parse-file parse-string)
  (:use :cl)
  (:import-from :uiop
		read-file-string)
  (:import-from :libyaml.macros
                with-parser with-event)
  (:import-from :libyaml.parser
		parse)
  (:import-from :libyaml.event
                event-scalar-data event-type))
(in-package :ly)

(defun convert-event (event)
  (let ((s (event-scalar-data event)))
	(getf s :value)))

(defun parse-parser (parser event)
  (let (arr bak)
    (loop
     (when (parse parser event)
       (let ((type (event-type event)))
	 (when (eql type :stream-start-event)
	   (push arr bak)
	   (setf arr (list :f)))
	 (when (eql type :document-start-event)
	   (push arr bak)
	   (setf arr (list :d)))
	 (when (eql type :sequence-start-event)
	   (push arr bak)
	   (setf arr (list :s)))
	 (when (eql type :mapping-start-event)
	   (push arr bak)
	   (setf arr (list :m)))
	 (when (eql type :scalar-event)
	   (let ((d (convert-event event)))
	     (nconc arr (list d))))
	 (when (eql type :mapping-end-event)
	   (let ((d arr))
	     (setf arr (pop bak))
	     (nconc arr (list d))))
	 (when (eql type :sequence-end-event)
	   (let ((d arr))
	     (setf arr (pop bak))
	     (nconc arr (list d))))
	 (when (eql type :document-end-event)
	   (let ((d arr))
	     (setf arr (pop bak))
	     (nconc arr (list d))))
	 (when (eql type :stream-end-event)
           (return-from parse-parser arr)))))))

(defun parse-string (string)
  (with-parser (parser string)
	       (with-event (event)
			   (parse-parser parser event))))

(defun parse-file (file)
  (parse-string (read-file-string file)))

(defun parse-path (path)
  (parse-file (open path)))

(defun main (&rest rest)
  (print "test")
  (print rest)
  (print (parse-string "[1,2,3]"))
  (mapcar (lambda (x)
	    (print "===")
	    (print (parse-file (open x))))
	  rest)
  (terpri))
