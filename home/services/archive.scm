(define-module (home services archive)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (archive@minimal-services archive-services))

(define archive@minimal-packages-service-type
  (ghg-home-service-type 'ghg-archive@minimal-packages
	#:packages (list (specification->package "zip")
					 unzip)))

(define (_archive@minimal-services)
	(list (service archive@minimal-packages-service-type)))
(define-syntax archive@minimal-services
	(identifier-syntax (_archive@minimal-services)))

(define archive-packages-service-type
  (ghg-home-service-type 'ghg-archive-packages
	#:packages (list gzip
					 bzip2
					 xz
					 tar
					 p7zip)))

(define (_archive-services)
	(list (service archive-packages-service-type)))
(define-syntax archive-services
	(identifier-syntax (_archive-services)))
