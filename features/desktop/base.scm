(define-module (features desktop base)
  #:use-module (features core)
  #:use-module (utils)
  #:use-module (packages)
  #:use-module (services)
  #:export (desktop-feature))

;(load "./core.scm")
(display dbus)
(newline)

(define desktop-feature
  (feature "desktop"
    #:packages (list
      shared-mime-info        ; XDG mime type handling
      xdg-utils              ; Basic XDG utilities
      xdg-dbus-proxy
      xdg-desktop-portal     ; Base portal implementation
      xdg-desktop-portal-gtk
      fontconfig             ; Font management is display server agnostic
      ;polkit-gnome          ; Authentication dialogs needed everywhere
      mesa)))                  ; 3D acceleration useful for any display server
   ; #:services (list )))
				;(dbus-configuration
				;	(services (list upower))))
			;(service upower-service-type)
			;(service seatd-service-type)
			;polkit-wheel-service
			;(service polkit-service-type)
			;(service dbus-root-service-type))))
      ;(service home-polkit-gnome-service-type
       ;        (home-polkit-gnome-configuration
        ;        (client polkit-gnome-authentication-agent-1))))))

;(load-dir "/config/features/desktop" #:recursive #f)

;(load-dir (string-append (dirname (current-filename)) "/desktop"))
;(load-dir (string-append (dirname (current-filename)) "/desktop/wayland"))
