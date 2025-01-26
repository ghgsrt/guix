(define-module (features core)
;  #:use-module (packages)
;  #:use-module (services)
 ; #:use-module (utils)
  #:use-module (guix packages)
  #:use-module (gnu services)
  #:use-module (srfi srfi-9)    ; For define-record-type
  #:use-module (srfi srfi-1)    ; For fold and other list operations
  #:use-module (guix records)
  #:export (feature
            feature?
            feature-name
            feature-packages
            feature-services
			feature-env-vars
            feature-excludes
            feature->modifies
			excludes
			excludes?
			excludes-packages
			excludes-services
	    merge-features))


(define-record-type* <excludes> excludes make-excludes
;   (%feature-excludes packages services)
  excludes?
  (packages excludes-packages
            (default '()))  ; Default to empty list if not specified
  (services excludes-services
            (default '())))

(define-record-type* <feature> %feature %make-feature
;   (feature name packages services env-vars features excludes)
  feature?
  (name     feature-name       ; String
	    (default "anonymous-feature"))
  (packages feature-packages   ; List of packages 
	    (default '())) 
  (services feature-services   ; List of services
	    (default '()))
  (env-vars feature-env-vars   ; Association list
	    (default '()))
  (modifies feature-modifies   ; Modify-services clause list
	    (default #f))
  (excludes feature-excludes   ; Excludes
	    (default #f)))

(define (merge-packages base additions)
  ;; Last package with a given name wins
  (fold-right
    (lambda (pkg result)
      (cons pkg
            (remove (lambda (p)
                     (string=? (package-name p)
                              (package-name pkg)))
                   result)))
    base
    additions))

(define (merge-services base additions)
  (fold-right
    (lambda (service result)
	  (let ((type (service-kind service)))
	  (if (service-type-extend type)
		(cons service result)
		(let ((existing (find (lambda (s) (eq? (service-kind s) type))
				       result)))
		 (if existing
			(cons service (delete existing result))
			(cons service result))))))
    base
    additions))

(define (merge-env-vars base additions)
  (append base additions))

(define (apply-excludes from-feature excludes)
  (if (not excludes)
    from-feature
    (%feature
	  (inherit from-feature)
      ;; Remove excluded packages
      (packages (filter (lambda (pkg)
                (not (member (package-name pkg)
                           (excludes-packages excludes))))
              (feature-packages from-feature)))
      ;; Remove excluded services
      (services (filter (lambda (service)
                (not (member (service-kind service)
                           (excludes-services excludes))))
              (feature-services from-feature)))
      (excludes #f)))) ; No excludes stored in resulting feature

(define (merge-features feature-a feature-b)
  ;; First apply any excludes from feature-b to feature-a
  (let ((base (apply-excludes feature-a
                             (feature-excludes feature-b))))
    (%feature
	  (inherit base)
      (packages (merge-packages (feature-packages base)
                     (feature-packages feature-b)))
      (services (let ((merged-services (merge-services
											(feature-services base)
											(feature-services feature-b))))
					(if (feature-modifies feature-b)
						(begin
							(display "modifying services")
							(display (feature-modifies feature-b))
	  						((macroexpand `(modify-services ,merged-services ,@(macroexpand (feature-modifies feature-b))))))
						 merged-services)))
      (env-vars (merge-env-vars (feature-env-vars base)
                     (feature-env-vars feature-b)))
      (excludes #f) ; No excludes stored in merged feature
	  (modifies #f)))) ; Modifies already applied by this point

(define (resolve-packages packages)
  (map (lambda (pkg)
		 (if (string? pkg)
		   (specification->package pkg)
		   pkg))
	   packages))

;; Main feature constructor that applies the merging rules
(define* (feature name #:key 
			(features '()) 
			(packages '())	
			(services '())
			(env-vars '())
			(excludes '())
			(modifies '()))
  (fold-right merge-features
			  (%feature (name name)) ; Empty starting feature
			  (cons (%feature
						(name name)
						(packages (resolve-packages packages))
						(services services)
						(env-vars env-vars)
						(modifies modifies)
						(excludes excludes))
					(or features '()))))

;(load-features)

; (define (feature name #:key packages services env-vars excludes modifies)
;   (%feature
; 	(name name)
; 	(packages (resolve-packages packages))
; 	(services services)
; 	(env-vars env-vars)
; 	(modifies modifies)
; 	(excludes excludes)))





; ;; Core feature record type with all fields
; (define-record-type <feature>
;   (%make-feature name packages services env-vars version-specs)
;   feature?
;   (name feature-name)                    ;string
;   (packages feature-packages)            ;list of <package>
;   (services feature-services)            ;list of <service>
;   (env-vars feature-env-vars)            ;alist of (name . value)
;   (version-specs feature-version-specs)) ;alist of (name . version)

; ;(define* (make-feature #:key
; ;	 (name "invalid")
; ;	 (packages '())
; ;	 (services '())
; ;	 (env-vars '())
; ;	 (version-specs '()))
; ;	(%make-feature name packages services env-vars version-specs))

; (define (get-package-name pkg)
;   (cond ((package? pkg)(package-name pkg))
; 	 (else pkg)))
;     ;  (package-name pkg)))

; (define (package-name=? p1 p2)
;   (string=? (get-package-name p1) 
;             (get-package-name p2)))

; ;; We'd also need to resolve strings to packages at some point
; (define (resolve-package pkg)
;   (if (string? pkg)
;       (specification->package pkg)
;       pkg))

; ;; Helper to flatten and deduplicate packages
; (define (merge-package-lists . pkg-lists)
;   (fold (lambda (pkg acc)
;           (let ((existing (find (lambda (p) (package-name=? p pkg)) acc)))
;             (if existing
;                 (cons pkg (delete existing acc))
;                 (cons pkg acc))))
;         '()
;         (concatenate (reverse pkg-lists))))

; (define (get-service-name svc)
;    (cond ((string? svc) svc)
; 	 (else (service-name svc)))) 
;  ;(cond ((service? svc) (service-name svc))
; ;	 (else svc)))

; (define (service-name=? s1 s2)
;   (eq? s1 s2))

; (define (merge-service-lists . svc-lists)
;   (fold (lambda (svc acc)
; 	  (let ((existing (find (lambda (s) (service-name=? s svc)) acc)))
; 	    (if existing
; 		(cons svc (delete existing acc))
; 		(cons svc acc))))
; 	  '()
; 	  (concatenate (reverse svc-lists))))

; ;; Helper to merge version specs with "last wins" semantics
; (define (merge-version-specs . spec-lists)
;   (fold (lambda (specs acc)
;           (fold (lambda (spec acc)
;                  (let* ((name (car spec))
;                         (existing (assoc name acc)))
;                    (if existing
;                        (cons spec (alist-delete name acc))
;                        (cons spec acc))))
;                 acc
;                 specs))
;         '()
;         spec-lists))

; ;; Helper to determine if a variable should be path-concatenated
; (define (path-like-var? name)
;   (member name '("PATH" "LD_LIBRARY_PATH" "GOPATH" "PYTHONPATH" "NODE_PATH")))

; ;; Helper to merge environment variables
; (define (merge-env-vars . var-lists)
;   (fold (lambda (vars acc)
;           (fold (lambda (var-pair acc)
;                  (let* ((name (car var-pair))
;                         (value (cdr var-pair))
;                         (existing (assoc name acc)))
;                    (if existing
;                        (if (path-like-var? name)
;                            ;; For PATH-like vars, concatenate with :
;                            (cons (cons name
;                                      (string-append value ":" (cdr existing)))
;                                  (alist-delete name acc))
;                            ;; For other vars, last wins
;                            (cons var-pair (alist-delete name acc)))
;                        (cons var-pair acc))))
;                vars
;                acc))
;         '()
;         (reverse var-lists)))  ; Reverse to ensure correct order for last-wins

; ;; Feature constructor with fixed version handling
; (define* (make-feature #:key name
;                       (packages '())
;                       (services '())
;                       (features '())
;                       (version-specs '())
; 					  (env-vars '()))
;   (let* ((sub-features (map (lambda (f)
;                              (if (procedure? f)
;                                  (f) ; Call feature constructor if provided
;                                  f))
;                            features))
;          (all-packages (apply merge-package-lists
;                              packages
;                              (map feature-packages sub-features)))
;          (all-services (apply merge-service-lists
;                              services
;                              (map feature-services sub-features)))
;          (sub-versions (map feature-version-specs sub-features))
;          (all-versions (apply merge-version-specs
;                              (cons version-specs sub-versions)))
; 		 (all-env-vars (apply merge-env-vars
; 		 					 env-vars
; 							 (map feature-env-vars sub-features))))
;     (%make-feature
;      name
;      all-packages
;      all-services
;      all-env-vars
;      all-versions)))

; ;; Convert feature to manifest
; (define* (feature->manifest feature #:key (versions '()))
;   "Convert a feature into a package manifest, with optional version overrides."
;   (let* ((pkg-list (map resolve-package (feature-packages feature)))
;          (versioned-pkgs
;           (map (lambda (pkg)
;                  (let ((version (assoc-ref versions (package-name pkg))))
;                    (if version
;                        (package
;                          (inherit pkg)
;                          (version version))
;                        pkg)))
;                pkg-list)))
;     (packages->manifest versioned-pkgs)))

; ;; Convert feature to home environment
; (define* (feature->home-environment feature)
; 	"Convert a feature into a home environment configuration,
; 	merging it with the base home environment first."
; 	(let ((merged-feature
; 			(make-feature
; 			#:name "complete-home"
; 			#:features (list (make-base-home-feature)
; 							feature))))
; 	(home-environment
; 		(packages (feature-packages merged-feature))
; ;		(services (feature-services merged-feature))
; )))

; 				;(cons* 
; 				;(service home-environment-variables-service-type
; 				;		(feature-env-vars merged-feature))
; 				;(feature-services merged-feature))))))
