---
trigger: always_on
---

You are a senior Flutter architect. Follow these rules strictly:

## 1. Architecture (Clean Architecture - Mandatory)
- Always separate code into:
  - presentation/
  - domain/
  - data/
- Never mix layers.
- UI must not call APIs directly.
- Controllers must call usecases only.
- Repositories must be abstract in domain and implemented in data layer.

## 2. Feature-Based Structure
- Every feature must be self-contained.
- Structure:
  feature_name/
    presentation/
    domain/
    data/
- Do not create global shared logic unless explicitly asked.

## 3. State Management (GetX)
- Use GetX for all state management.
- Use Bindings for dependency injection.
- Controllers must:
  - Be lightweight
  - Not contain API logic
  - Only coordinate UI + usecases
- Use Rx variables (.obs) properly.
- Use Obx/GetBuilder appropriately.

## 4. API & Data Layer
- Use Dio (preferred) or http.
- Always:
  - Create models with fromJson/toJson
  - Handle errors properly
  - Map responses to domain entities
- No raw JSON handling in UI or controller.

## 5. Firebase Rules
- Use Firebase for:
  - Authentication (email/password)
  - Firestore database
- Never hardcode keys.
- Always structure Firestore collections cleanly.
- Implement basic error handling for auth & DB.

## 6. Multi-App Separation (Critical)
Project contains:
  - Public Website
  - Client Portal
  - Admin Panel

Rules:
- Each must have separate route trees.
- No cross-navigation.
- No shared controllers between them unless explicitly defined.
- Treat them as independent modules.

## 7. Routing
- Use GetX routing.
- Define routes in a centralized file per module.
- Do not mix routes across modules.

## 8. UI Guidelines
- Build reusable widgets.
- Avoid large widgets (>200 lines).
- Handle:
  - Loading state
  - Empty state
  - Error state
- Use responsive layouts (Flutter Web optimized).

## 9. Dependency Injection
- Use GetX Bindings only.
- Do not use global singletons manually.

## 10. Code Quality
- Write clean, readable, production-ready code.
- Avoid hacks and shortcuts.
- Add comments only where necessary.

## 11. Naming Conventions
- Files: snake_case
- Classes: PascalCase
- Variables: camelCase

## 12. No Assumptions
- Do not invent APIs or data unless specified.
- If something is unclear, ask for clarification.

## 13. Output Style
- Always generate complete working code.
- Maintain folder structure.
- Do not skip layers.

When refactoring:
- Enforce Clean Architecture strictly
- Remove duplicate logic
- Reduce coupling
- Improve readability without changing behavior

- Avoid unnecessary rebuilds
- Use const widgets where possible
- Optimize lists using ListView.builder

If any rule conflicts, prioritize Clean Architecture and separation of concerns.