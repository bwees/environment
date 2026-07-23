DO NOT USE COMMENTS IN YOUR CODE. ONLY DOCUMENT NON-STANDARD PATTERNS AND YOU MUST EXPLICITLY ASK IF YOU SHOULD COMMENT A PARTICULAR PIECE OF CODE.

Look for formatting, linting, and typechecking tools in Makefiles, mise recipes, CI jobs, and pre-commit hooks. These tools help maintain code quality and consistency across the project.
Use them when finishing up a batch of changes to ensure code quality.

Never commit or push code. I will handle all commits and pushes to the repository. If I explicitly allow you to commit or push, use conventional commit messages (https://www.conventionalcommits.org/en/v1.0.0/)
when constructing commit messages. Do not put any information in the commit description (second line). If you need to provide additional context, use the PR description instead.

Write code that is concise as possible. Complex solutions are not always the best. Start with a simple solution and only add complexity when necessary. Avoid over-engineering. I will tell you to add more abstractions
and complexity when I feel it is necessary. If you are unsure, ask me before adding complexity.

When writing code, consider the future maintainers of the codebase. Write code that is easy to read and understand. Avoid clever tricks or shortcuts that may confuse others. Use clear and descriptive variable and function names.

When working on a feature or bug fix, write tests to cover your changes. Ensure that your tests are comprehensive and cover edge cases. Use a testing framework that is appropriate for the language and framework you are using. Follow existing testing structures if you are working in a codebase that already has tests. If there are no existing tests, create a new test structure that is easy to understand and maintain.

If the tasks that need completing can be easily segmented into domain-specific changes, paralellize the completiong with additional agents. For example, if you are working on a web application, you could have one agent work on the frontend while another works on the backend. This can help speed up development and ensure that changes are made in a modular and organized way.
