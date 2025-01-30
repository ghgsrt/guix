;(load "/config/lib/path.scm")
;(use-modules (utils file-loader))

;(load-homes)
;(load "/config/systems/shared.scm")
(load "../systems.scm")

(define-module (systems thinkpad)
  #:use-module (gnu system file-systems)
  #:use-module (gnu packages firmware)
  #:use-module (nongnu packages linux)
  #:use-module (systems)
  #:use-module (services)
;  #:use-module (lib path)
;  #:use-module (homes)
  #:use-module (features)
;  #:use-module (features core)
  #:use-module (users)
  #:use-module (packages)
  #:export (thinkpad-os))


;(define bosco-user-config
;  (user-config
;   (account bosco-user)
;   (home primary@minimal-home)))

(define thinkpad-os-feature
  (feature "thinkpad-os"
	#:packages (list tlp)
	#:services (list (service tlp-service-type
				(tlp-configuration
					(cpu-boost-on-ac? #t)
					(wifi-pwr-on-bat? #t)))
			 (service bluetooth-service-type
				(bluetooth-configuration
					(auto-enable? #t))))))

(define thinkpad-os
	(feature->operating-system "thinkpad"
		#:feature thinkpad-os-feature
		#:users (list bosco-user)
		
 		#:firmware (list broadcom-bt-firmware)
		#:kernel-arguments '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma")
		#:kernel-loadable-modules (list (@ (nongnu packages linux) broadcom-sta))
		#:swap-devices (list (swap-space
							(target (uuid
										"ccfae056-c3b1-4e1a-b432-e81f9715ae6d"))))
		#:file-systems (list (file-system
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
								(type "vfat")))))

;(load-homes)
;(load-users)
;(load-dir "/config/systems")

(display "Loading THINKPAD-OS from module systems/thinkpad")

thinkpad-os

; (define thinkpad-os
; 	(operating-system
; 		(inherit base-os)
; 		(host-name "thinkpad")

; 		(kernel-arguments (append '("nohibernate")
; 						%default-kernel-arguments))
; 		(kernel-loadable-modules (list broadcom-sta))

; 		(users (cons 
; 			(make-alex-account 
; 			  #:home-config (feature->home-environment primary@minimal-home)) 
; 		       %base-user-accounts))

; 		(packages (append (list
; 							"tlp")
; 						(operating-system-packages base-os)))

; 		(services
; ; (append 
; (list
; 							(service tlp-service-type)
; 							(service bluetooth-service-type
; 								(bluetooth-configuration (experimental #t)
; 														 (auto-enable? #t))))
; )
; ;						(operating-system-services base-os)))

; 		(bootloader (bootloader-configuration
; 						(bootloader grub-efi-bootloader)
; 						(targets (list "/boot/efi"))))
; 		(swap-devices (list (swap-space
; 							(target (uuid
; 										"ccfae056-c3b1-4e1a-b432-e81f9715ae6d")))))
; 		;; The list of file systems that get "mounted".  The unique
; 		;; file system identifiers there ("UUIDs") can be obtained
; 		;; by running 'blkid' in a terminal.
; 		(file-systems (cons* (file-system
; 								(mount-point "/home")
; 								(device (uuid
; 										"40e950a3-5484-49d6-a619-a397e2c57e26"
; 										'ext4))
; 								(type "ext4"))
; 							(file-system
; 								(mount-point "/")
; 								(device (uuid
; 										"40e950a3-5484-49d6-a619-a397e2c57e26"
; 										'ext4))
; 								(type "ext4"))
; 							(file-system
; 								(mount-point "/")
; 								(device (uuid
; 										"21d20a62-52b2-4492-b28d-d280634ac962"
; 										'ext4))
; 								(type "ext4"))
; 							(file-system
; 								(mount-point "/boot/efi")
; 								(device (uuid "474C-5E8A"
; 											'fat32))
; 								(type "vfat")) %base-file-systems))))
