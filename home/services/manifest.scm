(define-module (home services manifest)
  #:use-module (services)
  #:export (manifest-services))

(define manifest-services
	(list (service home-files-service-type
			`((".local/bin/generate-manifest"
				,(local-file "/config/scripts/generate-manifests.sh" "generate-manifest"))
				(".config/bash/manifest-cd.sh"
				,(local-file "/config/scripts/manifest-cd.sh"))))
		 (service home-bash-service-type
			(home-bash-configuration
				(bashrc (list (plain-file
					"manifest-source.sh"
					"\n# Source manifest cd function source ~/.config/bash/manifest-cd.sh\n")))
				(aliases '(("regenerate-manifest" . "generate-manifest --force")))))))
