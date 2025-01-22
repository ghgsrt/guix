(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-wayland-feature make-wayland@incompat-feature))

(define (make-wayland@incompat-feature)
  (make-feature
    #:name "wayland@incompat"
	#:features (list (make-desktop-feature))
    #:packages (list
      wayland
	  wl-clipboard
	  wl-color-picker
	  rofi-wayland
      libxkbcommon
      mesa
      fontconfig)
    #:env-vars `(("WAYLAND_DISPLAY" . "wayland-0")
				 ("XDG_SESSION_TYPE" . "wayland")
				 ("GDK_BACKEND" . "wayland")
				 ("GTK_IM_MODULE" . "wayland")
				 ("SDL_VIDEODRIVER" . "wayland")
				 ("QT_IM_MODULE" . "wayland")
				 ("QT_QPA_PLATFORM" . "wayland")
				 ("QT_QPT_PLATFORM" . "wayland")
				 ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
				 ("XMODIFIERS" . "@im=wayland")
				 ("XCURSOR_SIZE" . "24"))))

(define (make-wayland-feature)
  (make-feature
    #:name "wayland"
    #:features (list (make-wayland@incompat-feature))
    #:packages (list xorg-server-xwayland)))
