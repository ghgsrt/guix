(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (ssh-feature))

(define ssh-feature
  (feature "ssh"
    #:packages (list openssh)
    #:services (list (service home-openssh-service-type))))
	;(home-openssh-configuration
	 ;#:authorize-root? #f)))))
	 ;#:extra-config '((AddKeysToAgent . "yes")
	;		  (IdentityFile . "~/.ssh/id_ed25519"))))))))
	
