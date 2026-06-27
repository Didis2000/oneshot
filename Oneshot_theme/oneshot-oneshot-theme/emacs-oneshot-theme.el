(deftheme emacs-oneshot
  "Oneshot theme for Emacs -- warm purple & gold.")

(let ((bg "#070324") (fg "#e8d5b7") (gold "#d4a54a") (gbr "#f0c860")
      (surf "#0f0544") (cont "#2b0e77") (bord "#1a0544")
      (red "#e07a5f") (grn "#8bba7a") (blu "#4a6a9a")
      (mag "#c4a0b0") (cyn "#6a9a9a") (dim "#b8a88a"))
  (custom-theme-set-faces
   'emacs-oneshot

   `(default             ((t (:foreground ,fg :background ,bg))))
   `(cursor              ((t (:background ,gold))))
   `(region              ((t (:background ,gold :foreground ,bg))))
   `(fringe              ((t (:background ,bg :foreground ,dim))))
   `(line-number         ((t (:foreground ,dim :background ,bg))))
   `(line-number-current-line ((t (:foreground ,gold :background ,surf))))
   `(hl-line             ((t (:background ,surf))))
   `(mode-line           ((t (:foreground ,fg :background ,surf))))
   `(mode-line-inactive  ((t (:foreground ,dim :background ,surf))))
   `(mode-line-highlight ((t (:foreground ,bg :background ,gold))))
   `(minibuffer-prompt   ((t (:foreground ,gold))))
   `(font-lock-builtin-face       ((t (:foreground ,mag))))
   `(font-lock-comment-face       ((t (:foreground ,dim :italic t))))
   `(font-lock-comment-delimiter-face ((t (:foreground ,dim :italic t))))
   `(font-lock-constant-face      ((t (:foreground ,gbr))))
   `(font-lock-doc-face           ((t (:foreground ,grn))))
   `(font-lock-function-name-face ((t (:foreground ,blu))))
   `(font-lock-keyword-face       ((t (:foreground ,gold))))
   `(font-lock-negation-char-face ((t (:foreground ,gold))))
   `(font-lock-preprocessor-face  ((t (:foreground ,mag))))
   `(font-lock-regexp-grouping-backslash ((t (:foreground ,cyn))))
   `(font-lock-regexp-grouping-construct ((t (:foreground ,cyn))))
   `(font-lock-string-face        ((t (:foreground ,grn))))
   `(font-lock-type-face          ((t (:foreground ,cyn))))
   `(font-lock-variable-name-face ((t (:foreground ,mag))))
   `(font-lock-warning-face       ((t (:foreground ,gbr))))

   `(show-paren-match    ((t (:background ,cont :foreground ,gold))))
   `(show-paren-mismatch ((t (:background ,red :foreground ,bg))))

   `(isearch             ((t (:foreground ,bg :background ,gbr))))
   `(lazy-highlight      ((t (:foreground ,bg :background ,gold))))
   `(query-replace       ((t (:foreground ,bg :background ,gold))))

   `(button              ((t (:foreground ,blu :underline t))))
   `(link                ((t (:foreground ,blu :underline t))))
   `(link-visited        ((t (:foreground ,mag :underline t))))

   `(success             ((t (:foreground ,grn))))
   `(warning             ((t (:foreground ,gbr))))
   `(error               ((t (:foreground ,red))))

   `(header-line         ((t (:foreground ,fg :background ,surf))))
   `(vertical-border     ((t (:foreground ,bord))))
   `(window-divider      ((t (:foreground ,bord))))

   `(tab-bar             ((t (:background ,bg :foreground ,dim))))
   `(tab-bar-tab         ((t (:background ,gold :foreground ,bg))))
   `(tab-bar-tab-inactive ((t (:background ,bg :foreground ,dim))))

   `(tooltip             ((t (:foreground ,fg :background ,surf))))

   `(dired-directory     ((t (:foreground ,blu))))
   `(dired-header        ((t (:foreground ,gold))))
   `(dired-mark          ((t (:foreground ,gold))))

   `(widget-field        ((t (:background ,surf :foreground ,fg))))
   `(widget-button       ((t (:foreground ,blu :underline t))))
   `(widget-single-line-field ((t (:background ,surf :foreground ,fg))))))

(provide-theme 'emacs-oneshot)
