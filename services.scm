(define-module (services))

;; Service facade

(use-modules
  (gnu services)
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
	(gnu home services shells)
	(gnu home services ssh)
	(gnu home services gnupg)
	(gnu home services shepherd)
	(gnu home services sound)
	(gnu home services sway)
	(gnu home services desktop)

	(gnu system accounts)
	(gnu system shadow))

;; Re-export all bindings from the modules we use
(define-syntax re-export-list
  (syntax-rules ()
    ((re-export-list lst)
      (macroexpand `(re-export ,@lst)))))
(re-export-list
	(apply append (map
					(lambda (inter)
						(module-map (lambda (sym var) sym) inter))
					(module-uses (current-module)))))


; (define-syntax import-and-export
;   (syntax-rules ()
;    ((import-all)
;       (begin
; 	(macroexpand `(re-export)))))) 

; ;(macroexpand `(use-modules ,@modules-to-reexport))
; ;(use-modules (modules-to-reexport))
; ;(define (get-imported-bindings module-name)
; ;  (let ((mod (resolve-module module-name)))
; ;    (module-map mod (lambda (sym var) sym))))

; ;(define (get-all-imports)
; ;  (let ((uses (module-uses (current-module))))
; ;    (filter-map (lambda (use) (and (module? use) (module-name use))) uses)))

; (define-syntax-rule (re-export-all mod)
; ;(for-each (lambda (mod-name)  
; (module-re-export!
;     (current-module)
;     (get-imported-bindings mod)))
;(get-all-imports)))

;(display (map 
;(lambda (mod)
;  (module-variable 
;   (current-module) 
;   (module-obarray mod))) 
;(module-uses (current-module))))


;(display
; (map (lambda (inter)
;  (hash-map->list 
;    (lambda (k v) k)
;    (module-obarray inter)))
;(module-uses (current-module))))

;(display (module-uses (current-module)))
;(display (module-map (lambda (sym var) sym) (current-module)))

;(display 
 ;(hash-map->list (lambda (k v) k)
; (module-obarray (resolve-module (module-uses (current-module)))))

;(for-each (lambda (mod)
;  (module-re-export! (current-module) mod))
;`(,@(module-uses (current-module))))


;(module-re-export! (current-module) (module-uses (current-module))))

;; Load and re-export everything from each module
;(for-each
; (lambda (module-name)
;   (let ((mod (resolve-module module-name)))
;     ;; Re-export all bindings from this module
;     (module-for-each
;      (lambda (name var)
;        (module-re-export! (current-module) (list name)))
;      (module-public-interface mod))))
; modules-to-reexport)
