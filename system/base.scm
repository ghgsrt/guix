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
	(list 
(service guix-home-service-type
                        `(("root" ,primary@minimal-home)
			  ("bosco" ,primary@minimal-home)))

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
		(services (append %bos-base-services %base-services))

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
