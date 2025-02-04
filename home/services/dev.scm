(define-module (home services dev)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (guile-services))

;; ~~ GUILE ~~

(define guile-packages-service-type
	(ghg-home-service-type 'ghg-guile-packages
		#:packages (list guile-fibers
						guile-colorized
						 guile-g-golf
						 guile-json-4
						 guile-uuid)))

(define (_guile-services)
	(list (service guile-packages-service-type)))
(define-syntax guile-services
	(identifier-syntax (_guile-services)))
