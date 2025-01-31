(define-module (home)
  #:use-module (services)
  #:use-module (home services manifest)
  #:use-module (home services dev)
  #:use-module (home services ssh)
  #:export (compose-home
  			ghg-home-service-type
			%ghg-base-home))

(define (compose-home base . extensions)
	(home-environment
		(packages (append (home-environment-packages base)
						  (apply append (map home-environment-packages extensions))))
		(services (append (home-environment-services base)
						  (apply append (map home-environment-services extensions))))))

(define* (ghg-home-service-type name #:key (packages '()) (env-vars '()))
	(service-type
		(name name)
		(extensions (append (if (null? packages) '() (list (service-extension home-profile-service-type
															(lambda (_) packages))))
						 	(if (null? env-vars) '() (list (service-extension home-environment-services-service-type
															(lambda (_) env-vars))))))
		(default-value #f)))

(define %ghg-base-home
	(home-environment
		(services (append manifest-services
						  guile-services
						  ssh-services
						  (list (service home-dotfiles-service-type
									(home-dotfiles-configuration
										(directories '("../dotfiles"))))
								(simple-service 'ghg-base-home-env-vars home-environment-variables-service-type
									'(("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")
									  ("PATH" . "$HOME/.local/bin:$PATH"))))))))
