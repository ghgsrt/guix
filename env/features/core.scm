(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (srfi srfi-1)    ; For fold and other list operations
  #:export (make-feature
           feature?
           feature-name
           feature-packages
           feature-services
           feature-version-specs
           feature->manifest
           package-name=?))

;; Core feature record type with all fields
(define-record-type* <feature>
  feature make-feature
  feature?
  (name feature-name)                    ;string
  (packages feature-packages             ;list of <package>
    (default '()))
  (services feature-services             ;list of <service>
    (default '()))
  (version-specs feature-version-specs   ;alist of (name . version)
    (default '()))
  (env-vars feature-env-vars             ;alist of (name . value)
	(default '())))

(define (get-package-name pkg)
  (if (string? pkg)
      pkg
      (package-name pkg)))

(define (package-name=? p1 p2)
  (string=? (get-package-name p1) 
            (get-package-name p2)))

;; We'd also need to resolve strings to packages at some point
(define (resolve-package pkg)
  (if (string? pkg)
      (specification->package pkg)
      pkg))

;; Helper to flatten and deduplicate packages
(define (merge-package-lists . pkg-lists)
  (fold (lambda (pkg acc)
          (let ((existing (find (lambda (p) (package-name=? p pkg)) acc)))
            (if existing
                (cons pkg (delete existing acc))
                (cons pkg acc))))
        '()
        (concatenate (reverse pkg-lists))))

;; Helper to merge version specs with "last wins" semantics
(define (merge-version-specs . spec-lists)
  (fold (lambda (specs acc)
          (fold (lambda (spec acc)
                 (let* ((name (car spec))
                        (existing (assoc name acc)))
                   (if existing
                       (cons spec (alist-delete name acc))
                       (cons spec acc))))
                acc
                specs))
        '()
        spec-lists))

;; Helper to determine if a variable should be path-concatenated
(define (path-like-var? name)
  (member name '("PATH" "LD_LIBRARY_PATH" "GOPATH" "PYTHONPATH" "NODE_PATH")))

;; Helper to merge environment variables
(define (merge-env-vars . var-lists)
  (fold (lambda (vars acc)
          (fold (lambda (var-pair acc)
                 (let* ((name (car var-pair))
                        (value (cdr var-pair))
                        (existing (assoc name acc)))
                   (if existing
                       (if (path-like-var? name)
                           ;; For PATH-like vars, concatenate with :
                           (cons (cons name
                                     (string-append value ":" (cdr existing)))
                                 (alist-delete name acc))
                           ;; For other vars, last wins
                           (cons var-pair (alist-delete name acc)))
                       (cons var-pair acc))))
               vars
               acc))
        '()
        (reverse var-lists)))  ; Reverse to ensure correct order for last-wins

;; Feature constructor with fixed version handling
(define* (make-feature #:key name
                      (packages '())
                      (services '())
                      (features '())
                      (version-specs '())
					  (env-vars '()))
  (let* ((sub-features (map (lambda (f)
                             (if (procedure? f)
                                 (f) ; Call feature constructor if provided
                                 f))
                           features))
         (all-packages (apply merge-package-lists
                             packages
                             (map feature-packages sub-features)))
         (all-services (apply merge-package-lists
                             services
                             (map feature-services sub-features)))
         (sub-versions (map feature-version-specs sub-features))
         (all-versions (apply merge-version-specs
                             (cons version-specs sub-versions)))
		 (all-env-vars (apply merge-env-vars
		 					 env-vars
							 (map feature-env-vars sub-features))))
    (feature
     (name name)
     (packages all-packages)
     (services all-services)
     (version-specs all-versions)
	 (env-vars all-env-vars))))

;; Convert feature to manifest
(define* (feature->manifest feature #:key (versions '()))
  "Convert a feature into a package manifest, with optional version overrides."
  (let* ((pkg-list (map resolve-package (feature-packages feature)))
         (versioned-pkgs
          (map (lambda (pkg)
                 (let ((version (assoc-ref versions (package-name pkg))))
                   (if version
                       (package
                         (inherit pkg)
                         (version version))
                       pkg)))
               pkg-list)))
    (packages->manifest versioned-pkgs)))

;; Convert feature to home environment
(define* (feature->home-environment feature)
	"Convert a feature into a home environment configuration,
	merging it with the base home environment first."
	(let ((merged-feature
			(make-feature
			#:name "complete-home"
			#:features (list (make-base-home-feature)
							feature))))
	(home-environment
		(packages (feature-packages merged-feature))
		(services (cons*
				(service home-environment-variables-service-type
						(feature-env-vars merged-feature))
				(feature-services merged-feature))))))