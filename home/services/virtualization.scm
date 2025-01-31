(define-module (home services virtualization)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (podman-services))

;; ~~ PODMAN ~~

(define podman-service-type
  (ghg-home-service-type 'ghg-podman
	#:packages (list podman)
	#:env-vars `(("DOCKER_HOST" . "unix:///tmp/podman.sock"))))

(define (_podman-services)
	(list (service podman-service-type)))
(define-syntax podman-services
	(identifier-syntax (_podman-services)))
