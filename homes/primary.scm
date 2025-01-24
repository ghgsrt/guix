(define-module (homes)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (features)
  #:export (primary@minimal-home
			primary-home))


(define primary@minimal-home-feature
	(feature "primary@minimal-home"
		#:features (list (sway@minimal-feature)
						 (qt-feature)
						 ;(wezterm-feature)
						 (foot-feature)
						 (zsh-feature)
						 (archive@minimal-feature))
		#:packages (list netsurf)
		#:env-vars '(("EDITOR" . "emacs")
				     ("VISUAL" . "emacs"))))
(define primary@minimal-home
	(feature->home-environment primary@minimal-home-feature))

;(define primary@minimal-home
;'())
 ; (primary@minimal-home-feature))

(define primary-home-feature
	(feature "primary-home"
		#:features (list (primary@minimal-home-feature)
						 (sway-feature)
						 (archive-feature))
		#:packages (list "neovim"
						 "docker-compose"))
(define primary-home
	(feature->home-environment primary-home-feature))
