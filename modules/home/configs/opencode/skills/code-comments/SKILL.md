---
name: code-comments
description: Writes and revises code comments in plain language. Use when adding, changing, or reviewing code comments, especially when a comment must explain why code exists and what it does.
---

# Code Comments

Only add a comment when the reason for the code is not clear from the code itself, or when the user asks for one.

When writing a comment:

- Explain why the code is needed and what it does.
- Use plain language that a developer unfamiliar with the task can understand.
- Include concrete details such as timings, limits, user behavior, or backend behavior when they matter.
- Describe the actual problem instead of hiding it behind jargon.
- Give enough context that the reader does not need the related ticket.
- Prefer two clear sentences when one sentence would be vague or compressed.

Avoid phrases such as "long-lived session", "data freshness", "stale state", "periodic synchronization", "refresh cadence", "ensure consistency", and "handle edge cases" when plain words are clearer.

Technical terms are appropriate when they name a real part of the system, such as a backend cache, GraphQL request, or browser storage.

## Bad Examples

```ts
// Refresh location-based plans during long-lived sessions.
```

This does not explain which plans are affected, why they need refreshing, or how often it happens.

```ts
// Periodically synchronize membership data to avoid stale state.
```

This hides simple behavior behind jargon and does not explain the actual problem.

```ts
// Poll the endpoint every 30 minutes.
```

This explains what the code does but not why it is necessary.

## Good Examples

```ts
// The backend caches the user's available plans for one hour to prevent switching plans with a VPN.
// Refetch every 30 minutes so the plans update after that cache expires, even if the page stays open.
```

```ts
// Store the selected plan before opening the login dialog.
// The registration flow needs it after login, when the original dialog has already closed.
```

```ts
// Close the current dialog before opening the fallback offer.
// Otherwise the first dialog remains on top and receives the user's button clicks.
```

Before finishing a comment, check whether it answers:

1. What does this code do?
2. Why is that behavior needed?
3. What real problem does it prevent?
4. Which timing, limit, or external behavior makes it necessary?

Do not translate the code into English. Record the context that the code cannot explain by itself.
