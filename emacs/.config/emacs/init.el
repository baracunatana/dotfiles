(setq native-comp-async-report-warnings-errors nil)

(setq package-enable-at-startup nil)

(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
                                    'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(setq straight-use-package-by-default t)

(scroll-bar-mode -1)        ; Desabilitar el scroll bar
(tool-bar-mode -1)          ; Desabilitar la barra de herramientas
(tooltip-mode -1)           ; Desabilitar tool tips
(set-fringe-mode 10)        ; Dar algo de espacio entre ventanas
(menu-bar-mode -1)          ; Desabilitar barra de menú
(global-visual-line-mode)   ; Word wrapping por defecto en todos los modos
(global-auto-revert-mode t) ; Activar global auto-revert

(set-face-attribute 'fixed-pitch nil :font "Inconsolata LGC")
(set-frame-font "Inconsolata LGC" nil t)

(use-package evil
  :custom
  ;; Inicia en modo NORMAL por defecto en todos los modos
  (evil-default-state 'normal)
  ;; Para evitar conflictos con TAB en org-mode
  (evil-want-C-i-jump nil)
  :init
  ;; Para evitar conflictos con evil-collection
  (setq evil-want-keybinding nil)
  :config
  ;; Arracnar evil-mode por defecto
  (evil-mode))

(use-package general
  :after evil
  :config
  ;; defniciión de tecla lider global para modo normal.
  (general-create-definer j/lider
    :states '(normal insert emacs)
    :keymaps 'override
    :prefix "SPC"
    :non-normal-prefix "M-SPC")

  ;; definición de tecla lider local (relativo al major mode) para modo normal.
  (general-create-definer j/lider-local
    :states '(normal insert emacs)
    :prefix "SPC m"
    :non-normal-prefix "M-SPC m"))

(use-package evil-collection
  :after evil
  :config 
  (with-eval-after-load 'magit (evil-collection-magit-setup))
  (with-eval-after-load 'dired (evil-collection-dired-setup))
  (with-eval-after-load 'dired (evil-collection-wdired-setup))
  (with-eval-after-load 'pdf-tools (evil-collection-pdf-setup))
  (with-eval-after-load 'nov (evil-collection-nov-setup)))

(use-package ivy
  :diminish ivy-mode
  :bind (:map ivy-minibuffer-map
              ("C-j" . ivy-next-line)
              ("C-k" . ivy-previous-line))
  :config
  (ivy-mode 1))

(use-package counsel
  :after ivy
  :config
  (global-set-key (kbd "M-x") 'counsel-M-x))

(use-package ivy-rich
  :after (ivy counsel)
  :init
  (ivy-rich-mode 1))

(use-package all-the-icons-ivy-rich
  :after ivy-rich
  :init (all-the-icons-ivy-rich-mode 1))

(use-package prescient
  :after ivy
  :config
  (use-package ivy-prescient
    :after counsel
    :config
    (ivy-prescient-mode)
    (prescient-persist-mode)))

(use-package all-the-icons)

(use-package doom-modeline
  :after 
  all-the-icons
  :init 
  ;; Activar doom-modeline en todos los modos
  (doom-modeline-mode 1))

(use-package which-key
  :config
  (which-key-mode))

(use-package modus-themes
  :config
  ;; Cargar los temas
  (modus-themes-load-themes)
  ;; Cargar modus-vivendi
  (modus-themes-load-vivendi))

(use-package helpful
  :after
  counsel
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :general
  (general-define-key
   :states '(normal insert emacs)
   :keymaps 'helpful-mode-map
   ;; Marcas
   "q" '(quit-window :which-key "salir")))

(use-package rainbow-delimiters
  :hook 
  (org-mode . rainbow-delimiters-mode)
  (prog-mode . rainbow-delimiters-mode))

(j/lider
  "SPC" '(evil-normal-state :which-key "volver a modo normal"))

(j/lider
  :infix "a"
  "" '(:ignore t :which-key "archivo")
  "a" '(counsel-find-file :which-key "abrir archivo")
  "A" '(counsel-recentf :which-key "abrir reciente")
  "g" '(save-buffer :which-key "guardar")
  "e" '(j/delete-file-and-buffer :which-key "cerrar y eliminar")
  "G" '(write-file :which-key "guardar como"))

(defun j/delete-file-and-buffer ()
  "Eliminar el archivo actual del disco duro y cierra su buffer"
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "De verdad quiere eliminar " filename " ?"))
            (progn
              (delete-file filename)
              (message "%s eliminado." filename)
              (kill-buffer)))
      (message "Este buffer no representaba un archivo"))))

(j/lider
  :infix "v"
  "" '(:ignore t :which-key "window")
  "e" '(evil-window-delete :which-key "cerrar ventaan")
  "d" '(evil-window-split :which-key "dividir horizontalmente")
  "<" '(evil-window-decrease-width :which-key "reducir ancho")
  ">" '(evil-window-increase-width :which-key "aumentar ancho")
  "j" '(evil-window-down :which-key "ir abajo")
  "q" '(evil-quit-all :which-key "salir de emacs")
  "k" '(evil-window-up :which-key "ir arriba")
  "h" '(evil-window-left :which-key "ir a izquierda")
  "l" '(evil-window-right :which-key "ir a derecha")
  "o" '(delete-other-windows :which-key "cerrar otras ventanas")
  "TAB" '(evil-window-next :which-key "siguiente ventana")
  "v" '(evil-window-vsplit :which-key "dividir verticalmente"))

(j/lider
  :infix "b"
  "" '(:ignore t :which-key "buffer")
  "e" '(kill-this-buffer :which-key "cerrar buffer")
  "k" '(previous-buffer :which-key "buffer previo")
  "-" '(text-scale-adjust :which-key "reducir fuente")
  "+" '(text-scale-adjust :which-key "aumentar fuente")
  "r" '(revert-buffer :which-key "revert-buffer")
  "v" '(visual-line-mode :which-key "visual-line-mode")
  "b" '(counsel-switch-buffer :which-key "buscar buffer")
  "u" '(evil-switch-to-windows-last-buffer :which-key "último buffer")
  "j" '(next-buffer :which-key "siguiente buffer"))

(j/lider
  :infix "h"
  "" '(:ignore t :which-key "ayuda")
  "m" '(describe-mode :which-key "describir modo")
  "f" '(counsel-describe-function :which-key "describir función")
  "v" '(counsel-describe-variable :which-key "describir variable")
  "K" '(describe-key-briefly :which-key "describe-key-briefly")
  "w" '(where-is :which-key "where-is")
  "F" '(counsel-describe-face :which-key "describir face")
  "t" '(helpful-key :which-key "describir tecla"))

(j/lider
  :infix "o"
  "" '(:ignore t :which-key "ir a")
  "a" '(org-agenda :which-key "agenda")
  "g" '(j/gtd :which-key "archivo gtd")
  "d" '(dired :which-key "dired")
  "s" '(eshell :which-key "eshell")
  "t" '(org-todo-list :which-key "lista completa TO-DO"))

(defun j/gtd ()
  "Abre archivo ~/personal/orgmode/gtd.org"
  (interactive)
  (find-file "~/personal/orgmode/gtd.org"))

(general-define-key
 :states '(normal)
 "j" '(evil-next-visual-line :which-key "siguiente linea visual")
 "k" '(evil-previous-visual-line :which-key "linea visual previa"))

(general-define-key
 :states '(normal)
 :infix "g"
 "h" '(evil-beginning-of-line :which-key "evil-beginning-of-line")
 "G" '(end-of-buffer :which-key "end-of-buffer")
 "j" '(evil-next-line :which-key "evil-next-linex")
 "k" '(evil-previous-line :which-key "evil-previous-line")
 "l" '(evil-end-of-line :which-key "evil-end-of-line"))

(use-package olivetti
  :custom
  (olivetti-body-width 80 "Tamaño (en número de carateres) del texto")
  :commands 
  (olivetti-mode))

(use-package ispell
  :custom 
  (ispell-dictionary "es" "Diccionario en español por defecto")
  :hook
  (text-mode . flyspell-mode))

(use-package org
  :commands (org-capture org-agenda)
  :hook
  (org-mode . (lambda () (electric-indent-local-mode -1)))
  :custom
  (org-startup-folded t)          ; Colapsar contenido al abrir un archivo
  (org-startup-align-all-table t) ; Empezar con las tablas colapsadas
  (org-startup-indented t)        ; Activar org-indent-mode por defecto 
  (org-tags-column 0)             ; Quitar espacio entre título y etiquetas
  (org-list-allow-alphabetical t) ; Permitir listas con letras
  (org-table-header-line-p t)     ; Congelar primera fila de tablas largas
  (org-todo-keywords '((sequence "TODO(t)"
                                 "ESPE(e)"
                                 "EMPE(m)"
                                 "PROY(p)"
                                 "FUTU(f)"
                                 "|" "DONE(d)"
                                 "CANC(c)")))
  (org-todo-keyword-faces '(("PROY" . (:foreground "#d33682" :weight bold))
                            ("ESPE" . (:foreground "#b58900" :weight bold))
                            ("EMPE" . (:foreground "#b58900" :weight bold))
                            ("DONE" . (:foreground "#859900" :weight bold))
                            ("CANC" . (:foreground "#859900" :weight bold))
                            ("FUTU" . (:foreground "#2aa198" :weight bold))
                            ("TODO" . (:foreground "#6c71c4" :weight bold))))
  
  (org-highest-priority ?A)
  (org-default-priority ?D)
  (org-lowest-priority ?D)
  (org-priority-faces '((?A . (:foreground "#dc322f" :weight bold))
                        (?B . (:foreground "#b58900" :weight bold))
                        (?C . (:foreground "#2aa198"))
                        (?D . (:foreground "#859900"))))
  
  
  (org-tag-persistent-alist '(("@Casa" . ?c)
                              ("@Oficina" . ?o)
                              ("@PC" . ?p)
                              ("@Internet" . ?i)
                              ("@Lectura" . ?l)
                              ("@Calle" . ?k)
                              ("#Docencia" . ?d)
                              ("#Carrera" . ?u)
                              ("#DevP" . ?v)
                              ("#ProyPer" . ?y)
                              ("#IngresoAdicional" . ?s)
                              ("#Puntos" . ?n)
                              ("Urgente" . ?g)
                              ("Corta" . ?r)
                              ("PasarBalon" . ?b)))
  (org-log-into-drawer "BITÁCORA")
  (org-latex-pdf-process '("tectonic %f"))
  (org-agenda-files '("~/personal/orgmode/gtd.org"))
  (org-agenda-window-setup 'current-window)
  (org-agenda-skip-scheduled-if-done t)
  (org-agenda-skip-deadline-if-done t)
  ;; Destinos hasta de nivel 3
  (org-refile-targets '((org-agenda-files :maxlevel . 3)))
  ;; Construcción del destino paso a paso
  (org-refile-use-outline-path 'file)
  (org-outline-path-complete-in-steps nil)
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(org-capture-mode-map)
    "r"   '(org-capture-refile :which-key "refile"))
  :config
  (setf (alist-get 'file org-link-frame-setup) #'find-file)
  (defun j/dwim-at-point (&optional arg)
    "Do-what-I-mean at point.
  If on a:
  - checkbox list item or todo heading: toggle it.
  - clock: update its time.
  - headline: cycle ARCHIVE subtrees, toggle latex fragments and inline images in
    subtree; update statistics cookies/checkboxes and ToCs.
  - footnote reference: jump to the footnote's definition
  - footnote definition: jump to the first reference of this footnote
  - table-row or a TBLFM: recalculate the table's formulas
  - table-cell: clear it and go into insert mode. If this is a formula cell,
    recaluclate it instead.
  - babel-call: execute the source block
  - statistics-cookie: update it.
  - latex fragment: toggle it.
  - link: follow it
  - otherwise, refresh all inline images in current tree."
    (interactive "P")
    (let* ((context (org-element-context))
           (type (org-element-type context)))
      ;; skip over unimportant contexts
      (while (and context (memq type '(verbatim code bold italic underline strike-through subscript superscript)))
        (setq context (org-element-property :parent context)
              type (org-element-type context)))
      (pcase type
        (`headline
         (cond ((memq (bound-and-true-p org-goto-map)
                      (current-active-maps))
                (org-goto-ret))
               ((and (fboundp 'toc-org-insert-toc)
                     (member "TOC" (org-get-tags)))
                (toc-org-insert-toc)
                (message "Updating table of contents"))
               ((string= "ARCHIVE" (car-safe (org-get-tags)))
                (org-force-cycle-archived))
               ((or (org-element-property :todo-type context)
                    (org-element-property :scheduled context))
                (org-todo
                 (if (eq (org-element-property :todo-type context) 'done)
                     (or (car (+org-get-todo-keywords-for (org-element-property :todo-keyword context)))
                         'todo)
                   'done))))
         ;; Update any metadata or inline previews in this subtree
         (org-update-checkbox-count)
         (org-update-parent-todo-statistics)
         (when (and (fboundp 'toc-org-insert-toc)
                    (member "TOC" (org-get-tags)))
           (toc-org-insert-toc)
           (message "Updating table of contents"))
         (let* ((beg (if (org-before-first-heading-p)
                         (line-beginning-position)
                       (save-excursion (org-back-to-heading) (point))))
                (end (if (org-before-first-heading-p)
                         (line-end-position)
                       (save-excursion (org-end-of-subtree) (point))))
                (overlays (ignore-errors (overlays-in beg end)))
                (latex-overlays
                 (cl-find-if (lambda (o) (eq (overlay-get o 'org-overlay-type) 'org-latex-overlay))
                             overlays))
                (image-overlays
                 (cl-find-if (lambda (o) (overlay-get o 'org-image-overlay))
                             overlays)))
           (+org--toggle-inline-images-in-subtree beg end)
           (if (or image-overlays latex-overlays)
               (org-clear-latex-preview beg end)
             (org--latex-preview-region beg end))))
  
        (`clock (org-clock-update-time-maybe))
  
        (`footnote-reference
         (org-footnote-goto-definition (org-element-property :label context)))
  
        (`footnote-definition
         (org-footnote-goto-previous-reference (org-element-property :label context)))
  
        ((or `planning `timestamp)
         (org-follow-timestamp-link))
  
        ((or `table `table-row)
         (if (org-at-TBLFM-p)
             (org-table-calc-current-TBLFM)
           (ignore-errors
             (save-excursion
               (goto-char (org-element-property :contents-begin context))
               (org-call-with-arg 'org-table-recalculate (or arg t))))))
  
        (`table-cell
         (org-table-blank-field)
         (org-table-recalculate arg)
         (when (and (string-empty-p (string-trim (org-table-get-field)))
                    (bound-and-true-p evil-local-mode))
           (evil-change-state 'insert)))
  
        (`babel-call
         (org-babel-lob-execute-maybe))
  
        (`statistics-cookie
         (save-excursion (org-update-statistics-cookies arg)))
  
        ((or `src-block `inline-src-block)
         (org-babel-execute-src-block arg))
  
        ((or `latex-fragment `latex-environment)
         (org-latex-preview arg))
  
        (`link
         (let* ((lineage (org-element-lineage context '(link) t))
                (path (org-element-property :path lineage)))
           (if (or (equal (org-element-property :type lineage) "img")
                   (and path (image-type-from-file-name path)))
               (+org--toggle-inline-images-in-subtree
                (org-element-property :begin lineage)
                (org-element-property :end lineage))
             (org-open-at-point arg))))
  
        ((guard (org-element-property :checkbox (org-element-lineage context '(item) t)))
         (let ((match (and (org-at-item-checkbox-p) (match-string 1))))
           (org-toggle-checkbox (if (equal match "[ ]") '(16)))))
  
        (_
         (if (or (org-in-regexp org-ts-regexp-both nil t)
                 (org-in-regexp org-tsr-regexp-both nil  t)
                 (org-in-regexp org-link-any-re nil t))
             (call-interactively #'org-open-at-point)
           (+org--toggle-inline-images-in-subtree
            (org-element-property :begin context)
            (org-element-property :end context)))))))
  
  (defun +org--toggle-inline-images-in-subtree (&optional beg end refresh)
    "Refresh inline image previews in the current heading/tree."
    (let ((beg (or beg
                   (if (org-before-first-heading-p)
                       (line-beginning-position)
                     (save-excursion (org-back-to-heading) (point)))))
          (end (or end
                   (if (org-before-first-heading-p)
                       (line-end-position)
                     (save-excursion (org-end-of-subtree) (point)))))
          (overlays (cl-remove-if-not (lambda (ov) (overlay-get ov 'org-image-overlay))
                                      (ignore-errors (overlays-in beg end)))))
      (dolist (ov overlays nil)
        (delete-overlay ov)
        (setq org-inline-image-overlays (delete ov org-inline-image-overlays)))
      (when (or refresh (not overlays))
        (org-display-inline-images t t beg end)
        t)))
  
  (defun +org-get-todo-keywords-for (&optional keyword)
    "Returns the list of todo keywords that KEYWORD belongs to."
    (when keyword
      (cl-loop for (type . keyword-spec)
               in (cl-remove-if-not #'listp org-todo-keywords)
               for keywords =
               (mapcar (lambda (x) (if (string-match "^\\([^(]+\\)(" x)
                                       (match-string 1 x)
                                     x))
                       keyword-spec)
               if (eq type 'sequence)
               if (member keyword keywords)
               return keywords)))
  (defun j/org-evaluate-if-actionable ()
    "Returns t if the task at point is actionable or nil if it isn't"
    (and (org-entry-get (point) "ACTIONABLE")
         (string< (org-read-date nil nil (org-entry-get (point) "ACTIONABLE"))
                  (org-read-date nil nil "+1"))))
  
  (defun j/org-process-task ()
    "Vefifies if a task is actionable. If it is, set it as actionable"
    (when (j/org-evaluate-if-actionable)
      (org-todo "TODO")
      (org-delete-property "ACTIONABLE")))
  
  (defun j/org-verify-actionable-tasks ()
    "Goes through al agenda files checking if FUTU tasks are actionable"
    (org-map-entries
     '(j/org-process-task)
     "/+FUTU" 'agenda))
  
  (defun j/org-actionable ()
    (j/org-verify-actionable-tasks))
  
  (defun j/org-set-futu ()
    "Cambiar el estado de una tarea a FUTU y definir la fecha en que se convierte en accionable"
    (interactive)
    (org-set-property "ACTIONABLE" (concat "[" (org-read-date nil nil nil "ACTIONABLE: ") "]"))
    (org-todo "FUTU"))
  (setq org-super-agenda-header-map (make-sparse-keymap))
  (with-eval-after-load 'org-agenda 
    (add-to-list 'org-agenda-prefix-format '(agenda . " %i %-12:c%?-12t% s %b"))
    (add-to-list 'org-agenda-prefix-format '(todo . " %i %-12:c %b")))
  ;; Definir la lista DESPUÉS de cargar org-capture. Esto es necesario porque de no tenerlo la lista de plantillas se reiniciaba
  
  (with-eval-after-load 'org-capture       
    (add-to-list 'org-capture-templates
                 '("l" "Tarea enlazada" ; l para una terea que incluya enlace a documento o correo
                   entry
                   (file+headline
                    "~/personal/orgmode/gtd.org" ; Guardar en gtd.org
                    "Inbox") ; Guarda por defecto en el headline Inbox
                   "* TODO [#D] %?\nOrigen o referencia: %a\n"))
    (add-to-list 'org-capture-templates
                 '("c" "Tarea de clipboard" ; c para una tarea que referencia información contenida en clipboard
                   entry
                   (file+headline
                    "~/personal/orgmode/gtd.org" ; Guardar en gtd.org
                    "Inbox") ; Guarda por defecto en el headline Inbox
                   "* TODO [#D] %? \n %x"))
    (add-to-list 'org-capture-templates
                 '("t" "Tarea simple" ; l para una terea que incluya enlace a documento o correo
                   entry
                   (file+headline
                    "~/personal/orgmode/gtd.org" ; Guardar en gtd.org
                    "Inbox") ; Guarda por defecto en el headline Inbox
                   "* TODO [#D] %? \n")))
  (j/lider
    "c" '(org-capture :which-key "org-capture"))
  (add-to-list 'org-modules 'org-habit)
  (general-define-key
   :states '(normal)
   :keymaps '(org-mode-map)
   "K"   '(org-previous-visible-heading :which-key "Encabezado previo")
   "J"   '(org-next-visible-heading :which-key "Encabezado siguiente")
   "H"   '(outline-up-heading :which-key "Encabezado siguiente"))
  (general-define-key
   :states '(normal)
   :keymaps '(org-mode-map)
   "RET" '(j/dwim-at-point :which-key "dwim"))
  
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(org-mode-map)
    "T"    '(org-babel-tangle :which-key "tangle"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(org-mode-map)
    "a"   '(org-archive-subtree-default :which-key "archivar")
    "p"   '(org-priority :which-key "prioridad")
    "q"   '(org-set-tags-command :which-key "etiquetas")
    "o"   '(org-set-property :which-key "propiedades")
    "t"   '(org-todo :which-key "propiedades")
    "r"   '(org-refile :which-key "refile")
    "e"   '(org-export-dispatch :which-key "exportar"))
  (j/lider-local
    :infix "j"
    :keymaps '(org-mode-map)
    "" '(:ignore t :which-key "reloj")
    "e" '(org-set-effort :which-key "definir esfuerzo")
    "E" '(org-inc-effort :which-key "aumentar esfuerzo")
    "i" '(org-clock-in :which-key "iniciar reloj")
    "I" '(org-clock-in-last :which-key "continuar reloj")
    "g" '(org-clock-goto :which-key "ir a actual")
    "c" '(org-clock-cancel :which-key "cancelar reloj")
    "o" '(org-clock-out :which-key "cerrar y eliminar"))
  
  ;; Manipulación del reloj desde menú de accesos directos 
  (j/lider
    :infix "o j"
    "" '(:ignore t :which-key "reloj")
    "I" '(org-clock-in-last :which-key "continuar reloj")
    "c" '(org-clock-cancel :which-key "cancelar reloj")
    "o" '(org-clock-out :which-key "cerrar y eliminar"))
  (j/lider-local
    :infix "c"
    :keymaps '(org-mode-map)
    "" '(:ignore t :which-key "calendario")
    "d" '(org-deadline :which-key "definir deadline")
    "f" '(j/org-set-futu :which-key "Aa futuro")
    "t" '(org-time-stamp-inactive :which-key "time stamp")
    "c" '(org-schedule :which-key "agendar"))
  (add-to-list 'evil-normal-state-modes 'org-agenda-mode)
  (general-define-key
   :states '(normal)
   :keymaps '(org-agenda-mode-map)
   "q" '(org-agenda-quit :which-key "salir")
   "r" '(org-agenda-redo :which-key "refrescar")
   "t" '(org-agenda-todo :which-key "cambiar estado")
   "c" '(org-agenda-schedule :which-key "agendar")
   "a" '(org-agenda-archive :which-key "archivar")
   "d" '(org-agenda-deadline :which-key "fecha límite")
   "p" '(org-agenda-priority :which-key "cambiar prioridad")
   "i" '(org-agenda-clock-in :which-key "iniciar reloj")
   "o" '(org-agenda-clock-out :which-key "cerrar reloj")
   "G" '(org-save-all-org-buffers :which-key "guardar archivos org")
   "RET" '(org-agenda-switch-to :which-key "visitar"))
  (defun my-beamer-bold (contents backend info)
    (when (eq backend 'beamer) ;;
      (replace-regexp-in-string "\\`\\\\[A-Za-z0-9]+" "\\\\textbf" contents)))
  ;;(add-to-list 'org-export-filter-bold-functions 'my-beamer-bold)
  (org-beamer-mode)
  :general
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(org-capture-mode-map)
    "r" '(org-capture-refile :which-key "org-capture-refile"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps 'org-mode-map
    :infix "f"
    "" '(:ignore t :which-key "Pie de página")
    "f" '(org-footnote-new :which-key "agregar pie de página")
    "n" '(org-footnote-normalize :which-key "normalizar pie de página"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps 'org-mode-map
    :infix "l"
    "" '(:ignore t :which-key "enlaces")
    "l" '(org-insert-link :which-key "crear enlace")
    "s" '(org-open-at-point :which-key "segir enlace")))

(use-package org-superstar
  :hook (org-mode . org-superstar-mode))

(use-package org-super-agenda    
  :after org-agenda
  :custom
  (org-super-agenda-groups '((:name "En seguimiento"
                                    :todo "ESPE")
                             (:name "Urgentes"
                                    :and (:not (:todo "DONE")
                                               :not (:todo "FUTU")
                                               :priority "A"))
                             ( :name "Importantes"
                                     :and ( :todo ("TODO" "EMPE")
                                                  :priority "B"))
                             ( :name "Cortas (<30 min)"
                                     :and ( :todo "TODO"
                                                  :effort< "30")))
                           "Grupos de super-agenda")
  :config
  (org-super-agenda-mode))

(use-package org-ref
  :after org
  :custom
  (org-ref-default-citation-link "citep")
  (reftex-default-bibliography '("~/biblioteca/main.bib"))
  (org-ref-default-bibliography '("~/biblioteca/main.bib"))
  (org-ref-pdf-directory "~/biblioteca/")
  (bibtex-dialect 'biblatex)
  :config
  (org-ref-ivy-cite-completion)
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps 'org-mode-map
    "}" '(org-ref-ivy-insert-ref-link :which-key "insertar referencia")
    "]" '(org-ref-ivy-insert-cite-link :which-key "insertar cita")))

(use-package org-ql
  :after org)

(use-package yasnippet
  :after (evil general)
  :diminish yas-minor-mode
  :config
  (yas-global-mode)
  (yas-reload-all)
  (j/lider
    "y" '(yas-insert-snippet :which-key "insertar plantilla")))

(use-package yasnippet-snippets
  :after yasnippet
  :config (yasnippet-snippets-initialize))

(use-package dired
  :straight (:type built-in)
  :commands (dired dired-jump)
  :custom
  (dired-recursive-copies 'always)
  (dired-recursive-deletes 'always)
  :config
  (put 'dired-find-alternate-file 'disabled nil))

(use-package all-the-icons-dired
  :after dired
  :hook (dired-mode . all-the-icons-dired-mode))

(use-package magit
  :commands (magit-status magit-init magit-clone)
  :init
  (j/lider
    :infix "o"
    "M" '(magit-status :which-key "magit")))

(use-package projectile
  :custom
  (projectile-enable-caching t)                   ; Para acelerar 
  (projectile-globally-ignored-files '("*.org~"))
  (projectile-completion-system 'ivy) 

  :config
  (projectile-mode)
  (setq projectile-enable-caching t))

(use-package counsel-projectile
  :after projectile
  :config
  (counsel-projectile-mode))

(j/lider
  "p" '(:keymap projectile-command-map :which-key "projectile"))

(use-package pdf-tools
  :mode
  ("\\.pdf\\'" . pdf-view-mode)

  :config
  (pdf-tools-install))

(use-package pocket-reader
  :commands pocket-reader
  :general
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps 'pocket-reader-mode-map
    "r" '(pocket-reader-refresh :which-key "refrescar")
    "h" '(pocket-reader-open-in-external-browser :which-key "ver en navegador"))
  
  (general-define-key
   :states '(normal insert emacs)
   :keymaps 'pocket-reader-mode-map
   "RET" '(pocket-reader-open-url :which-key "ver entrada")))

(use-package kmacro 
  :general
  (j/lider
    :infix "k"
    "" '(:ignore t :which-key "kmacro")
    "g" '(kmacro-start-macro :which-key "grabar")
    "d" '(kmacro-end-macro :which-key "detener grabación")
    "c" '(kmacro-insert-counter :which-key "insertar contador")
    "e" '(kmacro-set-counter :which-key "establecer contador")
    "s" '(kmacro-add-counter :which-key "adicionar a contador")
    "k" '(kmacro-call-macro :which-key "ejecutar macro")))

(use-package mu4e
  :straight (:local-repo 
             "/run/current-system/sw/share/emacs/site-lisp/mu4e"
             :pre-build ())
  :init
  
  :commands mu4e
  :custom
  (mu4e-get-mail-command "mbsync -c ~/.mbsyncrc -a")
  (mu4e-attachment-dir  "~/Downloads")
  (mu4e-change-filenames-when-moving t)
  (mu4e-update-interval (* 60 60))
  (mu4e-headers-fields `((:human-date . 12)
                         (:flags . 4)
                         (:from-or-to . 15)
                         (:subject)))
  (mu4e-headers-auto-update t)
  (mu4e-view-prefer-html t)
  (mu4e-confirm-quit nil)
  (mu4e-view-show-images t)
  (mu4e-view-show-addresses 't)
  (mu4e-headers-visible-lines 16)
  (mu4e-completing-read-function 'ivy-completing-read)
  (mu4e-compose-signature-auto-include nil)
  (mu4e-bookmarks `(( :name "PUJ último mes"
                            :query "maildir:/puj/INBOX date:4w.."
                            :key ?j)))
  (mu4e-compose-in-new-frame t)
  (mu4e-sent-messages-behavior 'sent)
  (mu4e-context-policy 'pick-first)
  (mu4e-compose-context-policy 'always-ask) 
  :hook
  (mu4e-compose-mode . turn-off-auto-fill)
  (mu4e-compose-mode . visual-line-mode)
  :config 
  (when (fboundp 'imagemagick-register-types)
    (imagemagick-register-types))
  (add-to-list 'mu4e-view-actions
               '("hver en html" . mu4e-action-view-in-browser) t)
  (add-to-list 
   'mu4e-contexts 
   (make-mu4e-context 
    :name "trabajo"
    :match-func
    (lambda (msg)
      (when msg
        (string-prefix-p "/puj" (mu4e-message-field msg :maildir))))
    :vars '((user-mail-address . "je.gomezm@javeriana.edu.co")
            (user-full-name . "Juan E. Gómez-Morantes")
            (mu4e-sent-folder . "/puj/Sent Items")
            (mu4e-drafts-folder . "/puj/Drafts")
            (mu4e-trash-folder . "/puj/Trash")
            (mu4e-refile-folder . "/puj/Archive")
            (smtpmail-queue-dir . "~/mbsync/puj/queue/cur")
            (message-send-mail-function . smtpmail-send-it)
            (smtpmail-smtp-user . "je.gomezm@javeriana.edu.co")
            (smtpmail-starttls-credentials . (("smtp.office365.com" 587 nil nil)))
            (smtpmail-auth-credentials . (expand-file-name "~/.authinfo.gpg"))
            (smtpmail-default-smtp-server . "smtp.office365.com")
            (smtpmail-smtp-server . "smtp.office365.com")
            (smtpmail-smtp-service . 587)
            (smtpmail-debug-info . t)
            (smtpmail-debug-verbose . t))))
  (add-to-list 
   'mu4e-contexts 
   (make-mu4e-context   
    :name "gmail-jee" 
    :match-func
    (lambda (msg)
      (when msg
        (string-prefix-p "/gmail-jee" (mu4e-message-field msg :maildir))))
    :vars '((user-mail-address . "juanerasmoe@gmail.com")
            (user-full-name . "Juan E. Gómez-Morantes")
            (mu4e-sent-folder . "/gmail-jee/[Gmail].Sent Mail")
            (mu4e-drafts-folder . "/gmail-jee/[Gmail].drafts")
            (mu4e-trash-folder . "/gmail-jee/[Gmail].Trash")
            (mu4e-refile-folder . "/gmail-jee/[Gmail].All Mail")
            (smtpmail-queue-dir . "~/mbsync/puj/queue/cur")
            (message-send-mail-function . smtpmail-send-it)
            (smtpmail-smtp-user . "juanerasmoe@gmail.com")
            (smtpmail-starttls-credentials . (("smtp.gmail.com" 587 nil nil)))
            (smtpmail-auth-credentials . (expand-file-name "~/.authinfo.gpg"))
            (smtpmail-default-smtp-server . "smtp.gmail.com")
            (smtpmail-smtp-server . "smtp.gmail.com")
            (smtpmail-smtp-service . 587)
            (smtpmail-debug-info . t)
            (smtpmail-debug-verbose . t))))
  (require 'org-mu4e)
  (setq org-mu4e-link-query-in-headers-mode nil)
  (add-to-list 'evil-normal-state-modes 'mu4e-main-mode)
  (add-to-list 'evil-normal-state-modes 'mu4e-headers-mode)
  (add-to-list 'evil-normal-state-modes 'mu4e-view-mode)
  :general 
  (j/lider
    :infix "o"
    "m" '(mu4e :which-key "mu4e")
    "n" '(mu4e-compose-new :which-key "nuevo correo"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(mu4e-main-mode-map mu4e-headers-mode-map mu4e-view-mode-map)
    "b" '(mu4e-headers-search :which-key "buscar")
    "i" '(mu4e~headers-jump-to-maildir :which-key "ir a carptea"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(mu4e-headers-mode-map mu4e-view-mode-map mu4e-main-mode-map)
    "u" '(mu4e-update-mail-and-index :which-key "actualizar e indexar"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(mu4e-headers-mode-map mu4e-view-mode-map mu4e-main-mode-map)
    ;; Composición
    "n" '(mu4e-compose-new :which-key "nuevo correo"))
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps '(mu4e-headers-mode-map mu4e-view-mode-map)
    ;; Composición
    "r" '(mu4e-compose-reply :which-key "responder")
    "R" '(mu4e-compose-forward :which-key "re-enviar"))
  (general-define-key
   :states '(normal insert emacs)
   :keymaps 'mu4e-main-mode-map
   "q" '(mu4e-quit :which-key "salir")
   "b" '(mu4e-headers-search-bookmark :which-key "bookmarks"))
  (general-define-key
   :states '(normal insert emacs)
   :keymaps 'mu4e-headers-mode-map
   ;; Marcas 
   "D" '(mu4e-mark-unmark-all :which-key "desmarcar todos")
   "m" '(mu4e-headers-mark-for-move :which-key "mover")
   "r" '(mu4e-headers-mark-for-refile :which-key "refile")
   "e" '(mu4e-headers-mark-for-trash :which-key "eliminar")
   "x" '(mu4e-mark-execute-all :which-key "ejecutar acciones")
   "E" '(mu4e-headers-mark-for-delete :which-key "eliminar permanentemente")
   "d" '(mu4e-headers-mark-for-unmark :which-key "desmarcar")
   ;; Operación básica del modo
   "b" '(mu4e-headers-search-bookmark :which-key "bookmarks")
   "RET" '(mu4e-headers-view-message :which-key "ver mensaje") 
   "q" '(mu4e~headers-quit-buffer :which-key "salir")
   "j" '(mu4e-headers-next :which-key "siguiente mensaje")
   "k" '(mu4e-headers-prev :which-key "mensaje anterior"))
  
  (j/lider-local
    :states '(normal insert emacs)
    :keymaps 'mu4e-headers-mode-map
    "h" '(mu4e-headers-toggle-threading :which-key "alternar hilo")
    "l" '(mu4e-headers-toggle-include-related :which-key "alternar relacionados"))
  (general-define-key
   :states '(normal insert emacs)
   :keymaps 'mu4e-view-mode-map
   ;; Marcas
   "m" '(mu4e-view-mark-for-move :which-key "mover")
   "r" '(mu4e-view-mark-for-refile :which-key "refile")
   "e" '(mu4e-view-mark-for-trash :which-key "eliminar")
   "E" '(mu4e-view-mark-for-delete :which-key "eliminar permanentemente")
   "x" '(mu4e-mark-execute-all :which-key "ejecutar acciones")
   "d" '(mu4e-view-mark-for-unmark :which-key "desmarcar")
   ;; Básicas del modo
   "b" '(mu4e-headers-search-bookmark :which-key "bookmarks")
   "q" '(mu4e~view-quit-buffer :which-key "salir")
   "J" '(mu4e-view-headers-next :which-key "siguiente mensaje")
   "K" '(mu4e-view-headers-prev :which-key "mensaje anterior")
   "j" '(evil-next-line :which-key "siguiente linea")
   "k" '(evil-previous-line :which-key "línea anterior"))
  
  (j/lider-local 
    :states '(normal insert emacs)
    :keymaps 'mu4e-view-mode-map
    "g" '(mu4e-view-go-to-url :which-key "ir a URL")
    "C" '(mu4e~view-compose-contact :which-key "copiar dirección en punto")
    "b" '(mu4e-view-open-attachment :which-key "abrir adjunto")
    "a" '(mu4e-view-action :which-key "acciones")
    "A" '(mu4e-view-mime-part-action :which-key "acciones de partes"))
  (j/lider-local 
    :states '(normal insert emacs)
    :keymaps 'gnus-mime-button-map
    "v" '(gnus-mime-view-part :which-key "ver")
    "g" '(gnus-mime-save-part :which-key "guardar")
    "a" '(gnus-mime-action-on-part :which-key "acciones")))

(require 'mu4e-icalendar)
(mu4e-icalendar-setup)

(use-package org-mime
  :after mu4e)
(use-package smtpmail
  :after mu4e)

(use-package org-msg
  ;;:straight (prg-msg :type git :host github :repo "jeremy-compostella/org-msg"
  ;;                   :fork ( :host github
  ;;                           :repo "Chris00/org-msg"
  ;;                           :branch "MML"))
  :after mu4e
  :custom
  (mail-user-agent 'mu4e-user-agent)
  (org-msg-options "html-postamble:nil H:5 num:nil ^:{} toc:nil author:nil email:nil \\n:t")
  (org-msg-startup "hidestars indent inlineimages")
  (org-msg-greeting-fmt "\nQué tal %s,\n\n")
  (org-msg-greeting-name-limit 3)
  (org-msg-text-plain-alternative t)
  (org-msg-signature "
          Saludos,
          #+begin_signature
          Juan E. Gómez-Morantes, PhD \\\\
          Profesor Asistente \\\\
          Departamento de Ingeniería de Sistemas \\\\
          Pontificia Universidad Javeriana \\\\
          #+end_signature")

  :config
  
  ;; Para evitar el problema de columnas angostas en outlook web, se defe redefinir la plantilla css usada por org-msg.
  ;; Eso está definido en =org-msg-default-style= y se asigna a =org-msg-enforce-css. A continuación se crea otra plantilla y se hace la asignación.
  (defconst j/org-msg-default-style
    (let* ((font-family '(font-family . "\"Arial\""))
           (font-size '(font-size . "10pt"))
           (font `(,font-family ,font-size))
           (line-height '(line-height . "10pt"))
           (bold '(font-weight . "bold"))
           (theme-color "#0071c5")
           (color `(color . ,theme-color))
           (table `(,@font (margin-top . "0px")))
           (ftl-number `(,@font ,color ,bold (text-align . "left")))
           (inline-modes '(asl c c++ conf cpp csv diff ditaa emacs-lisp
                               fundamental ini json makefile man org plantuml
                               python sh xml))
           (inline-src `((color . ,(face-foreground 'default))
                         (background-color . ,(face-background 'default))))
           (code-src
            (mapcar (lambda (mode)
                      `(code ,(intern (concat "src src-" (symbol-name mode)))
                             ,inline-src))
                    inline-modes)))
      `((del nil (,@font (color . "grey") (border-left . "none")
                         (text-decoration . "line-through") (margin-bottom . "0px")
                         (margin-top . "10px") (line-height . "11pt")))
        (a nil (,color))
        (a reply-header ((color . "black") (text-decoration . "none")))
        (div reply-header ((padding . "3.0pt 0in 0in 0in")
                           (border-top . "solid #e1e1e1 1.0pt")
                           (margin-bottom . "20px")))
        (span underline ((text-decoration . "underline")))
        (li nil (,@font ,line-height (margin-bottom . "0px")
                        (margin-top . "2px")))
        (nil org-ul ((list-style-type . "square")))
        (nil org-ol (,@font ,line-height (margin-bottom . "0px")
                            (margin-top . "0px") (margin-left . "30px")
                            (padding-top . "0px") (padding-left . "5px")))
        (nil signature (,@font (margin-bottom . "20px")))
        (blockquote nil ((padding-left . "5px") (margin-left . "10px")
                         (margin-top . "20px") (margin-bottom . "0")
                         (border-left . "3px solid #ccc") (font-style . "italic")
                         (background . "#f9f9f9")))
        (code nil (,font-size (font-family . "monospace") (background . "#f9f9f9")))
        ,@code-src
        (nil linenr ((padding-right . "1em")
                     (color . "black")
                     (background-color . "#aaaaaa")))
        (pre nil ((line-height . "12pt")
                  ,@inline-src
                  (margin . "0px")
                  (font-size . "9pt")
                  (font-family . "monospace")))
        (div org-src-container ((margin-top . "10px")))
        (nil figure-number ,ftl-number)
        (nil table-number)
        (caption nil ((text-align . "left")
                      (background . ,theme-color)
                      (color . "white")
                      ,bold))
        (nil t-above ((caption-side . "top")))
        (nil t-bottom ((caption-side . "bottom")))
        (nil listing-number ,ftl-number)
        (nil figure ,ftl-number)
        (nil org-src-name ,ftl-number)

        (table nil (,@table ,line-height (border-collapse . "collapse")))
        (th nil ((border . "1px solid black")
                 (background-color . ,theme-color)
                 (color . "white")
                 (padding-left . "10px") (padding-right . "10px")))
        (td nil (,@table (padding-left . "10px") (padding-right . "10px")
                         (background-color . "#f9f9f9") (border . "1px solid black")))
        (td org-left ((text-align . "left")))
        (td org-right ((text-align . "right")))
        (td org-center ((text-align . "center")))

        (div outline-text-4 ((margin-left . "15px")))
        (div outline-4 ((margin-left . "10px")))
        (h4 nil ((margin-bottom . "0px") (font-size . "11pt")
                 ,font-family))
        (h3 nil ((margin-bottom . "0px") (text-decoration . "underline")
                 ,color (font-size . "12pt")
                 ,font-family))
        (h2 nil ((margin-top . "20px") (margin-bottom . "20px")
                 (font-style . "italic") ,color (font-size . "13pt")
                 ,font-family))
        (h1 nil ((margin-top . "20px")
                 (margin-bottom . "0px") ,color (font-size . "12pt")
                 ,font-family))
        (p nil ((text-decoration . "none") (margin-bottom . "0px")
                (margin-top . "10px") (line-height . "11pt") ,font-size
                ,font-family
                ;;(max-width . "100ch")
                ))
        (div nil (,@font (line-height . "11pt"))))))
  (setq org-msg-enforce-css j/org-msg-default-style)
  ;; Evitar que org-msg interfiera con la aceptación de invitaciones de calendario 
  (defun j/deshabilitar-org-msg (orig-fun &rest args)
    (let ((activo org-msg-mode))
      (org-msg-mode -1)
      (apply orig-fun args)
      (if activo
          (org-msg-mode))))

  ;; (advice-add 'gnus-article-press-button :around #'j/deshabilitar-org-msg)
  ;; activar el modo
  (org-msg-mode))

(use-package mu4e-column-faces
  :after mu4e
  :config (mu4e-column-faces-mode))

(use-package excorporate
  :defer 3

  :custom
  (excorporate-configuration
   '("je.gomezm@javeriana.edu.co" . "https://outlook.office365.com/EWS/Exchange.asmx"))
  (excorporate-calendar-show-day-function 'exco-calfw-show-day)
  (org-agenda-include-diary t)

  :config
  (excorporate)
  (excorporate-diary-enable)
  (run-with-timer 30 (* 60 60) 'j/actualizar-diario-con-exchange)

  :init
  (defun j/actualizar-diario-con-exchange ()
    (interactive)
    "Usa excorporate para actualizar el diario con las citas del día"
    (exco-diary-diary-advice (calendar-current-date) (calendar-current-date) #'message "citas actualizadas")))

(use-package nov
  :mode
  ("\\.epub\\'" . nov-mode)

  :hook
  (nov-mode . olivetti-mode)
  (nov-mode . (lambda ()
                (face-remap-add-relative
                 'variable-pitch :family "EB Garamond"
                 :height 1.5))))
