#lang racket
(require racket/gui/base)

(define thd (thread (λ () (sleep 1))))

(define modern-font (make-object font% 64.0 'modern))

(define W 360)

(define frame
  (new (class frame% (super-new)
         (define/augment (on-close)
           (when (thread-running? thd) (kill-thread thd))))
       [label "reaction time"]
       [width W]))

(define text-field (new text-field% [parent frame]
                        [label ""]
                        [font modern-font]
                        [init-value ""]))1

(define panel (new horizontal-panel% [parent frame]))

(new button% [parent panel]
     [label "start"]
     [callback
      (λ (btn evt)
        (let* ((void (send text-field set-value "Ready..."))
               (wait-for (sleep/yield (+ 1 (* 3 (random)))))
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
     [label "stop"]
     [callback
      (λ (btn evt)
        (if (thread-running? thd)
            (thread-suspend thd)
            (begin
              (send text-field set-value "too early"))))])

(send frame show #t)
