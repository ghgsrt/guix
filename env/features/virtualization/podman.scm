(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-podman-feature))

(define (make-podman-feature)
	(make-feature
		#:name "podman"
		#:packages (list podman))
		#:env-vars `(("DOCKER_HOST" . "unix:///tmp/podman.sock")))