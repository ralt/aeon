(asdf:defsystem #:aeon-test
  :description "Test package for aeon"
  :author "Florian Margaine <florian@margaine.com>"
  :license "MIT License"
  :serial t
  :depends-on (:aeon :prove)
  :defsystem-depends-on (:prove-asdf)
  :perform (asdf:test-op :after (op c)
                         (funcall (intern #.(string :run) :prove) c))
  :components ((:module "test"
                        :components
                        ((:file "package")
                         (:test-file "http")))))
