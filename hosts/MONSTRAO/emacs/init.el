;;; init.el --- isolino's Emacs  -*- lexical-binding: t; -*-

;;; Look

(setq inhibit-startup-screen t)
(load-theme 'solarized-selenized-black t)
(set-face-attribute 'default nil :family "JetBrains Mono")

;;; Vim keys

;; evil-collection binds the other modes, and needs Evil to leave them alone.
(setq evil-want-keybinding nil)
(evil-mode 1)
(evil-collection-init)

;;; Language servers

;; Each project's dev shell provides the server.
(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)
(add-hook 'tuareg-mode-hook #'lsp-deferred)
(add-hook 'lean4-mode-hook #'lsp-deferred)
;; lsp-mode starts it through opam by default; the dev shell has no opam.
(setq lsp-ocaml-lsp-server-command '("ocamllsp"))
(setq lsp-inlay-hint-enable t)
;; Without these, lsp-mode warns in every buffer that yasnippet and company are missing.
(setq lsp-enable-snippet nil)
(setq lsp-completion-provider :none)
;; Emacs 31 turns off Flymake backends in untrusted buffers, which hid every
;; language server diagnostic.
(put 'lsp-diagnostics--flymake-backend 'flymake-always-safe t)

;; lsp-mode has no handler for Lean's request to refresh inlay hints, so it
;; warned at each one and kept stale hints (lsp-mode#4230).
(with-eval-after-load 'lean4-mode
  (puthash "workspace/inlayHint/refresh"
           (lambda (workspace _params)
             (with-current-buffer (window-buffer)
               (when (and lsp-inlay-hints-mode
                          (memq workspace lsp--buffer-workspaces))
                 (lsp-update-inlay-hints (window-start) (window-end nil t))))
             nil)
           (lsp--client-request-handlers (gethash 'lean4-lsp lsp-clients))))

;;; Markdown

(add-to-list 'auto-mode-alist '("\\.md\\'" . gfm-mode))
(setq markdown-fontify-code-blocks-natively t)

;;; direnv

;; Last, as envrc asks, so its mode runs before the others in each buffer.
(envrc-global-mode)
