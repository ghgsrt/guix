
;(load "/config/features.scm")
(define-module (homes primary)
  #:use-module (homes base)
  #:use-module (packages)
  #:use-module (services)
  ;#:use-module (features core)
  #:use-module (features)
;  #:use-module (features archive)
;  #:use-module (features desktop wayland sway) 
 ; #:use-module (features desktop wayland)
  #:export (primary@minimal-home
			primary-home))

;(load "../features/archive.scm")
;(display "loading features")
;(newline)
;(load "../features.scm")
;(display "loaded features")
;(newline)

(define primary@minimal-home-feature
	(feature "primary@minimal-home"
		#:features (list ; sway@minimal-feature
;						 qt-feature
						 ;(wezterm-feature)
						 foot-feature
						 zsh-feature
						 archive@minimal-feature)
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
		#:features (list primary@minimal-home-feature
						 sway-feature
						 archive-feature)
		#:packages (list "neovim"
						 "docker-compose")))
(define primary-home
	(feature->home-environment primary-home-feature))

primary@minimal-home

;(display primary@minimal-home)
