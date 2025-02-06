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

(define thinkpad-packages
	(cons tlp %ghg-desktop-packages))

(define %greetd-conf (string-append "/home/bosco/.guixos-sway/"
                                    "files/sway/sway-greetd.conf"))


(define (thinkpad-base-services)
	(append (modify-services %desktop-services 
(guix-service-type config => (guix-configuration (inherit config) (channels %guixos-channels)))
(delete gdm-service-type)
						(delete login-service-type)
						(delete mingetty-service-type))
 (list 
(service greetd-service-type
            (greetd-configuration
             (greeter-supplementary-groups '("video" "input" "users"))
             (terminals
              (list
               (greetd-terminal-configuration
                (terminal-vt "1")
                (terminal-switch #t)
                (default-session-command
                  ;; https://guix.gnu.org/manual/en/html_node/Base-Services.html
                  ;; issues.guix.gnu.org/65769
                  (greetd-wlgreet-sway-session
                   (sway-configuration
                    (local-file %greetd-conf
                                #:recursive? #t)))))
               (greetd-terminal-configuration
                (terminal-vt "2"))
               (greetd-terminal-configuration
                (terminal-vt "3"))
               (greetd-terminal-configuration
                (terminal-vt "4"))
               (greetd-terminal-configuration
                (terminal-vt "5"))
               (greetd-terminal-configuration
                (terminal-vt "6"))))))
;(service elogind-service-type)
(service guix-home-service-type
			`(("bosco" ,primary@minimal-home)))
		  (service tlp-service-type
			(tlp-configuration
				(cpu-boost-on-ac? #t)
				(wifi-pwr-on-bat? #t)))
		  (service bluetooth-service-type
			(bluetooth-configuration
				(auto-enable? #t))))))
(define-syntax thinkpad-services
	(identifier-syntax (thinkpad-base-services)))

(define thinkpad-os
	(operating-system
		(inherit %ghg-base-os)

		(host-name "thinkpad")
		(users (cons bosco-user
					(operating-system-users %ghg-base-os)))

		(kernel-arguments (append '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma")
								   (operating-system-kernel-arguments %ghg-base-os "/dev/disk/by-label/root")))
		(kernel-loadable-modules (list (@ (nongnu packages linux) broadcom-sta)))

 		(firmware (cons broadcom-bt-firmware
					   (operating-system-firmware %ghg-base-os)))

		(packages (append thinkpad-packages
						 (operating-system-packages %ghg-base-os)))
		(services (append thinkpad-services
			 	%ghg-base-services ))

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
