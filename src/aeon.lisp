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
  (setf (q+:stretch-last-section (q+:horizontal-header headers-list)) t))

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
  (let ((lines (cl-ppcre:split (concat '(#\Return #\Newline)) request)))
    (setf (q+:column-count headers-list) 2) ;; header / value
    (setf (q+:row-count headers-list) (- (length lines) 1))
    ;; First line is request line, ignore it
    (loop for i from 1 upto (- (length lines) 1)
       do (let* ((values (cl-ppcre:split ":" (elt lines i)))
                 (header (elt values 0))
                 (value (apply #'concat (rest values))))
            (setf (q+:item headers-list (- i 1) 0)
                  (q+:make-qtablewidgetitem header (q+:qtablewidgetitem.type)))
            (setf (q+:item headers-list (- i 1) 1)
                  (q+:make-qtablewidgetitem value (q+:qtablewidgetitem.type)))))))

(defun main ()
  (with-main-window (window (make-instance 'aeon))
    (setf *app* window)))
