(in-package #:aeon)


(defun http-response-dump (status reason headers body)
  (concat "HTTP/1.1 " (write-to-string status) " " reason *newline*
          (format nil "~{~A~}"
                  (loop for header in headers
                     collect (concat (symbol-name (first header))
                                     ": " (rest header) *newline*)))
          *newline*
          body))

(defun http-response-set-status (res status message)
  (append res
          (unless res
            (list (list* 'version "HTTP/1.1")))
          (list (list* 'status status))
          (list (list* 'message message))))
