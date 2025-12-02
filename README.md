# Claude-Teams-Dev

Systeme de workflow multi-instances pour Claude Code simulant une equipe de developpement complete.

## Concept

Transforme une session Claude Code en **Product Owner** qui orchestre plusieurs instances Dev en parallele, coordonne les reviews de code et les tests QA.

```
┌─────────────────────────────────────────────────────────┐
│                    Session PO (vous)                     │
│  - Planifie les taches                                  │
│  - Lance les instances Dev                              │
│  - Coordonne Review & QA                                │
│  - Cree les Pull Requests                               │
└─────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Dev 001   │      │   Dev 002   │      │   Dev 003   │
│  (Terminal) │      │  (Terminal) │      │  (Terminal) │
└─────────────┘      └─────────────┘      └─────────────┘
```

## Installation

### Option 1 : One-liner PowerShell

```powershell
irm https://raw.githubusercontent.com/ethan/Claude-Teams-Dev/main/install.ps1 | iex
```

### Option 2 : Manuelle

```powershell
git clone https://github.com/ethan/Claude-Teams-Dev.git
cd Claude-Teams-Dev
.\install.ps1
```

## Utilisation

1. Lancez Claude Code dans votre projet
2. Tapez `/workflow-start` pour activer le mode PO
3. Decrivez ce que vous voulez accomplir
4. Le PO propose un plan de taches
5. Validez et les instances Dev sont lancees en parallele
6. Recevez une notification quand une instance termine
7. Lancez Review puis QA
8. Creez la Pull Request

## Commandes

| Commande | Description |
|----------|-------------|
| `/workflow-start` | Active le mode PO orchestrateur |
| `/workflow-status` | Affiche l'etat de toutes les instances |

## Structure

```
.claude/
├── commands/
│   ├── workflow-start.md    # Activation mode PO
│   └── workflow-status.md   # Monitoring
└── settings.json            # Hooks de notification

.workflow/
├── scripts/
│   └── notify_po.ps1        # Script notification Windows
├── instances/
│   └── dev-task-XXX/        # Dossiers par instance
│       ├── prompt.md        # Tache assignee
│       ├── rapport.md       # Rapport de l'instance
│       ├── review-feedback.md
│       └── qa-feedback.md
└── notifications.jsonl      # Notifications temps reel

CLAUDE.md                    # Best practices du projet
```

## Workflow Detaille

### 1. Planification

Le PO analyse votre demande et propose un decoupage :

```
| # | Tache | Description | Dependances |
|---|-------|-------------|-------------|
| 001 | auth-add-jwt | Ajouter validation JWT | - |
| 002 | api-secure-endpoints | Securiser les endpoints | 001 |
```

### 2. Execution

Chaque Dev :
- Cree sa branche `<scope>-<outcome>`
- Code la fonctionnalite
- Ecrit un rapport dans `rapport.md`
- Notifie le PO via `notifications.jsonl`

### 3. Review

Le sub-agent Review verifie :
- Conventions de nommage (snake_case, PascalCase)
- Structure (200 lignes max, 3 niveaux max)
- Interdictions (pas de comments, any, console.log)
- Patterns obligatoires
- Securite et performance

### 4. QA

Le sub-agent QA :
- Ecrit les tests unitaires et integration
- Execute les tests
- Verifie la couverture (80% minimum)
- Valide l'absence de regressions

### 5. Pull Request

Le PO cree la PR avec :
- Resume des changements
- Plan de test
- Lien vers les rapports

## Best Practices Incluses

Le fichier `CLAUDE.md` installe definit les standards :

- **Nommage** : snake_case variables/fonctions, PascalCase classes
- **Structure** : 200 lignes max, 3 niveaux imbrication max
- **Interdictions** : pas de comments, docstrings, any, console.log
- **Patterns** : ===, accolades obligatoires, arrow functions, template literals
- **Tests** : pytest classes / Vitest describe, 80% coverage unit
- **Git** : branches `<scope>-<outcome>`, commits emoji + phrase

## Configuration

### Modifier les best practices

Editez `CLAUDE.md` a la racine de votre projet.

### Personnaliser les notifications

Modifiez `.workflow/scripts/notify_po.ps1` pour changer le comportement des alertes.

## Prerequis

- Windows 10/11
- Windows Terminal
- Claude Code CLI
- PowerShell 5.1+
- Git

## Licence

MIT
