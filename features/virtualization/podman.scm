(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (podman-feature))

(define podman-feature
	(feature "podman"
		#:packages (list podman))
		#:env-vars `(("DOCKER_HOST" . "unix:///tmp/podman.sock")))