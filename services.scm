(define-module (services))

;; List of modules to re-export
(define modules-to-reexport
  '((gnu services)
	(gnu services networking)
    (gnu services desktop)
    (gnu services audio)
    (gnu services shepherd)
    (gnu services dbus)
    (gnu services base)
    (gnu services xorg)
    (gnu services desktop)
    (gnu services configuration)
    (gnu services avahi)
    (gnu services nix)
    (gnu services xorg)
    (gnu services networking)
    (gnu services sound)
    (gnu services cups)
    (gnu services virtualization)
    (gnu services mcron)
    (gnu services pm)
	(gnu home)
  	(gnu home services)
	(gnu home services shells)
	(gnu home services ssh)
	(gnu home services gnupg)
	(gnu home services shepherd)
	(gnu home services sound)
	(gnu home services desktop)))

;; Load and re-export everything from each module
(for-each
 (lambda (module-name)
   (let ((mod (resolve-module module-name)))
     ;; Re-export all bindings from this module
     (module-for-each
      (lambda (name var)
        (module-re-export! (current-module) (list name)))
      (module-public-interface mod))))
 modules-to-reexport)