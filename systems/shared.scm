;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(define-module (systems shared)
	#:use-module (gnu)
    #:use-module (nongnu packages linux)
    #:use-module (nongnu packages firmware)
	#:use-module (nongnu system linux-initrd)
	#:use-module (gnu services networking)
	#:use-module (gnu services ssh)
	#:use-module (gnu services linux)
	#:export (base-operating-system))

(define base-os
  (locale "en_US.utf8")
  (timezone "America/New_York")
  (keyboard-layout (keyboard-layout "us"))
  (host-name "guix")

  (kernel linux)
  (initrd microcode-initrd)

  ;; Don't forget to add any necessary kernel-modules!

  (firmware (list sof-firmware linux-firmware))

  ;; The list of user accounts ('root' is implicit).
;   (users (cons* (user-account
;                   (name "bosco")
;                   (comment "Bosco")
;                   (group "users")
;                   (home-directory "/home/bosco")
;                   (supplementary-groups '("wheel" "netdev" "audio" "video")))
;                 %base-user-accounts))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
;   (packages (append (list
; 				  "tmux")
;   				%base-packages))


  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
        ; (append (
			list
                  ;; To configure OpenSSH, pass an 'openssh-configuration'
                  ;; record as a second argument to 'service' below.
                  (service openssh-service-type)
                  (service tor-service-type)
                  (service network-manager-service-type)
                  (service wpa-supplicant-service-type)
                  (service ntp-service-type))
                ; (modify-services %base-services
                ;   (guix-service-type config =>
                ;         (guix-configuration
                ;                 (inherit config)
                ;                 (substitute-urls
                ;                         (append (list "https://substitutes.nonguix.org")
                ;                                 %default-substitute-urls))
                ;                 (authorized-keys
                ;                         (append (list (local-file "./nonguix-signing-key.pub"))
                ;                                 %default-authorized-guix-keys)))))))
)
