(define-module (home base)
  #:use-module (services)
  #:use-module (home services manifest)
  #:use-module (home services dev)
  #:use-module (home services ssh)
  #:export (%ghg-base-home
	    %ghg-base-home-services))

(define (_%ghg-base-home-services)
	(append manifest-services
						  guile-services
						  ssh-services
						  (list (service home-dotfiles-service-type
									(home-dotfiles-configuration
										(directories '("../dotfiles"))))
								(simple-service 'ghg-base-home-env-vars home-environment-variables-service-type
									'(("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")
									  ("PATH" . "$HOME/.local/bin:$PATH"))))))
(define-syntax %ghg-base-home-services
	(identifier-syntax (_%ghg-base-home-services)))


(define %ghg-base-home
	(home-environment
		(services %ghg-base-home-services)))

%ghg-base-home
