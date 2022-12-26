# kURL Lab

In this lab, we will create a Kubernetes platform for a development team
that distributes its software using [Replicated](https://replicated.com).
The environment is made up of three three clusters and inspired by the
[TKG Lab](/Tanzu-Solutions-Engineering/tkg-lab) and [FRSCA](/buildsec/frsca)
projects. All clusters are deployed using [kURL](https://kurl.sh) with 
supporting packages installed using [KOTS](https://kots.io).

The initial implemenation of the lab is for vSphere, but support for AWS,
Azure, and GCP is forthcoming. The current implementations directly leverage
vSphere/vSAN for disk management, but may move to OpenEBS in the future.

Packages installed in all clusters via kURL:

- **Contour** for ingress
- **cert-manager** for certificate management
- **Velero** for backup/restore, via Tanzu Mission Control
- **Prometheus** for monitoring
- **Fluentd** for logging

Additional packages installed in all clusters:

- **vSphere CSI** to leverage vSphere first class disks as Kubernetes volumes
- **kube-vip** for Virtual IP and load balancer support
- **Kyverno** for Kuberenetes native policy controls

Leverages the following external services:

- **Okta** as an OIDC provider
- **Let's Encrypt** as Certificate Authority
- **Sigstore** for signing, attestations, SBOMs and other metadata

Additional components installed into the management cluster:

- **Elasticsearch and Kibana** for log aggregation and viewing
- **Vault** for secret management
- **Spire** for SPIFFE identity control

Additional components installed into the platform cluster:

- **Minio** for object storage (via kURL)
- **Harbor** as a local container and Helm chart registry
- **Tekton** for continuous integration and delivery
- **Tekton Chains** to apply signatures and make attestations

## Goals and Audience

The goal of this repository is to provide Replicated team members with a
[secure softare factory](https://github.com/cncf/tag-security/blob/main/supply-chain-security/secure-software-factory/Secure_Software_Factory_Whitepaper.pdf)
to demonstrate best practices to vendors delivering their software with 
[Replicated](https://replicated.com).

## Required CLIs

- kubectl
- kots
- preflight and support-bundle kubectl plugins (nice to have for troubleshooting)
- velero
- helm 
- yq 
- jq

## Foundational Lab Setup Guides

There are are few options to setup the foundation lab setup of three clusters:
management cluster, platform cluster, and a workload cluster.

1. [Step by Step Guide](docs/step-by-step.md) - Provides instructional guidance
   for each step, along with validation actions.  This is the best option for
   really learning how each cluster is setup and develop experience with the
   enterprise packages and integrations configured for the lab.
2. [One Step Scripted Deployment](docs/one-step.md) - This method assumes you
   have done any required manual steps.  There is one script that will deploy
   all clusters and perform integrations.  It is best to use this after you
   have already completed the step by step guide, as any specific configuration
   issue you may would have been worked out in that process previously.

