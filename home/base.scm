(define-module (home base)
  #:use-module (services)
  #:use-module (home services manifest)
  #:use-module (home services dev)
  #:use-module (home services ssh)
  #:export (%bos-base-home
	    %bos-base-home-services))

(define %bos-base-home-services
	(append manifest-services
						  guile-services
						  ssh-services
						  (list
(simple-service 'meslo-fonts-service home-fontconfig-service-type
	(list "/config/dotfiles/fonts/MesloLGS"))
						  (service home-dotfiles-service-type
									(home-dotfiles-configuration
										(directories '("../dotfiles"))
										(excluded '(".bashrc"))))
								(simple-service 'bos-base-home-env-vars home-environment-variables-service-type
									`(("GUIX_LOCPATH" . "$HOME/.guix-profile/lib/locale")
									  ("PATH" . "$HOME/.local/bin:$PATH")
("BOS_HOME_PROFILE" . "$HOME/.guix-home/profile")
("BOS_HOME_TYPE" . "guix")
("BOS_HOME_NAME" . "base")
("BOS_CONFIG_DIR" . ,(car %load-path)))))))
; (define-syntax %bos-base-home-services
; 	(identifier-syntax (_%bos-base-home-services)))


(define %bos-base-home
	(home-environment
		(services %bos-base-home-services)))

%bos-base-home
