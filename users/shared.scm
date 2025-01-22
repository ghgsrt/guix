(define-module (users shared)
  #:use-module (services)
  #:use-module (packages)
  #:export (make-user-account))

(define* (make-user-account
          #:key name
          comment
          (group "users")
          home-directory
          (supplementary-groups '("wheel" "netdev" "audio" "video"))
          (home-config #f)
          (extra-groups '())
          (shell #f))
  "Create a user account with optional home configuration and customizable fields"
  (let ((base-account
         (user-account
          (name name)
          (comment comment)
          (group group)
          (home-directory (or home-directory (string-append "/home/" name)))
          (supplementary-groups
           (append supplementary-groups extra-groups))
          (shell shell))))
    (if home-config
        (user-account
         (inherit base-account)
         (home-directory (home-environment-directory home-config)))
        base-account)))
