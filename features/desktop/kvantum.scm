(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:use-module (guix gexp)
  #:export (kvantum-feature))

(define kvantum-feature
	(feature "kvantum"
		#:packages (list kvantum)
		#:services (list
      		(service home-files-service-type
               `((".config/Kvantum/kvantum.kvconfig"
                  ,(plain-file
                    "kvantum.kvconfig"
                    "[General]\ntheme=KvYaru-MATEDark"))
                 ;; Link system themes to user config
                 (".config/Kvantum/KvYaru-Green"
                  ,(file-append kvantum-theme-yaru "/share/Kvantum/KvYaru-Green"))
                 (".config/Kvantum/KvYaru-MATE"
                  ,(file-append kvantum-theme-yaru "/share/Kvantum/KvYaru-MATE")))))
		#:env-vars `(("QT_STYLE_OVERRIDE" . "kvantum"))))
