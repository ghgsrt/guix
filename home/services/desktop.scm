(define-module (home services desktop)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (%ghg-desktop-packages
		%ghg-desktop-services
  			qt-services
			kvantum-services
			wayland-services
			sway@minimal-services
			sway-services
			sway:fx-services))

;; ~~ Base ~~ -- NOTE: 'desktop-services' MUST be used directly on the OS, NOT ON A HOME ENV

(define %ghg-desktop-packages
		(list shared-mime-info
						 xdg-utils
						 xdg-dbus-proxy
						 xdg-desktop-portal
						 xdg-desktop-portal-gtk
						 fontconfig
						 (list glib "bin")))

(define (_desktop-services)
	(list 
(service elogind-service-type)
 
               fontconfig-file-system-service
        polkit-wheel-service
        (service polkit-service-type)
        (service dbus-root-service-type)
  		(service upower-service-type)
		(service x11-socket-directory-service-type)
))
(define-syntax %ghg-desktop-services
	(identifier-syntax (_desktop-services)))

;; ~~ QT ~~

(define qt-packages-service-type
	(ghg-home-service-type 'ghg-qt-packages
		#:packages (list qt5ct
						 qt5ct)
		#:env-vars `(("QT_QPA_PLATFORMTHEME" . "qt5ct")
					 ("QT_PLATFORMTHEME" . "qt5ct")
					 ("QT_AUTO_SCREEN_SCALE_FACTOR" . "1"))))

(define (_qt-services)
	(list (service qt-packages-service-type)))
(define-syntax qt-services
	(identifier-syntax (_qt-services)))

;; ~~ Kvantum ~~

(define kvantum-packages-service-type
	(ghg-home-service-type 'ghg-kvantum-packages
		#:packages (list kvantum)))

(define (_kvantum-services)
	(list (service kvantum-packages-service-type)))
(define-syntax kvantum-services
	(identifier-syntax (_kvantum-services)))

;; ~~ Wayland ~~

(define wayland-service-type
	(ghg-home-service-type 'ghg-wayland
		#:packages (list ;qtwayland-5
						;wayland
						egl-wayland
						 wl-clipboard
						 wl-color-picker
						 rofi-wayland
						 libxkbcommon
						 mesa
						 xdg-desktop-portal-wlr
						 xorg-server-xwayland)
    	#:env-vars `(
				 	 ("XDG_SESSION_TYPE" . "wayland")
					 ("GDK_BACKEND" . "wayland")
					 ("GTK_IM_MODULE" . "wayland")
					 ("QT_IM_MODULE" . "wayland")
					 ("QT_QPA_PLATFORM" . "wayland-egl")
					 ("QT_QPT_PLATFORM" . "wayland")
					 ("QT_WAYLAND_DISABLE_WINDOWDECORATION" . "1")
					 ("SDL_VIDEODRIVER" . "wayland")
					 ("CLUTTER_BACKEND" . "wayland")
					 ("ELM_ENGINE" . "wayland-egl")
					 ("ECORE_EVAS_ENGINE" . "wayland-egl")
					 ("XMODIFIERS" . "@im=wayland")
					 ("XCURSOR_SIZE" . "24"))))

(define (_wayland-services)
	(list (service wayland-service-type)))
(define-syntax wayland-services
	(identifier-syntax (_wayland-services)))

;; ~~ Sway ~~

;; Sway@minimal
(define sway@minimal-service-type
	(ghg-home-service-type 'ghg-sway@minimal
		#:packages (list swaylock
						 swayidle
						 mako
						 swaybg)
		#:env-vars `(("XDG_CURRENT_DESKTOP" . "sway"))))

(define (_sway@minimal-services)
	(append (list (service sway@minimal-service-type)
		  		  (service home-sway-service-type))
		  	wayland-services))
(define-syntax sway@minimal-services
	(identifier-syntax (_sway@minimal-services)))

;; Sway
(define sway-service-type
	(ghg-home-service-type 'ghg-sway
		#:packages (list fuzzel
						 grim
						 slurp
						 waybar)))

(define (_sway-services)
	(cons (service sway-service-type)
		  (sway@minimal-services)))
(define-syntax sway-services
	(identifier-syntax (_sway-services)))

;(display sway-services)

;; Sway:fx
;(define (sway:fx-services)
;	(modify-services sway-services
;					 (list (home-sway-service-type config =>
;							(sway-configuration
;								(inherit config)
;								(packages (list swayfx)))))))
;(define-syntax sway:fx-services
;	(identifier-syntax (sway:fx-services)))
