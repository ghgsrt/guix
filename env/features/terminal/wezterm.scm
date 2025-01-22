(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-wezterm-feature))

(define (make-wezterm-feature)
	(make-feature
		#:name "wezterm"
		#:packages (list wezterm)
		#:env-vars `(
					("TERMINAL" . "wezterm")
					("TERM" . "xterm-256color"))))
