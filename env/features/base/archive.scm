(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-archive@minimal-feature make-archive-feature))

(define (make-archive@minimal-feature)
	(make-feature
		#:name "archive@minimal"
		#:packages (list
			"zip"
			unzip)))

(define (make-archive-feature)
	(make-feature
		#:name "archive"
		#:features (list (make-archive@minimal-feature))
		#:packages (list
			gzip
			bzip2
			xz
			tar
			p7zip)))
