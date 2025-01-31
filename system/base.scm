(define-module (system base)
  #:use-module (packages)
  #:use-module (services)
  #:export (%ghg-base-os
			%ghg-base-packages
			%ghg-base-services))

(define %ghg-base-packages
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

(define %ghg-base-services
	(list (service network-manager-service-type)
		  (service wpa-supplicant-service-type)
		  (service ntp-service-type)))

(define %ghg-base-os
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

		(packages (append %ghg-base-packages %base-packages))
		(services (append %ghg-base-services %base-services))

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
