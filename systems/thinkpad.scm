(define-module (systems thinkpad)
  #:use-module (systems shared)
  #:use-module (services)
  #:use-module (homes)
  #:use-module (gnu)
  #:use-module (nongnu packages linux)
  #:use-module (nongnu system linux-initrd))

(define-public thinkpad
	(operating-system
		(inherit base-os)
		(host-name "thinkpad")

		(kernel-arguments (append '("nohibernate")
						%default-kernel-arguments))
		(kernel-loadable-modules (list broadcom-sta))

		(users (cons (make-alex-account #:home-config (primary@minimal-home)) %base-user-accounts))

		(packages (append (list
							"tlp")
						(operating-system-packages base-os)))

		(services (append (list
							(service tlp-service-type)
							(service bluetooth-service-type
								(bluetooth-configuration (experimental #t)
														 (auto-enable? #t))))
						(operating-system-services base-os)))

		(bootloader (bootloader-configuration
						(bootloader grub-efi-bootloader)
						(targets (list "/boot/efi"))
						(keyboard-layout keyboard-layout)))
		(swap-devices (list (swap-space
							(target (uuid
										"ccfae056-c3b1-4e1a-b432-e81f9715ae6d")))))
		;; The list of file systems that get "mounted".  The unique
		;; file system identifiers there ("UUIDs") can be obtained
		;; by running 'blkid' in a terminal.
		(file-systems (cons* (file-system
								(mount-point "/home")
								(device (uuid
										"40e950a3-5484-49d6-a619-a397e2c57e26"
										'ext4))
								(type "ext4"))
							(file-system
								(mount-point "/")
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
								(type "vfat")) %base-file-systems))))
