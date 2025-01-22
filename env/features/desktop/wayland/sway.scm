(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-swayfx-feature
			make-sway-feature
			make-sway@minimal-feature))

(define (make-sway@minimal:nos-feature)
  (make-feature
    #:name "sway@minimal:nos"
    #:features (list (make-wayland-feature))
    #:packages (list
      swaylock
      swayidle
	;   lxsession
	  mako
	  swaybg)
    #:env-vars `(("XDG_CURRENT_DESKTOP" . "sway"))))

(define (make-sway@minimal-feature)
	(make-feature
	  #:name "sway@minimal")
	  #:features (list (make-sway@minimal:nos-feature))
	  #:packages (list sway)
	  #:services (list (service home-sway-service-type)))

(define (make-sway:nos-feature)
  (make-feature
    #:name "sway:nos"
    #:features (list (make-sway@minimal:nos-feature))
    #:packages (list
      fuzzel
      grim
      slurp
	  waybar)))

(define (make-sway-feature)
	(make-feature
	  #:name "sway")
	  #:features (list (make-sway:nos-feature))
	  #:packages (list sway)
	  #:services (list (service home-sway-service-type)))

(define (make-swayfx-feature)
	(make-feature
	  #:name "swayfx"
	  #:features (list (make-sway:nos-feature))
	  #:packages (list swayfx)
	  #:services (list
	  				(service home-sway-service-type
	  						(sway-configuration (packages (list swayfx)))))))
