(define-public rust-
               (package
                 (name "rust-")
                 (version "")
                 (source
                   (origin
                     (method url-fetch)
                     (uri (crate-uri "" version))
                     (file-name (string-append name "-" version ".tar.gz"))
                     (sha256
                       (base32 "1lf5zy1fjjqdwjkc445sw80hpmxi63ymcxgjh3q6642x2hck6hgy"))))  
                 (build-system cargo-build-system)
                 (arguments
                   `(#:cargo-inputs
                     (

                      )
                     #:cargo-development-inputs
                     (

                      )))
                 (synopsis "")
                 (description "")
                 (home-page "")
                 (license license:expat)))