(define-module (home base)
  #:use-module (dotfiles guix channels)
  #:use-module (home)
  #:use-module (services)
  #:use-module (packages)
  #:use-module (packages vim)
  #:use-module (packages tmux)
  #:use-module (home services manifest)
  #:use-module (home services dev)
  #:use-module (home services ssh)
  #:use-module (home services shells)
  #:use-module (home services archive)
  #:use-module (ice-9 rdelim)  ; For reading environment variables
  #:export (%bos-base-home
	    %bos-base-home-services
		%bos-base-home-service-type))

(define dotfiles-dir (getenv "BOS_DOTFILES_DIR"))

(define %bos-base-home-service-type
  (bos-home-service-type 'bos-base-home
  		#:packages (list git
						nss-certs
						; glibc
						gcc-toolchain
						; binutils
						podman
						vim
						neovim@0.10.4
						tmux
						tmux-tpm
						gnupg
						pinentry
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
					 ("EDITOR" . "nvim")
					 ("VISUAL" . "nvim")
					 ("SHELL" . "zsh")
					 ("BOS_HOME_NAME" . "base"))))
					;  ("BOS_CONFIG_DIR" . ,(car %load-path))

(define %bos-base-home-services
	(append manifest-services
			guile-services
			ssh-services
			zsh-services
			archive@minimal-services
			(list (service %bos-base-home-service-type)
				   (simple-service 'bos-channels-service home-channels-service-type
				   	%guixos-channels)
				   (simple-service 'meslo-fonts-service home-fontconfig-service-type
				 	(list (string-append dotfiles-dir "/fonts/MesloLGS"))))))


(define %bos-base-home
	(home-environment
		(services %bos-base-home-services)))

%bos-base-home
