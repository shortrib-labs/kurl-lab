# Step by Step Setup

The following guide explains how to set up all three clusters in the lab going
step-by-step through each cluster and compomnent. Like the [lab that inspires
it](/Tanzu-Solutions-Engineering/tkg-lab) the process is guided by a file
name `params.yaml`. An encryped version of the parameters, as customized for
my environmnet, is included in the directory `secrets`.

## Prepare to Install

To prepare for your instalation, make sure you have all required command-line 
utilities installed. If you are on a Mac (or if you use Linnx Brew) you can 
install them using the provided `Brewfile`.

```bash
brew bundle install
```

To make things a bit simpler, there's also a target in the `Makefile` that will
install themi for you.

```bash
make brew
```


