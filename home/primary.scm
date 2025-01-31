(define-module (home primary)
  #:use-module (home)
  #:use-module (home services desktop)
  #:use-module (home services terminals)
  #:use-module (home services shells)
  #:use-module (home services archive)
  #:use-module (packages)
  #:use-module (services)
  #:export (primary@minimal-home))

(define primary@minimal-home-service-type
	(ghg-home-service-type 'ghg-primary@minimal-home
		#:packages (list netsurf)
		#:env-vars '(("EDITOR" . "emacs")
				     ("VISUAL" . "emacs"))))

(define primary@minimal-home (compose-home
	(home-environment
		(services (append (list (service primary@minimal-home-service-type))
						  sway@minimal-services
						  foot-services
						  zsh-services
						  archive@minimal-services)))
	%ghg-base-home))
