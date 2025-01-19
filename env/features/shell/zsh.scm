(define-module (features)
  #:use-module (packages)
  #:use-module (services)
  #:export (make-zsh-feature))

(define (make-zsh-feature)
  (make-feature
    #:name "zsh"
    #:packages (list
      zsh
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-completions
      fzf
      direnv
      starship)
    #:env-vars (list
      ("SHELL" . "/run/current-system/profile/bin/zsh")
      ("STARSHIP_CONFIG" . "/config/dotfiles/starship.toml")
      ("FZF_DEFAULT_OPTS" . "--height 40% --border")
      ("WORDCHARS" . "")
      ("HISTFILE" . "$HOME/.cache/zsh/history")
      ("HISTSIZE" . "10000")
      ("SAVEHIST" . "10000"))))