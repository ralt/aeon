(in-package #:aeon)


(defvar *request-line-scanner*
  (cl-ppcre:create-scanner
   '(:sequence
     :start-anchor
     (:register ;; methods
      (:alternation
       "GET" "HEAD" "POST" "PUT" "DELETE" "TRACE" "OPTIONS" "CONNECT" "PATCH"))
     #\Space
     (:register ;; request URI
      (:greedy-repetition 1 nil
       (:char-class (:range #\a #\z)
                    (:range #\A #\Z)
                    (:range #\0 #\9)
                    #\%
                    #\_
                    #\/
                    #\-)))
     #\Space
     "HTTP" #\/ "1.1"
     #\Return
     :end-anchor)
   :case-insensitive-mode t))

(defvar *request-header-scanner*
  (cl-ppcre:create-scanner
   '(:sequence
     :start-anchor
     (:greedy-repetition 0 nil :whitespace-char-class)
     (:register ;; header name
      (:greedy-repetition 1 nil
       (:char-class (:range #\a #\z)
                    (:range #\A #\Z)
                    (:range #\0 #\9)
                    #\-)))
     (:greedy-repetition 0 nil :whitespace-char-class)
     #\:
     (:greedy-repetition 0 nil :whitespace-char-class)
     (:register ;; header value
      (:greedy-repetition 1 nil :everything))
     #\Return
     :end-anchor)))
