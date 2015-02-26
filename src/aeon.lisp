(in-package #:aeon)
(named-readtables:in-readtable :qtools)


(defvar *app*)

(define-widget aeon (QWidget) ())

(define-subwidget (aeon start-button) (q+:make-qpushbutton "Start" aeon))

(define-subwidget (aeon filter-text) (q+:make-qlineedit aeon)
  (setf (q+:placeholder-text filter-text) "Filter domain..."))

(define-subwidget (aeon headers-list) (q+:make-qtablewidget aeon)
  (q+:hide (q+:horizontal-header headers-list))
  (q+:hide (q+:vertical-header headers-list))
  (setf (q+:stretch-last-section (q+:horizontal-header headers-list)) t)
  (setf (q+:resize-mode (q+:horizontal-header headers-list))
        (q+:qheaderview.resize-to-contents)))

(define-subwidget (aeon layout) (q+:make-qvboxlayout aeon)
  (setf (q+:window-title aeon) "Aeon")
  (let ((top-bar (q+:make-qhboxlayout)))
    (q+:add-widget top-bar start-button)
    (q+:add-widget top-bar filter-text)
    (q+:add-layout layout top-bar))
  (q+:add-widget layout headers-list))

(define-slot (aeon start) ()
  (declare (connected start-button (pressed)))
  (declare (connected filter-text (return-pressed)))
  (setf (q+:enabled start-button) nil)
  (setf (q+:text start-button) "Running...")
  (start "127.0.0.1" 25041))

(define-signal (aeon got-request) (string))

(define-slot (aeon got-request) ((request string))
  (declare (connected aeon (got-request string)))
  (let* ((lines (cl-ppcre:split (concat '(#\Newline)) request))
         (req (http-request-parse-lines lines)))
    (setf (q+:column-count headers-list) 3)
    (setf (q+:row-count headers-list) (- (length lines) 1))
    ;; First line is request line, handle it separately
    (setf (q+:item headers-list 0 0)
          (q+:make-qtablewidgetitem (rest (list-get-item 'method req))
                                    (q+:qtablewidgetitem.type)))
    (setf (q+:item headers-list 0 1)
          (q+:make-qtablewidgetitem (rest (list-get-item 'request-uri req))
                                    (q+:qtablewidgetitem.type)))
    (setf (q+:item headers-list 0 2)
          (q+:make-qtablewidgetitem (rest (list-get-item 'version req))
                                    (q+:qtablewidgetitem.type)))
    (loop for i from 1 upto (- (length lines) 1)
       do (let* ((values (cl-ppcre:split ":" (elt lines i)))
                 (header (elt values 0))
                 ; Remove the trailing #\Return
                 (tmp-value (apply #'concat (rest values)))
                 (value (subseq tmp-value 0 (- (length tmp-value) 1))))
            ; spans the 2nd column to 2 columns
            (setf (q+:span headers-list) (values i 1 1 2))
            (setf (q+:item headers-list i 0)
                  (q+:make-qtablewidgetitem header (q+:qtablewidgetitem.type)))
            (setf (q+:item headers-list i 1)
                  (q+:make-qtablewidgetitem value (q+:qtablewidgetitem.type)))))))

(defun main ()
  (with-main-window (window (make-instance 'aeon))
    (setf *app* window)))
