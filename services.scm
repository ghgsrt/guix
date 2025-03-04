v(define-module (services))

;; Service facade

(use-modules (gnu services)
			 (gnu services networking)
			 (gnu services desktop)
			 (gnu services audio)
			 (gnu services shepherd)
			 (gnu services dbus)
			 (gnu services base)
			 (gnu services ssh)
			 (gnu services docker)
			 (gnu services containers)
			 (gnu services cgit)
			 (gnu services ci)
			 (gnu services version-control)
			 (gnu services configuration)
			 (gnu services avahi)
			 (gnu services nix)
			 (gnu services xorg)
			 (gnu services sound)
			 (gnu services cups)
			 (gnu services virtualization)
			 (gnu services mcron)
			 (gnu services guix)
			 (gnu services pm)

			 (gnu home)
			 (gnu home services)
			 (gnu home services music)
			 (gnu home services utils)
			 (gnu home services xdg)
			 (gnu home services dotfiles)
			 (gnu home services fontutils)
			 (gnu home services shells)
			 (gnu home services ssh)
			 (gnu home services gnupg)
			 (gnu home services shepherd)
			 (gnu home services sound)
			 (gnu home services sway)
			 (gnu home services desktop)
			 (gnu home services guix)

			 (gnu system accounts)
			 (gnu system shadow)

			 (guix gexp))

(define-syntax re-export-list
  (syntax-rules ()
    ((re-export-list lst)
      (macroexpand `(re-export ,@lst)))))
(re-export-list
	(apply append (map (lambda (inter)
						(module-map (lambda (sym var) sym) inter))
					   (module-uses (current-module)))))
