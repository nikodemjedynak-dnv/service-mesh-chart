echo `date` > results/run-date.txt

helm template test-release ../charts/platform-service -f values.yaml \
     > results/base-case.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set gateway.exposeService=false \
    > results/not-exposed.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set deploymentOnly=true \
    > results/deployment-only.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.enabled=false \
    > results/vs-default-routing-disabled.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.retries.enabled=true \
    --show-only templates/virtualservice.yaml \
    > results/vs-with-retries.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.allHosts=true \
    --show-only templates/virtualservice.yaml \
    > results/vs-all-hosts.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.urlPrefixes= \
    --show-only templates/virtualservice.yaml \
    > results/vs-no-urlPrefixes.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.rewriteUrlPrefix.enabled=false \
    --show-only templates/virtualservice.yaml \
    > results/vs-rewriteUrlPrefix-disabled.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.redirectOnNoTrailingSlash=false \
    --show-only templates/virtualservice.yaml \
    > results/vs-no-slash-redirect.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    -f cors-policy-values.yaml \
    --show-only templates/virtualservice.yaml \
    > results/vs-cors-policy.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.urlExactMatches[0]="url1",defaultRouting.urlExactMatches[0]="url2" \
    --show-only templates/virtualservice.yaml \
    > results/vs-exact-matches.yaml

helm template test-release ../charts/platform-service -f values.yaml \
    --set defaultRouting.deprecatedHostsWhichRedirect[0]="subdomain1.olddomain.com" \
    --show-only templates/virtualservice.yaml \
    > results/vs-deprecatedHosts.yaml

kubeval --ignore-missing-schemas results/*.yaml
