(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (wezterm-feature))

(define wezterm-feature
	(feature "wezterm"
		#:packages (list wezterm)
		#:env-vars `(
					("TERMINAL" . "wezterm")
					("TERM" . "xterm-256color"))))
