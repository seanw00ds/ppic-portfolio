# Goal 3: Software Development Tools

**Plan (AT1):** Git and GitHub, GitHub Actions and Docker, all from the Software Development module. Then apply them by containerising a real client application and adding a CI pipeline.
**Starting point (skills audit):** Git, used daily. CI/CD, limited. Docker, **None**.

## Module quizzes
| Quiz | Result |
|---|---|
| GitHub Essentials, Quiz 1 | 10/10 ([evidence](evidence/quiz1-github-essentials-10of10.jpg)) |
| GitHub Workflow, Quiz 2 | 10/10 ([evidence](evidence/quiz2-github-workflow-10of10.jpg)) |

## Applied work: containerising the Woods Websites site
The target was my business website, a Next.js 16 app that deploys to Cloudflare Workers. The Docker work was done on a separate `docker` branch so the live deploy was never touched.

### Attempt 1: naive Dockerfile ([Dockerfile.v1-naive](docker/Dockerfile.v1-naive))
- It worked ([screenshot](evidence/v1-site-running-in-container.jpg)), but it was poorly built.
- With no `.dockerignore`, the whole folder was copied in, including `node_modules` and old builds. The build context was 1.26 GB.
- The full `node:22` base image produced a 5.56 GB final image.
- It used `next start`, which the container logs flagged as the wrong command for a standalone build.

### Attempt 2: multi-stage Dockerfile ([Dockerfile](docker/Dockerfile), [.dockerignore](docker/dockerignore.txt))
| | v1 | v2 |
|---|---|---|
| Build context | 1.26 GB | 8.8 KB |
| Image size | 5.56 GB | 494 MB |
| Rebuild after a one-line page edit | full reinstall | 8.8 s (`npm ci` layer cached) |

The changes:
- Added a `.dockerignore`, which also keeps `.env` files out of the image.
- Switched to the `node:22-slim` base image.
- Copied `package.json` before the rest of the code, so the install step is cached.
- Used a two-stage build, so only the standalone output ships in the final image.

### CI pipeline ([docker-ci.yml](docker/docker-ci.yml))
On every push to the branch, and on pull requests into `main`, GitHub Actions does the following:
1. Builds the image. This also runs the TypeScript check.
2. Starts the container.
3. Smoke-tests `/`, `/about` and `/contact` for HTTP 200.
4. Prints the container logs if anything fails.

To prove the pipeline catches problems, I pushed a deliberate type error first:
- **Run #1 failed** at the build step with `Type 'string' is not assignable to type 'number'` ([screenshot](evidence/ci-red-run-type-error.jpg)).
- **Run #2 passed** after I reverted the error. All three pages returned 200.

Both runs: [screenshot](evidence/ci-red-then-green-runs.jpg) · [live run history](https://github.com/mwoods-1/woods-websites/actions/workflows/docker-ci.yml)
