(define-module (home primary)
  #:use-module (home)
  #:use-module (home base)
  #:use-module (home services desktop)
  #:use-module (home services terminals)
  #:use-module (home services shells)
  #:use-module (home services archive)
  #:use-module (packages)
  #:use-module (services)
  #:export (primary@minimal-home))

(define primary@minimal-home-service-type
	(ghg-home-service-type 'ghg-primary@minimal-home
		#:packages (list netsurf zsh-antigen)
		#:env-vars '(("EDITOR" . "nano")
				     ("VISUAL" . "nano")
 			("HOME_NAME" . "primary")
			("SHELL" . "zsh"))))

(define primary@minimal-home
	(home-environment
		(services (append (list (service primary@minimal-home-service-type))
						  %ghg-base-home-services
						  sway@minimal-services
						  foot-services
						  zsh-services
						  archive@minimal-services))))
primary@minimal-home
