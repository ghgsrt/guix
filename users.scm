(define-module (users))
;   #:use-module (lib path))

; (load-users)

(define-public bosco-user
	(user-account
		(name "bosco")
		(comment "Bosco")
		(group "users")
		(home-directory "/home/bosco")
		(supplementary-groups '("wheel" "netdev" "audio" "video"))))