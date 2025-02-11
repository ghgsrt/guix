(define-module (system base)
  #:use-module (gnu bootloader)
  #:use-module (gnu bootloader grub)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (home primary)
  #:use-module (dotfiles guix channels)
  #:export (%bos-base-os
			%bos-base-packages
			%bos-base-services))

(define %bos-base-packages
	(list git
		  tmux
		  curl
		  ripgrep
		  fd
		  tree
		  dstat
		  ncurses
		  openssl
		  net-tools
		  dconf-editor
		  coreutils))

(define %bos-base-services
	(cons* 
(service kmscon-service-type (kmscon-configuration 
(virtual-terminal "tty1")
(keyboard-layout (keyboard-layout "us" "basic"))))
(service kmscon-service-type
(kmscon-configuration
(virtual-terminal "tty2")))
(service kmscon-service-type
(kmscon-configuration
(virtual-terminal "tty3")))
(service kmscon-service-type
(kmscon-configuration
(virtual-terminal "tty4")))
(service kmscon-service-type
(kmscon-configuration
(virtual-terminal "tty5")))
(service kmscon-service-type
(kmscon-configuration
(virtual-terminal "tty6")))

;(virtual-terminal "tty3")
;(virtual-terminal "tty4")
;(virtual-terminal "tty5")
;(virtual-terminal "tty6")))
(service guix-home-service-type
                        `(("root" ,primary@minimal-home)
			  ("bosco" ,primary@minimal-home)))
 (modify-services %desktop-services
(guix-service-type config => (guix-configuration (inherit config)
(channels %guixos-channels)))
(delete gdm-service-type)
(delete mingetty-service-type))

;(service guix-service-type (guix-configuration (channels %guix-channels)))
;(service network-manager-service-type)
;		  (service wpa-supplicant-service-type)
;		  (service ntp-service-type)
))

(define %bos-base-os
	(operating-system
		(locale "en_US.utf8")
		(timezone "America/New_York")
		(keyboard-layout (keyboard-layout "us"))
		(host-name "guix")

		(kernel (@ (nongnu packages linux) linux))
		(initrd (@ (nongnu system linux-initrd) microcode-initrd))

		(firmware (append (list sof-firmware
							   (@ (nongnu packages linux) linux-firmware))
						   %base-firmware))
		
		(packages (append %bos-base-packages %base-packages))
		(services (append %bos-base-services 
			;	  (modify-services %desktop-services
;(guix-service-type config => (guix-configuration (inherit config) 
;(channels %guixos-channels)))
;(delete gdm-service-type))
;                                               (delete login-service-type)
;                                               (delete mingetty-service-type)
))

		(groups (cons (user-group (system? #t) (name "seat")) %base-groups))

		(sudoers-file (plain-file "sudoers"
					  (string-join '("root ALL=(ALL) NOPASSWD:ALL"
							 "%wheel ALL=(ALL) NOPASSWD:ALL")
							"\n")))

		;; Allow resolution of '.local' host names with mDNS
		(name-service-switch %mdns-host-lookup-nss)

		(bootloader (bootloader-configuration
						(bootloader grub-efi-bootloader)
						(targets (list "/boot/efi"))))

		(file-systems (cons (file-system
								(device (file-system-label "root"))
								(mount-point "/")
								(type "ext4"))
							%base-file-systems))))

(display "Loading BASE-OS from module system")
