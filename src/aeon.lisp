(in-package #:aeon)


(defun start (address port)
  "Starts the socket server."
  (usocket:socket-server address
                         port
                         #'tcp-handler
                         nil
                         :multi-threading t
                         :in-new-thread t))

(defun tcp-handler (stream)
  "The main TCP handler."
  (declare (type stream stream))
  (proxy (http-request-parse-lines
          (loop for line = (read-line stream nil 'eof)
             until (or (eq line 'eof) (string= line ""))
             collect line))
         stream))

(defun proxy (req stream)
  (handler-case
      (let* ((socket (usocket:socket-connect (http-request-host req)
                                             (http-request-port req)))
             (socket-stream (usocket:socket-stream socket)))
        (write-sequence (http-request-dump req) socket-stream)
        (force-output socket-stream)
        (write-sequence (http-response-dump
                         (http-response-parse-lines
                          (loop for line = (read-line socket-stream nil 'eof)
                             until (eq line 'eof)
                             collect line)))
                        stream)
        (force-output stream)
        (usocket:socket-close socket))
    (usocket:ns-host-not-found-error () (write-sequence
                                         (http-response-dump (error-502))
                                         stream))
    (usocket:timeout-error () (write-sequence
                               (http-response-dump (error-504))
                               stream))
    (error () (write-sequence
               (http-response-dump (error-500))
               stream))))

(defun error-500 ()
  (http-response-set-status nil 500 "Internal Server Error"))

(defun error-502 ()
  (http-response-set-status nil 502 "Bad Gateway"))

(defun error-504 ()
  (http-response-set-status nil 504 "Gateway Timeout"))
