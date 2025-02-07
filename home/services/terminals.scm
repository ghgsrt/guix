(define-module (home services terminals)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (foot-services))

;; ~~ FOOT ~~

(define foot-service-type
  (ghg-home-service-type 'ghg-foot
	#:packages (list foot)
	#:env-vars `(("TERMINAL" . "foot"))))

(define (_foot-services)
	(list (service foot-service-type)))
(define-syntax foot-services
	(identifier-syntax (_foot-services)))
