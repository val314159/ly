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
  (:import-from :libyaml.macros
                :with-parser
                :with-event)
  (:import-from :libyaml.parser
                :parse)
  (:import-from :libyaml.event
                :event-scalar-data
                :event-type))
(in-package :ly)

(defun parse-string2 (parser event)
  (let (arr stack)
    (loop
     (when (parse parser event)
       (let ((type (event-type event)))

	 (when (eql type :scalar-event)
	   (nconc arr (list (getf (event-scalar-data event) :value))))
	 
	 (when (eql type :stream-start-event)
	   (push arr stack)
	   (setf arr (list :x))
	   )
	 (when (eql type :arr-start-event)
	   (push arr stack)
	   (setf arr (list :d))
	   )
	 (when (eql type :sequence-start-event)
	   (push arr stack)
	   (setf arr (list :s))
	   )
	 (when (eql type :mapping-start-event)
	   (push arr stack)
	   (setf arr (list :m))
	   )
	 
	 (when (eql type :arr-end-event)
	   (let ((oldarr arr))
	     (setf  arr (pop stack))
	     (nconc arr (list oldarr)))
	   )
	 (when (eql type :sequence-end-event)
	   (let ((oldarr arr))
	     (setf  arr (pop stack))
	     (nconc arr (list oldarr))
	   ))
	 (when (eql type :mapping-end-event)
	   (let ((oldarr arr))
	     (setf  arr (pop stack))
	     (nconc arr (list oldarr))
	   ))
	 (when (eql type :stream-end-event)
	   (let ((oldarr arr))
	     (setf  arr (pop stack))
	     (nconc arr (list oldarr))
	     (return-from parse-string2 arr)
	     ))
	 )))))

(defun parse-string (string)
  (with-parser (parser string)
	       (with-event (event)
			   (parse-string2 parser event))))


(defun parse-file (file)
  (parse-string (uiop:read-file-string file)))

(defun parse-path (path)
  (parse-file (open path)))

(defun main(&rest rest)
  (print " -- ly test --")
  (print rest)
  (print (parse-string "[1,2,3]"))
  (mapcar (lambda (x) (print "===") (print (parse-path x))) rest)
  t)

(if (uiop:getenv "TEST") (main))

