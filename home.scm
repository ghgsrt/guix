(define-module (home)
  #:use-module (services)
  #:export (compose-home
  			bos-home-service-type))

(define (compose-home base . extensions)
	(home-environment
		(packages (append (home-environment-packages base)
						  (apply append (map home-environment-packages extensions))))
		(services (append (home-environment-services base)
						  (apply append (map home-environment-services extensions))))))

(define* (bos-home-service-type name #:key (packages '()) (env-vars '()))
	(service-type
		(name name)
		(description "A service type for home environments.")
		(extensions (append (if (null? packages) '() (list (service-extension home-profile-service-type
															(lambda (_) packages))))
						 	(if (null? env-vars) '() (list (service-extension home-environment-variables-service-type
															(lambda (_) env-vars))))))
		(default-value #f)))
