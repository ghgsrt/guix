(define-module (homes base)
  #:use-module (utils)
  #:use-module (features)
;  #:use-module (features core)
  #:use-module (packages)
  #:use-module (services)
  #:export (%base-home-feature
			feature->home-environment))

(define %base-home-feature
  (feature "base-home"
   #:features (list manifest-feature
					guile-feature
					git-feature
					ssh-feature)
   #:packages (list curl
					ripgrep
					fd
					tree
					gcc
					dstat)
   #:services (list (service home-dotfiles-service-type
						(home-dotfiles-configuration
						(directories '("../../dotfiles")))))
   #:env-vars '(("GUIX_PACKAGE_PATH" . "/config")
				("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")
				("PATH" . "$HOME/.local/bin:$PATH")
				("LESS" . "-R")  ; Enable color output in less
				("PAGER" . "less"))))

(define* (feature->home-environment home-feature
                                  #:key
                                  (base-home-feature %base-home-feature)
                                  (user #f)
                                  (home-directory #f))
  (let* ((merged-feature (merge-features base-home-feature home-feature))
         (env-vars (feature-env-vars merged-feature))
         (base-services (feature-services merged-feature))
         (services (if (null? env-vars)
                      base-services
                      (cons (simple-service 'home-env-vars-service home-environment-variables-service-type
                                   env-vars)
                            base-services))))
    (home-environment
      (packages (feature-packages merged-feature))
      (services services))))
;      (home-directory (or home-directory
;						  (if user (string-append "/home/" user) "/"))))))
;(load-homes)
