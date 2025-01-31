(define-module (home services version-control)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (git-services))

;; ~~ GIT ~~

(define git-packages-service-type
	(ghg-home-service-type 'ghg-git-packages
		#:packages (list git)))

(define (_git-services)
	(list (service git-packages-service-type)))
(define-syntax git-services
	(identifier-syntax (_git-services)))
