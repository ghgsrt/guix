(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-ssh-feature))

(define (make-ssh-feature)
  (make-feature
    #:name "ssh"
    #:packages (list openssh)
    #:services (list (service home-openssh-service-type
	(home-openssh-configuration
	 #:authorize-root? #f
	 #:extra-config '((AddKeysToAgent . "yes")
			  (IdentityFile . "~/.ssh/id_ed25519"))))))
	
