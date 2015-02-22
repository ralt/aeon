(in-package #:aeon)


(defun http-response-parse-lines (lines)
  (format nil "~{~A~}~A"
          (mapcar #'(lambda (line)
                      (concat line *newline*))
                  lines)
          *newline*))

(defun http-response-dump (res)
  res)

(defun http-response-set-status (res status message)
  (append res
          (unless res
            (list (list* 'version "HTTP/1.1")))
          (list (list* 'status status))
          (list (list* 'message message))))
