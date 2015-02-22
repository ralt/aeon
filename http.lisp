(in-package #:aeon)


(defvar *request-line-scanner*
  (cl-ppcre:create-scanner
   (cat
    "^(GET|HEAD|POST|PUT|DELETE|TRACE|OPTIONS|CONNECT|PATCH) " ; methods
    "([a-zA-Z0-9%_\\/-]+) " ; request uri
    "HTTP\\/1.1$") ; only HTTP/1.1 is supported for now
   :case-insensitive-mode t))

(defvar *request-header-scanner*
  (cl-ppcre:create-scanner
   "^\\s*([a-zA-Z0-9-]+)\\s*:\\s*(.+)$"))

(defun http-request-parse-lines (lines &optional req)
  (unless lines
    (return-from http-request-parse-lines req))
  (let ((line (first lines)))
    (multiple-value-bind (present-p matches)
        (cl-ppcre:scan-to-strings *request-line-scanner* line)
      (when present-p
        (http-request-parse-lines
         (rest lines)
         (http-request-set-request-line req (elt matches 0) (elt matches 1)))))
    (multiple-value-bind (present-p matches)
        (cl-ppcre:scan-to-strings *request-header-scanner* line)
      (when present-p
        (http-request-parse-lines
         (rest lines)
         (http-request-set-header req (elt matches 0) (elt matches 1)))))))

(defun http-request-set-header (req header value)
  (unless req
    (return-from http-request-set-header
      (http-request-set-header (list (list* 'headers nil)) header value)))
  (unless (list-get-item 'headers req)
    (return-from http-request-set-header
      (http-request-set-header (append req (list (list* 'headers nil))) header value)))
  (list-merge req 'headers (append (list-get-item 'headers req)
                                   (list (list* header value)))))

(defun http-request-set-request-line (req method request-uri)
  (append req
          (list (list* 'method method))
          (list (list* 'request-uri request-uri))
          (list (list* 'version "HTTP/1.1"))))

(defun http-request-host (req)
  (declare (ignore req)))

(defun http-request-port (req)
  (declare (ignore req)))

(defun http-request-dump (req)
  (declare (ignore req)))

(defun http-response-parse-lines (lines)
  (declare (ignore lines)))

(defun http-response-dump (res)
  (declare (ignore res)))

(defun http-response-set-status (res status message)
  (append res
          (unless res
            (list (list* 'version "HTTP/1.1")))
          (list (list* 'status status))
          (list (list* 'message message))))
