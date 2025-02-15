(define-module (home base)
  #:use-module (home)
  #:use-module (services)
  #:use-module (packages)
  #:use-module (home services manifest)
  #:use-module (home services dev)
  #:use-module (home services ssh)
  #:use-module (ice-9 rdelim)  ; For reading environment variables
  #:export (%bos-base-home
	    %bos-base-home-services
		%bos-base-home-service-type))

(define dotfiles-dir (getenv "BOS_DOTFILES_DIR"))

(define %bos-base-home-service-type
  (bos-home-service-type 'bos-base-home
  		#:packages (list git
						podman
						vim
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
					 ("PATH" . "$HOME/.local/bin:$PATH"))))
					;  ("BOS_CONFIG_DIR" . ,(car %load-path))

(define %bos-base-home-services
	(append manifest-services
			guile-services
			ssh-services
			(list (service %bos-base-home-service-type)
				   (simple-service 'meslo-fonts-service home-fontconfig-service-type
				 	(list (string-append dotfiles-dir "/fonts/MesloLGS"))))))


(define %bos-base-home
	(home-environment
		(services %bos-base-home-services)))

%bos-base-home
