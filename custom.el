(put 'customize-themes 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-cyan-charcoal))
 '(custom-safe-themes
   '("ff53a30172ba57f16a4c0f477ad496b45adc7de23608cc73c501f16e06d4779d"
     "4d714a034e7747598869bef1104e96336a71c3d141fa58618e4606a27507db4c"
     "2b501400e19b1dd09d8b3708cefcb5227fda580754051a24e8abf3aff0601f87"
     "b754d3a03c34cfba9ad7991380d26984ebd0761925773530e24d8dd8b6894738"
     "a6920ee8b55c441ada9a19a44e9048be3bfb1338d06fc41bce3819ac22e4b5a1"
     "ff24d14f5f7d355f47d53fd016565ed128bf3af30eb7ce8cae307ee4fe7f3fd0"
     "2b20b4633721cc23869499012a69894293d49e147feeb833663fdc968f240873"
     "452068f2985179294c73c5964c730a10e62164deed004a8ab68a5d778a2581da"
     "2721b06afaf1769ef63f942bf3e977f208f517b187f2526f0e57c1bd4a000350"
     "f053f92735d6d238461da8512b9c071a5ce3b9d972501f7a5e6682a90bf29725"
     "da75eceab6bea9298e04ce5b4b07349f8c02da305734f7c0c8c6af7b5eaa9738"
     "a9eeab09d61fef94084a95f82557e147d9630fbbb82a837f971f83e66e21e5ad"
     "9d5124bef86c2348d7d4774ca384ae7b6027ff7f6eb3c401378e298ce605f83a" default))
 '(elfeed-feeds
   '("https://planet.emacslife.com/atom.xml"
     "https://planet.emacslife.com/atom.xml\""
     "https://www.govtrack.us/events/events.rss?list_id=z0N8ZA5LRm3GChHg"))
 '(org-agenda-files
   '("~/todo/tamp_portal.org" "/home/bwalt/notes/tamp_portal_changes_june.org"
     "/home/bwalt/todo/june_rollout.org" "/home/bwalt/notes/homes.org"
     "/home/bwalt/notes/random.org" "/home/bwalt/notes/trump_fed_pause.org"))
 '(package-selected-packages
   '(ellama google-this json-navigator nerd-icons nov rg svg svg-lib typit)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-level-1 ((t (:inherit outline-1 :height 2.0))))
 '(org-level-2 ((t (:inherit outline-2 :height 1.8))))
 '(org-level-3 ((t (:inherit outline-3 :height 1.6))))
 '(org-level-4 ((t (:inherit outline-4 :height 1.4))))
 '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))

(add-hook! 'org-mode-hook 'doom-docs-mode)

(with-eval-after-load 'company
  (define-key company-active-map (kbd "<return>") nil)
  (define-key company-active-map (kbd "RET") nil)
  (define-key company-active-map (kbd "C-SPC") #'company-complete-selection))

(with-eval-after-load 'embark
  (define-key general-override-mode-map (kbd "C-c a") nil))

(with-eval-after-load 'aidermacs
  (setq aidermacs-program "/home/bwalt/.local/bin/aider")
  (global-set-key (kbd "C-c ll") 'aidermacs-run))

(with-eval-after-load 'chatgpt-shell
  (setq chatgpt-shell-google-key (password-store-get "gemini"))
  (setq chatgpt-shell-model-version "gemini-2.5-flash-preview-04-17")
  (setq chatgpt-shell-openrouter-key (password-store-get "openrouter"))
  (chatgpt-shell-google-load-models))

(defun get-field-info ()
  (interactive)
  (let ((user-input (read-string "Enter Object.FieldName")))
  (message "Hello from Python: %s"
           (run-python-script "/home/bwalt/python-modules/main.py" user-input))))

(defun get-object-fields ()
  (interactive)
  (let ((user-input (read-string "Enter Object Name: ")))
  (message "Hello from Python: %s"
           (run-python-script "/home/bwalt/python-modules/getFields.py" user-input))))

(defun run-python-script (script input)
  "Exec python script and return the result string in a non-temporary buffer."
  (sf-uv-activate)
  (let ((result-buffer (generate-new-buffer "*Python Script Result*")))
    (with-current-buffer result-buffer
      (call-process "python3" nil t nil script input))
    (pop-to-buffer result-buffer)))
(put 'upcase-region 'disabled nil)
