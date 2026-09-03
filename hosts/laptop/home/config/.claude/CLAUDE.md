# Talking with Me

You and I are very experienced developers who talk in short, concise language. I do not have time nor the will to read long summary paragraphs. Use lists, bullets, and short prose when communicating with me. 

We talk in short concise sentences, do not use puffery language, or unnecessary elaboration. Do not use metaphors with me and do not use the following phrases while talking with me:

- "Let's dive in"
- "At a high level"
- "In the grand scheme of things"
- "At the end of the day"
- "load bearing"
- "smoking gun"
- "game changer"
- "paradigm shift"

## Scope 

When implementing features or fixing bugs, focus on the specific task at hand. Do not make unrelated changes. If you need to make changes to multiple files, do so in a structured and organized manner.
If you see changes that should be made, you may propose them at the end of your task for me to approve.

## Asking me Questions

Use the interactive ask tool to get multiple-choice questions answered.
For when you need questions answered that do not fit within a multiple-choice format, clearly list the questions at the end of your response for me to read.

## Summaries

I always see the chat from the bottom up so put the most important things last in your responses. Keep your summaries short and concise, and do not include unnecessary technical details.
I will ask for more detail if I want it.

# Implementation

## Commenting

Large block comments are a sign of code that is not well-structured or clear in its intent.

When you write comments, follow these rules

1. Comments should never be a summary of code beneath it. If the code is originally written in a way where I can understand its intent without a comment, then no comment is needed.
2. Comments should never be able to drift away from the code they are commenting on. You should attempt to make the comment a unit test instead of a comment.
3. Long verbose comments that reference technical terms and jargon make it hard to read without advanced knowledge of the codebase and technologies.
4. Use the /unslop skill when writing comments as that conveys the language and structure I would like from comments.

## Git Permissions

You are not allowed to commit or push to the git repository unless I give you explicit permission. 

If I give you permission, you may commit and push changes to the git repository but with the following rules:

1. Use conventional commit messages (https://www.conventionalcommits.org/en/v1.0.0/)
2. Do not put any description in the commit, single lines only
3. Verify that only the specific changes you are writing a commit for are staged. I sometimes have multiple changes in progress, so be careful to only stage the ones relevant to the commit.

## File Editing

You must use the edit tool to make changes to files. You are not allowed to make changes to the files with Python, perl, or any other tool. You may do find/replace operations with grep, awk, and other bash utilities.

## Bad Code Hygene

You are not allowed to use the following semantics in code:

- Using counters to track state or iterations when a more appropriate data structure or pattern could be used.
- Using magic numbers or strings without defining them as constants or enums.
- Complex state management in UI componentes should be moved to a manager class in Svelte
  - If there are more than a few functions or state variables, all state management for that component should be moved to a manager class.
  - The manager class should handle all state transitions and provide a clean API for the UI components to interact with the state.
- 

## Preferred Development Tools/Technologies

- mise: Tool management, project configuration, and script aliases.
- git: Version control for managing code changes.
- pnpm: Package management for JavaScript/TypeScript projects.
- typescript: You are not allowed to write JavaScript when TypeScript is available.
- svelte: Frontend framework for building user interfaces. React is not allowed for new projects.
    - shadcn-svelte: Component library for building consistent and accessible UI components in Svelte projects.
    - openapi: OpenAPI should be used for all API specifications. Client side code should be generated from the OpenAPI specs.
    - zod: Schema validation for TypeScript, often used in conjunction with OpenAPI generated code.
    - vitest: Testing framework for TypeScript projects, often used with Svelte and other frontend frameworks.
- go: Preferred language for anything that is not UI development.
    - uber/fx: Dependency injection framework for Go.
    - fuego: HTTP server framework. (https://github.com/go-fuego/fuego). This provides openapi generation.
- sqlite: Lightweight, serverless database suitable for small to medium-sized applications.
- postgres: A powerful, open-source relational database suitable for larger applications.

You may use alternative tools outside of this list only with my explicit permission.

## Preferred Development Practices

### Domain-Driven Design (DDD)

Use Domain-Driven Design (DDD) principles for structuring code and models when possible. Explicit structures for common use cases are listed below.

#### Web Servers

When developing server components, use the following patterns:

- Controllers: Any logic specific to a transport (ie server endpoint definitions, decoding of params, error building, etc).
- Services: Business logic and domain-specific operations. Controllers may call services to perform these operations.
- Repositories: Data access layer for interacting with databases or other persistence mechanisms. Services may use repositories to retrieve or persist domain entities.

- Services may not call other services to prevent circular dependencies.
- Use dependency injection to provide each controller with services and each service with repositories.

- DTOs: Data Transfer Objects for moving data between layers, typically used to encapsulate data being passed between controllers and services or for API responses.


### File naming conventions

- Use kebab-case for file names, e.g., user-controller.ts, user-service.ts.
- Use PascalCase for any UI components or files, e.g., UserCard.svelte, UserProfile.svelte.
- Use snake_case for database table names and column names, e.g., user_accounts, first_name.
- Use camelCase for variable and function names, e.g., userName, getUserProfile().
- Use UPPER_SNAKE_CASE for environment variables and constants, e.g., DATABASE_URL, MAX_RETRIES.
- Use UPPER_SNAKE_CASE for enum values, e.g., USER_ROLE_ADMIN, STATUS_ACTIVE.
- Use camelCase for property names in JSON or TypeScript interfaces, e.g., userName, getUserProfile().
- Use kebab-case for CSS class names, e.g., user-card, profile-section.
- Use kebab-case for HTML attribute names, e.g., data-user-id, role-type.
- Use camelCase for any query parameters, e.g., userId, sortBy.
- Use kebab-case for URL paths, e.g., /user-profile, /account-settings.