(define-module (home services shells)
  #:use-module (home)
  #:use-module (packages)
  #:use-module (services)
  #:export (zsh-services))

;; ~~ ZSH ~~

(define zsh-packages-service-type
  (ghg-home-service-type 'ghg-zsh-packages
	#:packages (list zsh-autosuggestions
					 zsh-syntax-highlighting
					 zsh-completions
					 fzf
					 direnv
					 )))

(define (_zsh-services)
  (list (service zsh-packages-service-type)
		(service home-zsh-service-type)))
(define-syntax zsh-services
	(identifier-syntax (_zsh-services)))
