(in-package #:aeon)


(defun cat (&rest args)
  (apply #'concatenate 'string args))
