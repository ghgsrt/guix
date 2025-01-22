(define-module (users alex)
  #:use-module (users shared)
  #:export (make-alex-account))

(define* (make-alex-account #:key (home-config #f))
  (make-user-account
   #:name "alex"
   #:comment "Alex Bosco"
   #:home-config home-config))