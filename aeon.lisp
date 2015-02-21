(in-package #:aeon)


(defconstant newline "")

(defun start (address port)
  "Starts the socket server."
  (usocket:socket-server address
                         port
                         #'tcp-handler
                         nil
                         :multi-threading t
                         :in-new-thread t))

(defun tcp-handler (stream &key (request "") host)
  "The main TCP handler."
  (declare (type stream stream))
  (let* ((line (read-line stream nil nil))
         (request-buffer (concatenate 'string request line))
         (host-scanner (cl-ppcre:create-scanner "^Host\\s*:\\s*(.*)"
                                                :case-insensitive-mode t)))
    ;; Request is finished
    (when (string= line newline)
      (log4cl:log-info request-buffer)
      (log4cl:log-info host)
      (return-from tcp-handler))

    ;; Get the host from the Host header
    (multiple-value-bind (present-p matches)
        (cl-ppcre:scan-to-strings host-scanner line)
      (when present-p
        (setf host (cl-ppcre:split ":" (elt matches 0)))))

    ;; Recursion!
    (tcp-handler stream :request request-buffer :host host)))
