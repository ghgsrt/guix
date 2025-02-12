(define-module (home base)
  #:use-module (home)
  #:use-module (services)
  #:use-module (packages)
  #:use-module (home services manifest)
  #:use-module (home services dev)
  #:use-module (home services ssh)
  #:export (%bos-base-home
	    %bos-base-home-services
		%bos-base-home-service-type))

(define %bos-base-home-service-type
  (bos-home-service-type 'bos-base-home
  		#:packages (list git
						neovim
						tmux
						tmux-tpm
						gnupg
						hyperfine
						nnn
						shellcheck
						shfmt
						fzf
						openssl
						net-tools
						font-fira-code
						curl
						ripgrep
						fd
						tree
						dstat
						ncurses
						dconf-editor
						coreutils)
		#:env-vars `(("GUIX_LOCPATH" . "$HOME/.guix-profile/lib/locale")
					 ("PATH" . "$HOME/.local/bin:$PATH")
					 ("BOS_HOME_PROFILE" . "$HOME/.guix-home/profile")
					 ("BOS_HOME_TYPE" . "guix")
					 ("BOS_HOME_NAME" . "base")
					 ("BOS_CONFIG_DIR" . ,(car %load-path)))))

(define %bos-base-home-services
	(append manifest-services
			guile-services
			ssh-services
			(list (service %bos-base-home-service-type)
				;   (simple-service 'meslo-fonts-service home-fontconfig-service-type
				; 	(list "/config/dotfiles/fonts/MesloLGS"))
		  (service home-dotfiles-service-type
					(home-dotfiles-configuration
						(directories '("/dots"))
						(excluded '(".bashrc" "fontconfig"))))
				)))
; (define-syntax %bos-base-home-services
; 	(identifier-syntax (_%bos-base-home-services)))


(define %bos-base-home
	(home-environment
		(services %bos-base-home-services)))

%bos-base-home
