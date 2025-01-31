(define-module (system thinkpad)
  #:use-module (system)
  #:use-module (services)
  #:use-module (packages)
  #:use-module (users)
  #:use-module (home primary)
  #:export (thinkpad-os
  			thinkpad-packages
			thinkpad-services))

(define thinkpad-packages
	(list tlp))

(define (thinkpad-base-services)
	(list (guix-home-service-type
			`(("bosco" ,primary-home)))
		  (service tlp-service-type
			(tlp-configuration
				(cpu-boost-on-ac? #t)
				(wifi-pwr-on-bat? #t)))
		  (service bluetooth-service-type
			(bluetooth-configuration
				(auto-enable? #t)))))
(define-syntax thinkpad-services
	(identifier-syntax (thinkpad-base-services)))

(define thinkpad-os
	(operating-system
		(inherit %ghg-base-os)

		(host-name "thinkpad")
		(users (cons bosco-user
					(operating-system-users %ghg-base-os)))

		(kernel-arguments (append '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma")
								   (operating-system-kernel-arguments %ghg-base-os)))
		(kernel-loadable-modules (list (@ (nongnu packages linux) broadcom-sta)))

 		(firmware (cons broadcom-bt-firmware
					   (operating-system-firmware %ghg-base-os)))

		(packages (append thinkpad-packages
						 (operating-system-packages %ghg-base-os)))
		(services (append thinkpad-services
						 (operating-system-services %ghg-base-os)))

		(swap-devices (list (swap-space
							(target (uuid
										"ccfae056-c3b1-4e1a-b432-e81f9715ae6d")))))
		(file-systems (cons* (file-system
								(mount-point "/home")
								(device (uuid
										"40e950a3-5484-49d6-a619-a397e2c57e26"
										'ext4))
								(type "ext4"))
							(file-system
								(mount-point "/")
								(device (uuid
										"21d20a62-52b2-4492-b28d-d280634ac962"
										'ext4))
								(type "ext4"))
							(file-system
								(mount-point "/boot/efi")
								(device (uuid "474C-5E8A"
											'fat32))
								(type "vfat")
							%base-file-systems)))))

(display "Loading THINKPAD-OS from module systems/thinkpad")

thinkpad-os
