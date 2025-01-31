(define-module (home services ssh)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (ssh-services))

(define ssh-packages-service-type
  (ghg-home-service-type 'ghg-ssh-packages
	#:packages (list openssh)))

(define (_ssh-services)
  (list (service ssh-packages-service-type)
		(service home-openssh-service-type)))
(define-syntax ssh-services
	(identifier-syntax (_ssh-services)))
