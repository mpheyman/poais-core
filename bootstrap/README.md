# Bootstrap

Scaffold for initializing a product repo. The init scripts copy from here when creating `products/<name>/` and `portfolio/`.

## Skeleton

| Skeleton | Layout |
|----------|--------|
| [portfolio-repo-skeleton/](portfolio-repo-skeleton/) | `products/product-a/`, `products/product-b/` (each with CONTEXT, PLAN, DECISIONS, STATUS, DISCOVERY, RISKS, ROADMAP, EXECUTION, INPUTS/, MEETINGS/, FEATURES/, IDEAS/), plus `portfolio/` (PRIORITIES.md, STATUS.md). |

Init always uses this scaffold. Optional product names: `bash poais-init.sh [REPO_URL] name1 name2` or `-ProductNames name1,name2` on Windows; default is product-a, product-b. See [README Setup](../README.md#setup) and [GETTING_STARTED](../GETTING_STARTED.md).
