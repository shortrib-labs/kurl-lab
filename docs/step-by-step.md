# Step by Step Setup

The following guide explains how to set up all three clusters in the lab going
step-by-step through each cluster and compomnent. Like the [lab that inspires
it](/Tanzu-Solutions-Engineering/tkg-lab) the process is guided by a file name
`params.yaml`. An encryped version of the parameters, as customized for my
environmnet, is included in the directory `secrets`.

## Prepare to Install

You'll have to do a few things to prepare for the install. First and foremost,
you should fork this repository and pick up reading this file again from there.
I mean it. There are a few files you're going to want to overwrite with your
own values you the best way to do that is to fork this repo and traack those
changes in your own fork.

```bash
gh fork repo shortrib-labs/kurl-lab
cd kurl-lab
```

Now change switch to the version of this file in your fork and follow along
from there. I'll wait.

Back? Great, let's keep going.

1. [Install required tools](01-install-required-tools.md)
2. [Prepare for encryption](02-prepare-for-encryption)
