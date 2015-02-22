(in-package #:aeon)


(defun concat (&rest args)
  (apply #'concatenate 'string args))
