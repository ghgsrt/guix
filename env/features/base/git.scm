(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-git-feature))


(define (make-git-feature)
  (make-feature
    #:name "git"
    #:packages (list git)
    #:services (list (service home-git-service-type
	(home-git-configuration
	 #:ignore-file '(".DS_Store"
			 "*.swap"
			 ".direnv/")
	 #:config `((user
			((name . "ghgsrt")
			 (email ."ajbosco00@gmail.com")))
		   (url
			((format . "ssh")))
		   (init
			((defaultBranch . "master")))
		   (push
			((default . "current")))))))
