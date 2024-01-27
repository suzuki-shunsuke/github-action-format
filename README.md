# github-action-format

GitHub Actions to format code and push commit

This action executes the given command to format code.
If code isn't changed, this means code is originally formatted, so the action succeeds.
If code is changed, this means code isn't originally formatted, so the action fails.
If code is changed and the input `skip_push` is `false`, this action commits the change and pushes the commit to the remote branch.

## Requirements

- [ghcp](https://github.com/int128/ghcp)

## License

[MIT](LICENSE)
