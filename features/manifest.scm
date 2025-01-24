(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (guix gexp)
  #:export (manifest-feature))

(define manifest-feature
  (make-feature "base-manifest"
   #:services
   (list
    (service home-files-service-type
            `((".local/bin/generate-manifest"
               ,(local-file "/config/env/scripts/generate-manifest.sh"
                            "generate-manifest"))
	      (".config/bash/manifest-cd.sh"
               ,(local-file "/config/env/scripts/manifest-cd.sh"))))
    (service home-bash-service-type
            (home-bash-configuration
             (bashrc
              (list
               (plain-file
                "manifest-source.sh"
                "\n# Source manifest cd function source ~/.config/bash/manifest-cd.sh\n")))
             (aliases
              '(("regenerate-manifest" . "generate-manifest --force"))))))))
