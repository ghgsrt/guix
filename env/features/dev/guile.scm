(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-guile-feature))

(define (make-guile-feature)
	(make-feature
		#:name "guile"
		#:packages (list guile-fibers
						 guile-g-golf
						 guile-json-4
						 guile-uuid)))
