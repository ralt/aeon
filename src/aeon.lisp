(in-package #:aeon)
(named-readtables:in-readtable :qtools)


(define-widget aeon (QWidget) ())

(define-subwidget (aeon start-button) (q+:make-qpushbutton)
  (setf (q+:text start-button) "Start"))

(define-subwidget (aeon filter-text) (q+:make-qlineedit)
  (setf (q+:placeholder-text filter-text) "Filter domain..."))

(define-subwidget (aeon headers-list) (q+:make-qtablewidget)
  (q+:hide (q+:horizontal-header headers-list))
  (q+:hide (q+:vertical-header headers-list))
  (setf (q+:column-count headers-list) 2)
  (setf (q+:row-count headers-list) 1)
  (setf (q+:stretch-last-section (q+:horizontal-header headers-list)) t)
  (setf (q+:item headers-list 0 0) (q+:make-qtablewidgetitem "Host" 0))
  (setf (q+:item headers-list 0 1) (q+:make-qtablewidgetitem "margaine.com" 0)))

(define-subwidget (aeon layout) (q+:make-qvboxlayout aeon)
  (setf (q+:window-title aeon) "Aeon")
  (let ((top-bar (q+:make-qhboxlayout)))
    (q+:add-widget top-bar start-button)
    (q+:add-widget top-bar filter-text)
    (q+:add-layout layout top-bar))
  (q+:add-widget layout headers-list))

(defun main ()
  (with-main-window (window (make-instance 'aeon))))
