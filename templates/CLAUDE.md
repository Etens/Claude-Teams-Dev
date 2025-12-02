# Best Practices - Code Standards

Ce fichier definit les conventions et bonnes pratiques du projet.

---

## Nommage

### Variables et Fonctions
- `snake_case` pour toutes les variables et fonctions
- Noms en anglais strict
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

## Structure

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

## Interdictions Absolues

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
- Aucun code commente
- Aucun code mort / variables inutilisees

---

## Patterns Obligatoires

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

### Typage
- Types de retour explicites sur toutes les fonctions
- Pas de boolean en argument positionnel
- Datetimes timezone-aware obligatoires
- Serializers pour toute transformation de donnees

---

## Gestion des Erreurs

- Exceptions specifiques (jamais `catch (e)` generique)
- Classes d'exception custom pour les erreurs metier
- Appels externes : service dedie + try/catch + logs
- Fallbacks explicites et justifies

---

## Logs

- Format : `{timestamp} [{level}] [{function_name}] {context} {message}`
- Niveaux : DEBUG, INFO, WARNING, ERROR, CRITICAL
- Logger custom (jamais `console.log` direct)

---

## Tests

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

## API

- Format reponse : `{ data, meta, error }`
- HTTP Status stricts (200, 201, 400, 404, 500...)
- Validation aux frontieres systeme
- Null handling avec optional chaining (`?.`, `??`)

---

## Git

### Commits
- Format : emoji + phrase descriptive
- Exemples :
  - `Add user authentication with JWT`
  - `Fix login redirect loop`
  - `Refactor API client`

### Pull Requests
- Titre : `type(scope): description`
- Body structure avec emojis par section
- Pas de mention d'IA

---

## Performance (Red Flags)

- Pas de requetes N+1
- Pas de boucles imbriquees O(n2)
- Pas de gros payloads inutiles
- Pas de memory leaks
