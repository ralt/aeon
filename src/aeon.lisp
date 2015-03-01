(in-package #:aeon)
(named-readtables:in-readtable :qtools)


(defvar *app*)

(define-widget aeon (QWidget) ())

(define-subwidget (aeon start-button) (q+:make-qpushbutton "Start" aeon))

(define-subwidget (aeon filter-text) (q+:make-qlineedit aeon)
  (setf (q+:placeholder-text filter-text) "Filter domain..."))

(define-subwidget (aeon headers-list) (q+:make-qtablewidget aeon)
  (q+:hide (q+:vertical-header headers-list))
  (setf (q+:show-grid headers-list) nil)
  (setf (q+:column-count headers-list) 3)
  (setf (q+:horizontal-header-labels headers-list) '("Method" "Host" "Request URI"))
  (setf (q+:selection-behavior headers-list) (q+:qabstractitemview.select-rows))
  (setf (q+:stretch-last-section (q+:horizontal-header headers-list)) t)
  (setf (q+:resize-mode (q+:horizontal-header headers-list))
        (q+:qheaderview.resize-to-contents)))

(define-subwidget (aeon layout) (q+:make-qvboxlayout aeon)
  (setf (q+:window-title aeon) "Aeon")
  (let ((top-bar (q+:make-qhboxlayout aeon)))
    (q+:add-widget top-bar start-button)
    (q+:add-widget top-bar filter-text)
    (q+:add-layout layout top-bar))
  (q+:add-widget layout headers-list))

(define-slot (aeon start) ()
  (declare (connected start-button (pressed)))
  (declare (connected filter-text (return-pressed)))
  (setf (q+:enabled start-button) nil)
  (setf (q+:text start-button) "Running...")
  (start "127.0.0.1" 2504))

(define-signal (aeon got-request) (int))

(define-slot (aeon got-request) ((request-id int))
  (declare (connected aeon (got-request int)))
  (let* ((req-hash (gethash request-id *requests*))
         (request (getf req-hash :request))
         (lines (cl-ppcre:split (concat '(#\Newline)) request))
         (req (http-request-parse-lines lines))
         (row-count (q+:row-count headers-list)))
    (when req
      (setf (q+:row-count headers-list) (1+ (q+:row-count headers-list)))
      (setf (q+:item headers-list row-count 0)
            (q+:make-qtablewidgetitem (http-request-method req)
                                      (q+:qtablewidgetitem.type)))
      (setf (q+:item headers-list row-count 1)
            (q+:make-qtablewidgetitem (http-request-host req)
                                      (q+:qtablewidgetitem.type)))
      (setf (q+:item headers-list row-count 2)
            (q+:make-qtablewidgetitem (http-request-request-uri req)
                                      (q+:qtablewidgetitem.type))))))

(define-slot (aeon open-request) ((row int) (column int))
  (declare (connected headers-list (cell-clicked int int)))
  (declare (ignore column)) ; only interested in the row
  (when (= (q+:count layout) 3) ; until we have a "center" layout...
    (finalize (q+:take-at layout 2)))
  (q+:add-widget layout (make-tabwidget aeon
                                        (request-from-string
                                         (getf
                                          (gethash (1+ row) *requests*)
                                          :request)))))

(defun make-tabwidget (aeon req)
  (let* ((tabs-widget (q+:make-qtabwidget aeon))
         (headers (rest (list-get-item 'headers req)))
         (table (q+:make-qtablewidget (length headers) 2 aeon)))
    (q+:hide (q+:vertical-header table))
    (q+:hide (q+:horizontal-header table))
    (setf (q+:stretch-last-section (q+:horizontal-header table)) t)
    (setf (q+:resize-mode (q+:horizontal-header table))
          (q+:qheaderview.resize-to-contents))
    (loop for i from 0 upto (- (length headers) 1)
       do (progn
            (setf (q+:item table i 0)
                  (q+:make-qtablewidgetitem (string-capitalize
                                             (symbol-name (first (elt headers i))))
                                            (q+:qtablewidgetitem.type)))
            (setf (q+:item table i 1)
                  (q+:make-qtablewidgetitem (rest (elt headers i))
                                            (q+:qtablewidgetitem.type)))))
    (q+:add-tab tabs-widget table "Request headers")
    tabs-widget))

(defun request-from-string (str)
  (http-request-parse-lines (cl-ppcre:split (concat '(#\Newline)) str)))

(defun main ()
  (with-main-window (window (make-instance 'aeon))
    (setf *app* window)))

(defun main-debug ()
  (bt:make-thread #'(lambda ()
                      (main))
                  :name "Aeon GUI"))
