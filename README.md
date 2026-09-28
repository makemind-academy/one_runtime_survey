# one-runtime-survey

The claim under test: the screens in this corpus are drawn by one runtime, the player's, and no sample carries a renderer of its own.

Article: [one-runtime-for-everything](https://makemind.dev/en/build/one-runtime-for-everything)

## What is here

- `survey.sh` — reads its sibling samples and prints what each one ships: how many servers, how many bundles, whether it carries a copy of the runtime, and which `mcp_server` it pins.
- `captures/survey.txt` — the table that run produced.
- `verify.sh` — the check.

Its subject is the corpus, so it is the one sample that reads the others.

## Verify

```bash
bash verify.sh
```

Fails if any sample carries a runtime copy or a Flutter app of its own, if fewer than thirty samples are surveyed, or if the servers span more than one major version of `mcp_server`.
