(define-module (features desktop wayland base)
  #:use-module (features core)
  #:use-module (features desktop base)
  #:use-module (features desktop qt)
  #:use-module (utils)
  #:use-module (packages)
  #:use-module (services)
  #:export (wayland-feature wayland@incompat-feature))

(display "loading wayland")
;(load "../desktop.scm")

(define wayland@incompat-feature
  (feature "wayland@incompat"
	#:features (list desktop-feature qt-feature)
    #:packages (list
	qtwayland-5
;          wayland
	  wl-clipboard
	  wl-color-picker
	  rofi-wayland
      libxkbcommon
      mesa
	xdg-desktop-portal-wlr)
    #:env-vars `(("WAYLAND_DISPLAY" . "wayland-0")
				 ("XDG_SESSION_TYPE" . "wayland")
				 ("GDK_BACKEND" . "wayland")
				 ("GTK_IM_MODULE" . "wayland")
				 ("QT_IM_MODULE" . "wayland")
				 ("QT_QPA_PLATFORM" . "wayland")
				 ("QT_QPT_PLATFORM" . "wayland")
				 ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
				 ("SDL_VIDEODRIVER" . "wayland")
				 ("CLUTTER_BACKEND" . "wayland")
				 ("ELM_ENGINE" . "wayland-egl")
				 ("ECORE_EVAS_ENGINE" . "wayland-egl")
				 ("XMODIFIERS" . "@im=wayland")
				 ("XCURSOR_SIZE" . "24"))))

(define-public wayland-feature
  (feature "wayland"
    #:features (list wayland@incompat-feature)
    #:packages (list xorg-server-xwayland)))

;(load-dir "/config/features/desktop/wayland" #:recursive #f)
;(load-dir (string-append (dirname (current-filename)) "/wayland"))


