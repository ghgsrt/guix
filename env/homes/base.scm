(define-module (homes)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (features)
  #:export (make-base-home-feature))

(define (make-base-home-feature)
  (make-feature
   #:name "base-home"
   #:features (list (make-manifest-feature make-guile-feature))
   #:packages (list
				git
				curl
				tmux
				ripgrep
				fd-find
				tree
				gcc
				coreutils
				dstat)
   #:services (list (service home-dotfiles-service-type
					(home-dotfiles-configuration
					 (directories '("../../dotfiles")))))
   #:env-vars '(("GUIX_PACKAGE_PATH" . "/config")
				("GUIX_LOCPATH" . "$home/.guix-profile/lib/locale")
				("PATH" . "$HOME/.local/bin:$PATH")
				("LESS" . "-R")  ; Enable color output in less
				("PAGER" . "less"))))