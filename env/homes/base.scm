;(load "/config/lib/path.scm")
;(use-modules (utils file-loader))
;(load-modules 'packages 'services 'features)

(define-module (homes)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (features)
  #:export (make-base-home-feature
primary@minimal-home
                        primary-home
                        make-primary-home))

(define (make-base-home-feature)
  (make-feature
   #:name "base-home"
   #:features (list (make-manifest-feature) 
		    (make-guile-feature)
		    (make-git-feature)
		    (make-ssh-feature))
   #:packages (list
				curl
				tmux
				ripgrep
				fd
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


(define primary@minimal-home
         (make-feature
                #:name "primary@minimal-home"
                #:features (list (make-sway@minimal-feature)
                                                 (make-qt-feature)
                                                 ;(make-wezterm-feature)
                                                 (make-foot-feature)
                                                 (make-zsh-feature)
                                                 (make-archive@minimal-feature))
                #:packages (list netsurf)
                #:env-vars '(
                                        ("EDITOR" . "emacs")
                                        ("VISUAL" . "emacs"))))

;(define primary@minimal-home
;'())
 ; (make-primary@minimal-home-feature))

(define (make-primary-home-feature)
  (make-feature
   #:name "primary-home"
   #:features (list (make-primary@minimal-home-feature)
                                        (make-sway-feature)
                                        (make-archive-feature))
   #:packages (list "neovim"
                                        "docker-compose")))

(define primary-home
'()) ;  (make-primary-home-feature))

