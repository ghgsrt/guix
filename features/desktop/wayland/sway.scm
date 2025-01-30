(define-module (features desktop wayland sway)
  #:use-module (features core)
  #:use-module (features desktop wayland base)
  #:use-module (packages)
  #:use-module (services)
  #:export (sway@minimal-feature
	    sway-feature
	    swayfx-ext
	    sway@minimal:fx-feature
	    sway:fx-feature))

(newline)
(display "whatup")
(newline)

;(load "../wayland.scm")

(define sway@minimal-feature
  (feature "sway@minimal"
    #:features (list wayland-feature)
    #:packages (list
;				sway
				swaylock
				swayidle
				;   lxsession
				mako
				swaybg)
	#:services (list (service home-sway-service-type))
	#:env-vars `(("XDG_CURRENT_DESKTOP" . "sway"))))

(define-public sway-feature
  (feature "sway"
	#:features (list sway@minimal-feature)
	#:packages (list
					fuzzel
					grim
					slurp
					waybar)))

(define-public swayfx-ext
  (feature "swayfx-ext"
;	#:packages (list swayfx)
;	#:excludes (excludes (packages (list sway)))
	; #:services (list (service home-sway-service-type
	; 					(sway-configuration (packages (list swayfx)))))
	#:modifies (list `(home-sway-service-type config =>
						(sway-configuration
							(inherit config)
							(packages (list swayfx)))))))

(define-public sway@minimal:fx-feature
  (feature "sway@minimal:fx"
	#:features (list sway@minimal-feature swayfx-ext)))

(define-public sway:fx-feature
  (feature "sway:fx"
	#:features (list sway-feature swayfx-ext)))

; (define (make-sway@minimal:nos-feature)
;   (feature "sway@minimal:nos"
;     #:features (list (make-wayland-feature))
;     #:packages (list
;       swaylock
;       swayidle
; 	;   lxsession
; 	  mako
; 	  swaybg)
;     #:env-vars `(("XDG_CURRENT_DESKTOP" . "sway"))))

; (define (make-sway@minimal-feature)
; 	(feature "sway@minimal"
; 	  #:features (list (make-sway@minimal:nos-feature))
; 	  #:packages (list sway)
; 	  #:services (list (service home-sway-service-type))))

; (define (make-sway:nos-feature)
;   (feature "sway:nos"
;     #:features (list (make-sway@minimal:nos-feature))
;     #:packages (list
;       fuzzel
;       grim
;       slurp
; 	  waybar)))

; (define (make-sway-feature)
; 	(feature "sway"
; 	  #:features (list (make-sway:nos-feature))
; 	  #:packages (list sway)
; 	  #:services (list (service home-sway-service-type))))

; (define (make-swayfx-feature)
; 	(feature "swayfx"
; 	  #:features (list (make-sway:nos-feature))
; 	  #:packages (list swayfx)
; 	  #:services (list
; 	  				(service home-sway-service-type
; 	  						(sway-configuration (packages (list swayfx)))))))
