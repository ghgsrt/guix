(define-module (features dev guile)
  #:use-module (features core)
  #:use-module (packages)
  #:use-module (services)
  #:export (guile-feature))

(define guile-feature
	(feature "guile"
		#:packages (list guile-fibers
						 guile-g-golf
						 guile-json-4
						 guile-uuid)))
