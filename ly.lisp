(defpackage :ly
  (:use :cl)
  (:import-from :uiop
		read-file-string)
  (:import-from :libyaml.macros
		with-parser with-event)
  (:import-from :libyaml.parser
		parse)
	    (:import-from :libyaml.event
			  event-scalar-data event-type)
	    (:export parse-path parse-file parse-string
		     ))
(in-package :ly)

(defun convert-event (event)
  (let ((s (event-scalar-data event)))
    (getf s :value)))

(defun parse-parser (parser event &aux arr bak)
  (loop
   (when (parse parser event)
     (let ((old  arr)
	   (type (event-type event)))
       (when (eql type :stream-start-event)
	 (push arr bak) (setf arr (list :f)))
       (when (eql type :document-start-event)
	 (push arr bak) (setf arr (list :d)))
       (when (eql type :sequence-start-event)
	 (push arr bak) (setf arr (list :s)))
       (when (eql type :mapping-start-event)
	 (push arr bak) (setf arr (list :m)))
       (when (eql type :scalar-event)
	 (nconc arr (list (convert-event event))))
       (when (eql type :mapping-end-event)
	 (setf arr (nconc (pop bak) (list old))))
       (when (eql type :sequence-end-event)
	 (setf arr (nconc (pop bak) (list old))))
       (when (eql type :document-end-event)
	 (setf arr (nconc (pop bak) (list old))))
       (when (eql type :stream-end-event)
         (return-from parse-parser arr))))))

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
