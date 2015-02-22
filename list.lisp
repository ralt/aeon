(in-package #:aeon)


(defun list-merge (list symbol replacement)
  (mapcar #'(lambda (item)
              (if (eq symbol (first item))
                  replacement
                  item))
          list))

(defun list-get-item (symbol list)
  (find-if #'(lambda (item)
               (eq (first item) symbol))
           list))
