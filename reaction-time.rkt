#lang racket
(require racket/gui/base)

(define thd (thread (λ () (sleep 1))))

;; Sounds
(define pin
  (first
   (filter file-exists?
           '("pin.aiff" "/System/Library/Sounds/Tink.aiff"))))

(define modern-font (make-object font% 64.0 'modern))

(define W 360)

(define frame
  (new (class frame% (super-new)
         (define/augment (on-close)
           (stop)))
         [label "reaction time"]
         [width W]
         ))

(define text-field (new text-field% [parent frame]
                        [label ""]
                        [font modern-font]
                        [init-value ""]))1

(define panel (new horizontal-panel% [parent frame]))

(define pad0
  (λ (n)
    (if (< n 10)
        (string-append "0" (number->string n))
        (number->string n))))


(define start
  (λ ()
    (let* ((wait-for (sleep/yield (* 10 (random))))
           (start-at (current-milliseconds)))
      (when (thread-running? thd) (kill-thread thd))
      (set! thd (thread
                 (λ ()
                   (let loop ()
                     (send text-field set-value
                           (number->string
                            (/ (- (current-milliseconds) start-at) 1000.0)))
                     (sleep/yield 0.01)
                     (loop))))))))

(define stop
  (λ ()
    (when (thread-running? thd) (thread-suspend thd))))

(new button% [parent panel]
     [label "set"]
     [callback
      (λ (btn evt)
        (let* ((void (send text-field set-value "Ready..."))
               (wait-for (sleep/yield (* 5 (random))))
               (start-at (current-milliseconds)))
          (when (thread-running? thd) (thread-suspend thd))
          (set! thd (thread
            (λ ()
              (let loop ()
                (send text-field set-value
                      (number->string
                       (- (current-milliseconds) start-at)))
                (sleep/yield 0.01)
                (loop)))))))])

(new button% [parent panel]
     [label "go"]
     [callback
      (λ (btn evt)
        (if (thread-running? thd)
            (thread-suspend thd)
            (begin
              (kill-thread thd)
              (send text-field set-value "too early"))))])

(send frame show #t)
