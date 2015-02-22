(asdf:defsystem #:aeon
  :description "TCP proxy for your HTTP requests"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:usocket :log4cl :cl-ppcre)
  :components ((:module "src"
                        :components
                        ((:file "package")
                         (:file "list")
                         (:file "string")
                         (:file "scanner")
                         (:file "http")
                         (:file "aeon"))))
  :in-order-to ((asdf:test-op (asdf:test-op #:aeon-test))))
