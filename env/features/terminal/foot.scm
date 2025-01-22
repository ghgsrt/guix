(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-foot-feature))

(define (make-foot-feature)
	(make-feature
		#:name "foot"
		#:packages (list foot)
		#:env-vars `(
					("TERMINAL" . "foot")
					("TERM" . "foot"))))
