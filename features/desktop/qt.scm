(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (qt-feature))

(define qt-feature
  (feature "qt"
;	#:features (list kvantum-feature)
    #:packages (list qt5ct qt6ct)
    #:env-vars `(("QT_QPA_PLATFORMTHEME" . "qt6ct")
                 ("QT_PLATFORMTHEME" . "qt5ct")
				 ("QT_AUTO_SCREEN_SCALE_FACTOR" . "1"))))
