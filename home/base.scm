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
						  (list 
(simple-service 'meslo-fonts-service home-fontconfig-service-type
	(list "/config/dotfiles/fonts/MesloLGS"))
				(service home-dotfiles-service-type
						  (list 
						  (service home-dotfiles-service-type
									(home-dotfiles-configuration
										(directories '("../dotfiles"))
										(excluded '(".bashrc"))))
										(directories '("../dotfiles")
										(excluded))))
								(simple-service 'ghg-base-home-env-vars home-environment-variables-service-type
									'(("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")
									  ("PATH" . "$HOME/.local/bin:$PATH"))))))
(define-syntax %ghg-base-home-services
	(identifier-syntax (_%ghg-base-home-services)))


(define %ghg-base-home
	(home-environment
		(services %ghg-base-home-services)))

%ghg-base-home
