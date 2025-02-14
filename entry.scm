;; File: /config/system/extension.scm
(use-modules (guix) (gnu)
             (ice-9 popen)   ; For command-line parsing (optional)
             (ice-9 rdelim)) ; For reading environment variables

;; Read the target from the TARGET environment variable
(define target (getenv "TARGET"))
(unless target
  (error "Environment variable 'TARGET' not set! Usage: TARGET=<name> guix system ..."))

;; Load the original OS configuration
(define base-os
  (load (string-append "/config/system/" target ".scm")))

;; Extend the OS configuration
(define extended-os
  (operating-system
    (inherit base-os)
    ;; Add your customizations here
   (services (modify-services (operating-system-services base-os)
							   (guix-service-type config =>
								 (guix-configuration
								   (inherit config)
								   (environment (append `(("BOS_DISTRO" . "guix")
														  ("BOS_SYSTEM" . ,target))
													   (guix-configuration-environment config)))))))))

;; Return the extended OS for Guix to use
extended-os