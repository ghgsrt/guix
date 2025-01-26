(define-module (features archive)
  #:use-module (features core)

  #:use-module (packages)
  #:use-module (services)
  #:export (archive@minimal-feature archive-feature))

(define archive@minimal-feature
	(feature "archive@minimal"
		#:packages (list "zip"
						 unzip)))

(define archive-feature
	(feature "archive"
		#:features (list archive@minimal-feature)
		#:packages (list gzip
			 			 bzip2
						 xz
						 tar
						 p7zip)))
