(define-module (systems)
  #:use-module (gnu system)
  #:use-module (gnu system file-systems)
  #:use-module (gnu system keyboard)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
 ; #:use-module (utils)
 ; #:use-module (users)
  #:use-module (packages)
  #:use-module (services)
 ; #:use-module (features)
  #:use-module (features core)
  #:use-module (features git)
  #:use-module (features ssh)
;  #:use-module (homes)
  #:use-module (guix records)
  #:export (%base-os
  			%base-os-feature
			feature->operating-system
			user-config))

;(load "../features.scm")

(define %base-os-feature
  (feature "base-os"
    #:features (list git-feature ssh-feature)
    #:packages (list 			 tmux
					 coreutils)
  	#:services (list (service network-manager-service-type)
                 	 (service wpa-supplicant-service-type)
                 	 (service ntp-service-type))))

(define %base-os
  (operating-system
    (locale "en_US.utf8")
    (timezone "America/New_York")
    (keyboard-layout (keyboard-layout "us"))
    (host-name "guix")

    (kernel linux)
    (initrd microcode-initrd)

    ;; Don't forget to add any necessary kernel-modules!

    (firmware (append (list sof-firmware linux-firmware) %base-firmware))


    (bootloader (bootloader-configuration
					(bootloader grub-efi-bootloader)
					(targets (list "/boot/efi"))))

    (file-systems (cons (file-system
			  (device (file-system-label "root"))
			  (mount-point "/")
			  (type "ext4"))
		   %base-file-systems))))

(define-record-type* <user-config> user-config make-user-config
  user-config?
  (account     user-config-account)
  (home user-config-home
                (default #f)))  ; Default to no home environment

(define* (feature->operating-system name
                                  #:key
								  (feature '())
                                  (base-os %base-os)
                                  (base-feature %base-os-feature)
                                  (users '())     
                                 ; (extra-homes '())
								  (firmware '())
								  (swap-devices '())
								  (file-systems '())
								  (kernel-loadable-modules '())
								  (kernel-arguments '()))  ; List of standalone home environments
  (let ((merged-feature (if feature
  							(merge-features base-feature feature)
							 base-feature)))
         ;; Create home services for users with home features
        ; (user-home-services
         ;  (map (lambda (user)
          ;              (let ((user-home (user-config-home user))
	;						  (user-name (user-account-name
         ;                                       (user-config-account user))))
          ;                     (simple-service (string-append user-name "-home") guix-home-service-type
           ;                            (if user-home
	;								   `((,user-name ,user-home))
	;								   `((,user-name ,%base-home))))))
;                      users)))
    (operating-system
	  (inherit base-os)
	  (host-name name)
      (packages (append
	  		(feature-packages merged-feature)
			%base-packages))
      (services
        (append
	;	  (service guix-home-service-type `(("root" ,%base-home)))
         ; user-home-services
          (feature-services merged-feature)
		  %base-services))
      (users (append users %base-user-accounts))
	  (firmware (append firmware (operating-system-firmware base-os)))
	  (swap-devices swap-devices)
	  (file-systems (append file-systems %base-file-systems))
	  (kernel-loadable-modules kernel-loadable-modules)
	  (kernel-arguments (append kernel-arguments %default-kernel-arguments)))))


;(load-systems)
