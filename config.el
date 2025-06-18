;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "JetBrains Mono" :size 16 :weight 'semi-light))
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-Iosvkem)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/notes/")
(doom/set-frame-opacity 90)
;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
;;
;;
;; (after! java-mode
;;   (add-to-list 'lsp-language-id-configuration '(".*\\.cls$" . "apex"))
;;   (lsp-register-client (make-lsp-client
;;                         :new-connection
;;                         (lsp-stdio-connection
;;                          `("java" "-jar" "/home/bwalt/Downloads/apex-jorje-lsp.jar" "-Ddebug.internal.errors=true"))
;;                         :activation-fn (lsp-activate-on "apex")
;;                         :server-id 'apex)))
(add-to-list 'auto-mode-alist '("\\.\\(cls\\|trigger\\|apex\\)\\'" . java-mode))
(add-to-list 'image-types 'svg)




(use-package! lsp-tailwindcss :after lsp-mode)

(use-package! svg)

;; LLM Stuff

(use-package aidermacs
  :bind (("C-c a" . aidermacs-transient-menu))
  :config
                                        ; Set API_KEY in .bashrc, that will automatically picked up by aider or in elisp
  (setenv "GEMINI_API_KEY" (password-store-get "gemini"))
  (setenv "OPENROUTER_API_KEY" (password-store-get "openrouter"))
  :custom
  (aidermacs-use-architect-mode t)
                                        ; See the Configuration section below
  (aidermacs-default-model "gemini/gemini-2.5-flash-preview-05-20")
  (aidermacs-architect-model "openrouter/deepseek/deepseek-r1-0528")
  (aidermacs-editor-model "openrouter/anthropic/claude-3.5-sonnet:beta"))


(use-package! gptel
 :config
(setq
 gptel-model 'gemini-2.5-pro-preview-06-05
 gptel-backend (gptel-make-gemini "Gemini"
                 :key (password-store-get "gemini")
                 :stream t)
 ))

;; OpenRouter offers an OpenAI compatible API
(gptel-make-openai "OpenRouter"               ;Any name you want
  :host "openrouter.ai"
  :endpoint "/api/v1/chat/completions"
  :stream t
  :key (password-store-get "openrouter")
  :models '(openai/gpt-4o-mini
            google/gemini-2.5-pro-preview
            google/gemini-2.5-pro
            deepseek/deepseek-chat-v3-0324
            deepseek/deepseek-r1-0528:free
            deepseek/deepseek-r1-0528
            x-ai/grok-3-mini-beta))


(gptel-make-preset 'commandline
  :description "A preset for generating commands"
  :backend "Gemini"
  :model 'gemini-2.5-flash-preview-05-20 :system "You are a command line helper. Generate command line commands that do what is requested, without any additional description or explanation. your output should not contain any decoration such as bash'''...''' ")


(use-package nov-xwidget
  :demand t
  :after nov
  :config
  (define-key nov-mode-map (kbd "o") 'nov-xwidget-view)
  (add-hook 'nov-mode-hook 'nov-xwidget-inject-all-files))

(global-subword-mode t)

(use-package prettier
  :hook ((typescript-mode . prettier-mode)
         (js-mode . prettier-mode)
         (html-mode . prettier-mode)))
(use-package chatgpt-shell
  :ensure t
  :custom
  ((chatgpt-shell-openai-key
    (lambda ()
      (auth-source-pass-get 'secret "openai-key")))))




(defun apex-lsp ()
  (interactive)
  (lsp)
  (add-to-list 'lsp-language-id-configuration '(".*\\.cls$" . "apex"))
  (add-to-list 'lsp-language-id-configuration '(".*\\.trigger$" . "apex"))
  (add-to-list 'lsp-language-id-configuration '(".*\\.apex$" . "apex"))
  (lsp-register-client (make-lsp-client
                          :new-connection
                          (lsp-stdio-connection
                           `("java" "-jar" "/home/bwalt/Downloads/apex-jorje-lsp.jar" "-Ddebug.internal.errors=true"))
                          :activation-fn (lsp-activate-on "apex")
                          :server-id 'apex)))

(defun deploy ()
  (interactive)
  (let ((file-to-deploy buffer-file-name))
   (projectile-run-vterm)
   (vterm-send-string (concat "sf project deploy start --source-dir " file-to-deploy))
   (vterm-send-return)))

(defun retrieve ()
  (interactive)
  (let ((file-to-retrieve buffer-file-name))
    (projectile-run-vterm)
    (vterm-send-string (concat "sf project retrieve start --source-dir " file-to-retrieve))
    (vterm-send-return)))

(use-package! lsp
  :config
  (apex-lsp))


(defun workmode ()
  (interactive)
  (shell-command "workmode"))

(defun monitor-main ()
  (interactive)
  (shell-command "monitor main dp"))

(global-unset-key (kbd "C-z"))
(global-unset-key (kbd "C-c a"))
(global-unset-key (kbd "M-o"))

(global-set-key (kbd "M-o") 'other-window)
(global-set-key (kbd "C-x o") 'ace-window)

(global-set-key (kbd "C-c d") 'deploy)
(global-set-key (kbd "C-c r") 'retrieve)

(global-set-key (kbd "C-s-o") 'vterm-other-window)

(global-set-key (kbd "C-s-w") 'workmode)
(global-set-key (kbd "C-s-p") 'monitor-main)

(global-set-key (kbd "C-c RET") 'gptel-send)
(global-set-key (kbd "C-c a") 'aidermacs-transient-menu)

;;; avy keybinds
(global-set-key (kbd "C-:") 'avy-goto-char)
(global-set-key (kbd "C-'") 'avy-goto-char-2)
(global-set-key (kbd "M-g f") 'avy-goto-line)
(global-set-key (kbd "M-g w") 'avy-goto-word-1)


(global-visual-line-mode t)
(+global-word-wrap-mode t)


(add-hook 'html-mode-hook
          (lambda ()
            ;; This ensures that M-o always calls other-window
            ;; when in html-mode, overriding any conflicting bindings
            ;; from facemenu-keymap or other minor modes.
            (define-key html-mode-map (kbd "M-o") 'other-window)))
;; (after! vterm
;;   (set-popup-rule! "^(\\*vterm\\*|VTerm .*)"
;;     :side 'right
;;     :width 80      ; Character width for the window
;;     :slot 0        ; Slot for ordering, 0 is usually  fine
;;     :parameters '((no-delete-other-windows . t)) ; Ensures the window doesn't make others disappear
;;     :quit nil      ; 'nil to keep window open until explicitly closed
;;     :ttl nil))     ; 'nil for no time-to-live (persistent popup)

(defun sf-uv-activate ()
  "Activate Python environment managed by uv based on current project directory.
Looks for .venv directory in project root and activates the Python interpreter."
  (interactive)
  (let* ((project-root "/home/bwalt/python-modules")
         (venv-path (expand-file-name ".venv" project-root))
         (python-path (expand-file-name
                       (if (eq system-type 'windows-nt)
                           "Scripts/python.exe"
                         "bin/python")
                       venv-path)))
    (if (file-exists-p python-path)
        (progn
          ;; Set Python interpreter path
          (setq python-shell-interpreter python-path)

          ;; Update exec-path to include the venv's bin directory
          (let ((venv-bin-dir (file-name-directory python-path)))
            (setq exec-path (cons venv-bin-dir
                                  (remove venv-bin-dir exec-path))))

          ;; Update PATH environment variable
          (setenv "PATH" (concat (file-name-directory python-path)
                                 path-separator
                                 (getenv "PATH")))

          ;; Update VIRTUAL_ENV environment variable
          (setenv "VIRTUAL_ENV" venv-path)

          ;; Remove PYTHONHOME if it exists
          (setenv "PYTHONHOME" nil)

          (message "Activated UV Python environment at %s" venv-path))
      (error "No UV Python environment found in %s" project-root))))

(defun ace-window-prefix ()
    "Use `ace-window' to display the buffer of the next command.
The next buffer is the buffer displayed by the next command invoked
immediately after this command (ignoring reading from the minibuffer).
Creates a new window before displaying the buffer.
When `switch-to-buffer-obey-display-actions' is non-nil,
`switch-to-buffer' commands are also supported."
    (interactive)
    (display-buffer-override-next-command
     (lambda (buffer _)
       (let (window type)
         (setq
          window (aw-select (propertize " ACE" 'face 'mode-line-highlight))
          type 'reuse)
         (cons window type)))
     nil "[ace-window]")
    (message "Use `ace-window' to display next command buffer..."))

(global-set-key (kbd "C-c u") 'ace-window-prefix)
