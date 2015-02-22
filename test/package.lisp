(defpackage #:aeon-test
  (:use :cl :prove))


(in-package #:aeon-test)


(defun concat (&rest args)
  (apply #'concatenate 'string args))
