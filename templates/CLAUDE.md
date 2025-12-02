# Project Standards

Ce fichier definit les conventions et bonnes pratiques du projet.

---

## Project Commands

Commandes a executer pour verifier le code avant commit/review.

```bash
# Linter / Formatage
# TODO: Adapter selon le projet
npm run lint          # ou: pnpm lint, yarn lint
npm run format        # ou: pnpm format, yarn format

# Type checking (TypeScript)
# TODO: Adapter selon le projet
npm run typecheck     # ou: tsc --noEmit

# Tests
# TODO: Adapter selon le projet
npm run test          # ou: pytest, vitest, jest

# Build
# TODO: Adapter selon le projet
npm run build         # ou: pnpm build, yarn build
```

**Important** : Dev et Review doivent executer ces commandes pour verifier que les regles sont respectees.

---

## 1. Naming Conventions

### Variables et Fonctions
- `snake_case` pour toutes les variables et fonctions
- Noms en anglais strict (zero francais)
- Noms explicites, pas d'abreviations obscures
- Abreviations standards OK : API, URL, ID, HTTP, JSON, SQL

### Classes et Types
- `PascalCase` pour classes, interfaces, types, enums
- `UPPER_CASE` pour les enum members et constantes

### Fichiers
- `snake_case` pour les noms de fichiers (ex: `my_service.ts`)

### Branches Git
- Format : `<scope>-<outcome>`
- Exemples : `cache-improve-hit-rate`, `auth-add-jwt-validation`

---

## 2. Code Structure

### Taille
- Maximum **200 lignes** par fichier
- Maximum **3 niveaux** d'imbrication (if/for/while)
- Complexite cyclomatique max **10** par fonction
- Longueur de ligne max **120 caracteres**

### Organisation
- Code organise en **classes** (sauf utils pures)
- Une classe = une responsabilite (SRP)
- Types centralises dans `common/types/`
- Enums centralises dans `common/enums/`
- Utils dans `common/utils/`
- Scripts dans `/scripts/` uniquement

---

## 3. Absolute Prohibitions

### Code interdit
- Aucun commentaire dans le code
- Aucune docstring
- Aucun `@ts-ignore`, `# noqa`, `eslint-disable`
- Aucun `any` (TypeScript strict)
- Aucun `console.log` (utiliser logger custom)
- Aucun `eval()`, `new Function()`, `setTimeout(string)`
- Aucun `alert()`, `debugger`
- Aucune ternaire imbriquee
- Aucun code hallucine (toujours reutiliser l'existant)
- Aucun emoji dans le code/tests (OK dans commits)
- Aucun code commente (ERA)
- Aucun code mort / variables inutilisees

---

## 4. Required Patterns

### Syntaxe
- `===` obligatoire (jamais `==`)
- Accolades `{}` obligatoires (meme sur une ligne)
- Arrow functions pour les callbacks
- Template literals (jamais de concatenation `+`)
- Object shorthand (`{ name }` pas `{ name: name }`)
- Return early (guards) pour eviter les imbrications
- `throw new Error()` (jamais `throw 'string'`)
- Double quotes `""` pour les strings

### Formatage
- Indentation 4 espaces
- 2 lignes vides apres les imports
- Trailing comma toujours presente
- Imports auto-organises par ESLint/isort

### Typage
- Types de retour explicites sur TOUTES les fonctions
- Pas de boolean en argument positionnel (utiliser kwargs nommes)
- Datetimes timezone-aware obligatoires
- Serializers pour toute transformation de donnees

---

## 5. Error Handling

- Exceptions specifiques (jamais `catch (e)` generique)
- Classes d'exception custom pour les erreurs metier
- Appels externes encapsules dans un service dedie + try/catch + logs
- Fallbacks explicites et justifies (pas de fallback silencieux)

---

## 6. Logs

- Format : `{timestamp} [{level}] [{function_name}] {context} {message}`
- Niveaux utilises : DEBUG, INFO, WARNING, ERROR, CRITICAL
- Logger custom (jamais `console.log` direct)
- Logs aux points cles du flux

---

## 7. Security

- Secrets dans secret manager (jamais dans le code)
- Validation des inputs aux frontieres systeme
- Pas de donnees sensibles en clair dans les logs
- Dependances avec versions fixees

---

## 8. Performance (Red Flags)

- Pas de requetes N+1 (requete dans une boucle)
- Pas de boucles imbriquees O(n2) evitables
- Pas de gros payloads inutiles
- Pas de memory leaks potentiels

---

## 9. Quality

- DRY respecte (zero duplication de code)
- Code mort supprime immediatement
- Simplifications appliquees (regles SIM)
- Clarte avant optimisation
- Si code touche : ameliorer autour si necessaire

---

## 10. API (si applicable)

- Format reponse : `{ data, meta, error }`
- HTTP Status stricts (200, 201, 400, 404, 500...)
- Null handling avec optional chaining (`?.`, `??`)

---

## 11. Tests

### Structure
```
tests/
├── unit/           # test_module_unit.ts
├── integration/    # test_module_integration.ts
└── e2e/            # test_module_e2e.ts
```

### Style Python (pytest)
```python
class TestModuleName:
    def test_returns_valid_when_data_correct(self) -> None:
        data = create_test_data()
        result = function_name(data)
        assert result.is_valid()
```

### Style TypeScript (Vitest)
```typescript
describe("function_name()", () => {
    it("returns valid result with correct data", () => {
        const data = create_test_data()
        const result = function_name(data)
        expect(result.is_valid).toBe(true)
    })
})
```

### Regles
- Coverage minimum : 80% (tests unitaires)
- Un describe/class par fonction
- Nommage : `test_<action>_when_<condition>`
- AAA implicite (pas de commentaires)

---

## 12. Git

### Commits
- Format : emoji + phrase descriptive
- Exemples :
  - `✨ Add user authentication with JWT`
  - `🐛 Fix login redirect loop`
  - `♻️ Refactor API client`

### Emojis standards
| Emoji | Usage |
|-------|-------|
| ✨ | New feature |
| 🐛 | Bug fix |
| 🔧 | Configuration / tooling |
| ♻️ | Refactoring |
| 🎨 | Style / formatting |
| 🔥 | Code removal |
| 📝 | Documentation |
| ⚡ | Performance |
| 🔒 | Security |
| ⬆️ | Dependencies update |

### Pull Requests
- Titre : `type(scope): description`
- Body structure avec emojis par section
- Pas de mention d'IA
