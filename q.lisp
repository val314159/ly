#|-*- mode:lisp -*-
exec ros -Q -- $0 "$@" # |#
(require :asdf)

(in-package :asdf-user)

(defsystem  :ly)
(require :uiop)
(require :cl-yaml)
(defpackage :ly
  (:export parse-string parse-file parse-path)
  (:use :cl)
  (:import-from :uiop
                :read-file-string)
  (:import-from :libyaml.macros
                :with-parser
                :with-event)
  (:import-from :libyaml.parser
                :parse)
  (:import-from :libyaml.event
                :event-scalar-data
                :event-type))
(in-package :ly)

(defmacro app (arr item) `(nconc arr (list ,item)))

(defun parse-string2 (parser event)
  (let (stack (arr (list :f)))
    (loop
     (when (parse parser event)
       (let ((type (event-type event)))
	 (when (eql type :scalar-event)
	   (app arr (getf (event-scalar-data event) :value)))
	 (when (eql type :document-start-event)
	   (push arr stack)
	   (setf arr (list :d)))
	 (when (eql type :sequence-start-event)
	   (push arr stack)
	   (setf arr (list :s)))
	 (when (eql type :mapping-start-event)
	   (push arr stack)
	   (setf arr (list :m)))
	 (when (eql type :document-end-event)
	   (setf arr (app (pop stack) arr)))
	 (when (eql type :sequence-end-event)
	   (setf arr (app (pop stack) arr)))
	 (when (eql type :mapping-end-event)
	   (setf arr (app (pop stack) arr)))
	 (when (eql type :stream-end-event)
	   (return-from parse-string2 arr)))))))

(defun parse-string (string)
  (with-parser (parser string)
	       (with-event (event)
			   (parse-string2 parser event))))


(defun parse-file (file)
  (parse-string (read-file-string file)))

(defun parse-path (path)
  (parse-file (open path)))

(defun main(&rest rest)
  (print " -- ly test --")
  (print rest)
  (print (parse-string "[1,2,3]"))
  (mapcar (lambda (x) (print "===") (print (parse-path x))) rest)
  (terpri))

(if (uiop:getenv "TEST") (main))

