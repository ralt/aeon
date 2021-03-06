(in-package #:aeon-test)

(plan 12)

(is (aeon:http-response-set-status nil 500 "foo")
    '((aeon:version . "HTTP/1.1") (aeon:status . 500) (aeon:message . "foo")))

(is (aeon:http-request-host '((aeon:method . "GET") (aeon:headers . ((aeon:host . "foobar")))))
    "foobar")

(is (aeon:http-request-port '((aeon:method . "GET") (aeon:headers . ((aeon:host . "foobar:443")))))
    443)

(is (aeon:http-request-port '((aeon:method . "GET") (aeon:headers . ((aeon:host . "foobar")))))
    80)

(is (aeon:http-request-set-request-line nil "GET" "/foo")
    '((aeon:method . "GET") (aeon:request-uri . "/foo") (aeon:version . "HTTP/1.1")))

(is (aeon:http-request-set-header nil "Authorization" "bar")
    '((aeon:headers . ((aeon:authorization . "bar")))))

(is (aeon:http-request-set-header '((aeon:method . "GET") (aeon:version . "HTTP/1.1")
                                    (aeon:headers . ((aeon:authorization . "bar"))))
                                  "Cookie" "foo=bar")
    '((aeon:method . "GET") (aeon:version . "HTTP/1.1")
      (aeon:headers . ((aeon:authorization . "bar") (aeon:cookie . "foo=bar")))))

(is (aeon:http-request-parse-lines '("GET http://foo.bar/ HTTP/1.1" "Host: foo.bar"))
    '((aeon:method . "GET") (aeon:request-uri . "http://foo.bar/")
      (aeon:version . "HTTP/1.1") (aeon:headers . ((aeon:host . "foo.bar")))))

(is (aeon:http-request-request-uri '((aeon:request-uri . "http://foo.bar/foo")
                                     (aeon:headers . ((aeon:host . "foo.bar")))))
    "/foo")

(is (aeon:http-request-request-uri '((aeon:request-uri . "https://foo.bar/foo")
                                     (aeon:headers . ((aeon:host . "foo.bar")))))
    "/foo")

(is (aeon:http-request-request-line '((aeon:method . "GET")
                                      (aeon:request-uri . "http://foo.bar/foo")
                                      (aeon:version . "HTTP/1.1")
                                      (aeon:headers . ((aeon:host . "foo.bar")))))
    "GET /foo HTTP/1.1")

(is (aeon:http-request-dump '((aeon:method . "GET")
                              (aeon:request-uri . "http://foo.bar/foo")
                              (aeon:version . "HTTP/1.1")
                              (aeon:headers . ((aeon:host . "foo.bar")))))
    (concat "GET /foo HTTP/1.1" aeon::*newline*
            "HOST: foo.bar" aeon::*newline* aeon::*newline*))

(finalize)
