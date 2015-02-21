(asdf:defsystem #:aeon
  :description "TCP proxy for your HTTP requests"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on ("usocket" "log4cl" "cl-ppcre")
  :components ((:file "package")
               (:file "aeon")))
