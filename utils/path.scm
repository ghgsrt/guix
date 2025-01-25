(define-module (utils)
  #:use-module (ice-9 ftw)
  #:use-module (ice-9 match)
  #:use-module (ice-9 regex)
  #:use-module (srfi srfi-1)
  #:export (load-dir
  			load-features
			load-packages
			load-services
			load-homes
			load-users
			load-systems
			load-utils))

(define* (load-dir dir
				#:key
				(exclude '()) ; List of regex patterns to exclude
				(verbose #t))
  "Load all Scheme files recursively from DIR.
   Optional arguments:
   #:exclude - List of regex patterns for files/dirs to exclude
   #:verbose - Whether to print loading messages"
  (let ((scheme-file? (make-regexp ".*\\.scm$"))
        (exclude-patterns (map make-regexp exclude)))
    (define (excluded? path)
      (any (lambda (pattern)
             (regexp-exec pattern path))
           exclude-patterns))
    (ftw dir
         (lambda (filename statinfo flag)
           (match flag
             ('regular
              (when (and (regexp-exec scheme-file? filename)
                        (not (excluded? filename)))
                (when verbose
                  (format #t "Loading ~a...~%" filename))
                (catch #t
                  (lambda ()
                    (load filename))
                  (lambda (key . args)
                    (format (current-error-port)
                            "Error loading ~a: ~a ~a~%"
                            filename key args))))
              #t)
             (_ (not (excluded? filename))))))))

(define (load-packages)
  (load "/config/packages.scm"))
(define (load-features)
  (load "/config/features/core.scm")
  (load-dir "/config/features"))
(define (load-services)
  (load "/config/services.scm"))
(define (load-homes)
  (load-dir "/config/homes"))
(define (load-users)
  (load-dir "/config/users"))
(define (load-systems)
  (load-dir "/config/systems"))
(define (load-utils)
  (load-dir "/config/utils"))
