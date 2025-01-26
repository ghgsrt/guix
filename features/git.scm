(define-module (features git)
  #:use-module (features core)
  #:use-module (packages)
  #:use-module (services)
  #:export (git-feature))


(define git-feature
  (feature "git"
    #:packages (list git)))
  ;  #:services (list (service home-git-service-type
;	(home-git-configuration
;	 #:ignore-file '(".DS_Store"
;			 "*.swap"
;			 ".direnv/")
;	 #:config `((user
;			((name . "ghgsrt")
;			 (email ."ajbosco00@gmail.com")))
;		   (url
;			((format . "ssh")))
;		   (init
;			((defaultBranch . "master")))
;		   (push
;			((default . "current")))))))))
