(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-desktop-feature))

(display dbus)

(define (make-desktop-feature)
  (make-feature
    #:name "desktop"
    #:packages (list
      dbus
      shared-mime-info        ; XDG mime type handling
      xdg-utils              ; Basic XDG utilities
      xdg-desktop-portal     ; Base portal implementation
;	  xdg-desktop-gtk
      fontconfig             ; Font management is display server agnostic
      polkit-gnome          ; Authentication dialogs needed everywhere
      mesa)                  ; 3D acceleration useful for any display server
    #:services (list
      (service home-dbus-service-type))))
      ;(service home-polkit-gnome-service-type
       ;        (home-polkit-gnome-configuration
        ;        (client polkit-gnome-authentication-agent-1))))))
