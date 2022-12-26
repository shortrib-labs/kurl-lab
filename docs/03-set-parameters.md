# Set Installation Parameters

The parameters in your repository are still the onces for my environment. Not
only that, but they're encrypted with my PGP key. You'll need to set them for
your environment in order to use them.

Before editing the file, let's remove the `sops` key from the file so that we
can re-encrytped it with your key layer.

```bash
yq 'del(.sops)' ${PARAMS_YAML}
```

Removing the SOPS metadata means you can now edit the file directly without
SOPS complaining when you try to encrypted it. Update the file to set the
values for your own lab.

| Key | Description |
|-----|-------------|
| domain | the subdomain for the cluster |
| default_password | a password for the default user `ubuntu` on the cluster VMs |
| ssh.authorized_keys | a list of SSH public keys you want to use to access the system |
| management_cluster.name | a name for the management clsuter, will be used in node hostnames and be a SAN for the cluster's TLS certificate |
| management_cluster.workers | the numbers of workers for the mnagaement cluster |
| management_cluster.kubvip_cidr | a CIDR range for `kube-vip` to use to management virtual IPs and load balancer services |
| node.cpus | number of vCPUs for cluster nodes, currently the same for all nodes created |
| node.memory | memory for each cluster node, also the same for all nodes created |
| node.disk_size | disk size for all nodes created |
| vsphere.servrer | your vCenter hostname |
| vsphere.username | the vCenter user to use to create the nodes |
| vsphere.password | the password for the vCenter user |
| vsphere.datacenter | the vSphere data center the nodes will be created in |
| vsphere.cluster | the vSphere cluster the nodes will be created in |
| vsphere.host | the vSphere host the nodes will be created on, required by Terraform even if it's a HA cluster |
| vsphere.resource_pool | the vSphere resource pool to assign the nodes to |
| vsphere.network | the vSphere network (porgroup) to attach the nodes to |
| vsphere.datastore | the vSphere/vSAN datastore to create node volumes on |
| vsphere.folder | the inventory folder to store node volumes in |
| cloudflare.api-key | a CloudFlare API key to use for DNS challenges with Let's Encrypt |

You'll notice that the sensitive files all start with `ENC[` becuase they have
been previously encrypted by SOPS. Replace those values with plain text. You
will encrypt them again next.

```bash
make encrypt
```

Take a look at the file any you'll notice the sensitive entries are encrypted
and the SOPS metadata has been set for your own configuration.

## Go to Next Step

[Create the Management Cluster](04-create-management-cluster.md)
