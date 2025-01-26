(define-module (features terminal foot)
  #:use-module (features core)
  #:use-module (packages)
  #:use-module (services)
  #:export (foot-feature))

(define foot-feature
	(feature "foot"
		#:packages (list foot)
		#:env-vars `(
					("TERMINAL" . "foot")
					("TERM" . "foot"))))
