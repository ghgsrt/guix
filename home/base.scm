(define-module (home base)
  #:use-module (services)
  #:use-module (home services manifest)
  #:use-module (home services dev)
  #:use-module (home services ssh)
  #:export (%ghg-base-home
	    %ghg-base-home-services))

(define %dotfiles "../dotfiles")

(define (dot-file target)
	"Resolve the local config file."
	(local-file (string-append %dotfiles "/" target) #:recursive? #t))

;; have to do this instead of home-dotfiles-service-type because trying to use certain service-types
;; like bash will, unfortunately, cause a duplication conflict with their configs
;; unless I'm just missing something
(define (home-xdg-files _config)
	"Map any config files which are not already handled by their own relevant serive (e.g., bashrc)"
	`(("guix/channels.scm" ,(dot-file "guix/channels.scm")
	  ())))

(define (_%ghg-base-home-services)
	(append manifest-services
						  guile-services
						  ssh-services
						  (list 
						  (service home-dotfiles-service-type
									(home-dotfiles-configuration
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
