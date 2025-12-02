# Workflow Status - Monitoring des Instances

Affiche l'etat de toutes les instances Dev en cours.

## Instructions

1. Lis le fichier `/.workflow/notifications.jsonl` pour voir les dernieres notifications
2. Pour chaque dossier dans `/.workflow/instances/`, lis le `status.json`
3. Pour les instances avec statut "done", lis le `rapport.md`
4. Pour les branches actives, execute `git diff main...<branch>` pour voir les changements

## Format de Sortie

```
Workflow Status - [date/heure]

Instances Actives: X

---

dev-task-001 | <branch-name>
Status: IN_PROGRESS / REVIEW / QA / DONE / PR_CREATED
Duree: Xmin
Derniere activite: il y a Xmin

Fichiers modifies (git diff):
- `src/xxx.ts` (+X, -Y)
- `src/yyy.ts` (+X, -Y)

Dernieres lignes du rapport:
> [extrait du rapport.md]

---

dev-task-002 | <branch-name>
Status: REVIEW
Duree: Xmin
Review feedback: En attente de corrections

Fichiers modifies:
- `src/zzz.ts` (+X, -Y)

Feedback Review:
> - Probleme 1
> - Probleme 2

---

dev-task-003 | <branch-name>
Status: QA_PASSED
Duree: Xmin
Pret pour merge

Fichiers modifies:
- `src/aaa.ts` (+X, -Y)

QA Report:
> Tests unitaires: X/X passed
> Pas de regression
> Coverage: XX%
```

## Actions Disponibles

Apres avoir affiche le statut, propose les actions pertinentes :
- Si une instance est DONE : "Lancer Review pour dev-task-XXX ?"
- Si Review APPROVED : "Lancer QA pour dev-task-XXX ?"
- Si QA PASSED : "Creer PR pour dev-task-XXX ?"
- Si CONFLICT : "Relancer l'instance pour resoudre les conflits ?"
