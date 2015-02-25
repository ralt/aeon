(defpackage #:aeon
  (:use #:cl+qt)
  (:export
   ; response functions
   :http-response-set-status

   ; request functions
   :http-request-host
   :http-request-port
   :http-request-set-request-line
   :http-request-set-header
   :http-request-parse-lines
   :http-request-request-line
   :http-request-request-uri
   :http-request-dump

   ; response symbols
   :version
   :status
   :message

   ; request symbols
   :method
   :request-uri
   :headers
   :host
   :accept
   :accept-charset
   :accept-encoding
   :accept-language
   :accept-datetime
   :authorization
   :cache-control
   :connection
   :cookie
   :content-length
   :content-md5
   :content-type
   :date
   :expect
   :from
   :if-match
   :if-modified-since
   :max-forwards
   :origin
   :pragma
   :proxy-authorization
   :range
   :referer
   :te
   :user-agent
   :upgrade
   :via
   :warning))
