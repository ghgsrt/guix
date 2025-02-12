(define-module (system thinkpad)
  #:use-module (system base)
  #:use-module (services)
  #:use-module (packages)
  #:use-module (users)
  #:use-module (home primary)
  #:use-module (dotfiles guix channels)
  #:use-module (home services desktop)
  #:export (thinkpad-os
  			thinkpad-packages
			thinkpad-services))

(define thinkpad-packages (list 
;tlp
))



(define (thinkpad-base-services)
;	(list 
;(modify-services %desktop-services 
;(guix-service-type config => (guix-configuration (inherit config) (channels %guixos-channels)))
;(delete gdm-service-type)
;						(delete login-service-type)
;						(delete mingetty-service-type)
;)
 (list 
		;(service guix-home-service-type
	;		`(("bosco" ,primary@minimal-home)))
		  (service tlp-service-type
			(tlp-configuration
				(cpu-boost-on-ac? #t)
				(wifi-pwr-on-bat? #f)))
		  (service bluetooth-service-type
			(bluetooth-configuration
				(auto-enable? #t)))))
(define-syntax thinkpad-services
	(identifier-syntax (thinkpad-base-services)))

(define thinkpad-os
	(operating-system
		(inherit %bos-base-os)

		(host-name "thinkpad")
		(users (cons bosco-user
					(operating-system-users %bos-base-os)))

		(kernel-arguments (append '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma")
								   (operating-system-kernel-arguments %bos-base-os "/dev/disk/by-label/root")))
		(kernel-loadable-modules (list (@ (nongnu packages linux) broadcom-sta)))

 		(firmware (cons broadcom-bt-firmware
					   (operating-system-firmware %bos-base-os)))

		(packages (append thinkpad-packages
						 (operating-system-packages %bos-base-os)))
		(services (append thinkpad-services
			 	%bos-base-services ))

		(swap-devices (list (swap-space
							(target (uuid
										"07b04b86-97e2-40d2-a905-c25d25782e1e")))))
		(file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "474C-5E8A"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "f68a484e-ed0b-41b8-8d98-41ad6a88560d"
                                  'ext4))
                         (type "ext4"))
							%base-file-systems))))

(display "Loading THINKPAD-OS from module systems/thinkpad")

thinkpad-os
