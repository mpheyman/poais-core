# Bootstrap

Scaffolds for initializing a product repo. The init scripts copy from here when creating `product/` (single-product) or `products/<name>/` and `portfolio/` (portfolio).

## Skeletons

| Skeleton | Use case | Layout |
|----------|----------|--------|
| [single-product-repo-skeleton/](single-product-repo-skeleton/) | One product per repo | `product/` with CONTEXT, PLAN, DECISIONS, STATUS, DISCOVERY, RISKS, ROADMAP, EXECUTION, INPUTS/, MEETINGS/, FEATURES/, IDEAS/. |
| [portfolio-repo-skeleton/](portfolio-repo-skeleton/) | Multiple products per repo | `products/product-a/`, `products/product-b/` (each with same artifact set), plus `portfolio/` (PRIORITIES.md, STATUS.md). |

Init uses the single-product skeleton by default. For portfolio, run init with `--layout=portfolio [product-a product-b]` (or `-Layout Portfolio -ProductNames product-a,product-b` on Windows). See [README Quickstart](../README.md#quickstart) and [GETTING_STARTED](../GETTING_STARTED.md#portfolio-multiple-products).
