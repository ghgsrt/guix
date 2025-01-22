(define-module (homes)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (features)
  #:export (primary@minimal-home
  			make-primary@minimal-home-feature
			primary-home
			make-primary-home-feature))

(define (make-primary@minimal-home-feature)
	(make-feature
		#:name "primary@minimal-home"
		#:features (list (make-sway@minimal-feature)
						 (make-qt-feature)
						 (make-wezterm-feature)
						 (make-foot-feature)
						 (make-zsh-feature)
						 (make-archive@minimal-feature))
		#:packages (list netsurf)
		#:env-vars `(
					("EDITOR" . "emacs")
					("VISUAL" . "emacs"))))

(define primary@minimal-home
  (make-primary@minimal-home-feature))

(define (make-primary-home-feature)
  (make-feature
   #:name "primary-home"
   #:features (list (make-primary@minimal-home-feature)
   					(make-sway-feature)
					(make-archive-feature))
   #:packages (list "neovim"
					"docker-compose")))

(define primary-home
  (make-primary-home-feature))
