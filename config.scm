; (load "./systems/thinkpad.scm")
;(add-to-load-path (dirname (current-filename)))
(add-to-load-path (dirname (current-filename)))
;(add-to-load-path "/config")
;(newline)

(load "./packages.scm")
(load "./services.scm")
(load "./features.scm")
(load "./users.scm")
(load "./homes.scm")
(load "./systems.scm")
;(use-modules (systems))
;(load "./utils/path.scm")
;(load "./features/core.scm")
;(load "./systems/thinkpad.scm")
;(load-systems)

;(define-module (config)
;  #:use-module (systems)
;;  #:use-module (systems thinkpad)
;  #:use-module (utils))

;(load-dir "/config" #:exclude (list "config.scm"))

(use-modules (systems))
thinkpad-os
