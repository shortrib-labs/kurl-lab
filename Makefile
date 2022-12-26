SOURCE_DIR=$(PWD)/src
SECRETS_DIR=$(PWD)/secrets

tfvars := $(SECRETS_DIR)/terrform.tfvars
params_yaml := $(SECRETS_DIR)/params.yaml

cluster_name ?= $(shell yq .cluster_name $(params_yaml))
kurl_yaml		 := $$(yq '.spec.kubernetes.clusterName="$(cluster_name)"' kurl-installer.yaml)

vsphere_server    := "$(shell yq .vsphere.server $(params_yaml))"
vsphere_username  := "$(shell yq .vsphere.username $(params_yaml))"
vsphere_password  := "$(shell sops --decrypt --extract '["vsphere"]["password"]' $(params_yaml))"
vsphere_pool      := "$(shell yq .vsphere.resource_pool $(params_yaml))"
vsphere_datastore := "$(shell yq .vsphere.datastore $(params_yaml))"

template_image  := https://storage.googleapis.com/capv-images/release/v1.23.5/ubuntu-2004-kube-v1.23.5.ova 
template_file   := /tmp/ubuntu-2004-kube-v1.23.8 
template_folder := /garage/vm/templates/tanzu

key_fp  := FAC1CF820538F4A07C8F4657DAD5DC6A21303194

define TFVARS
cluster_name				 = "$(cluster_name)"
domain					 = "$(shell yq e .domain $(params_yaml))"
project_root		 = "$(PROJECT_DIR)"

remote_ovf_url	 = "$(shell yq .remote_ovf_url $(params_yaml))"

ssh_authorized_keys = $(shell yq --output-format json .ssh.authorized_keys $(params_yaml))

workers =  "$(shell yq .cluster.workers $(params_yaml))"

cpus			= "$(shell yq .node.cpus $(params_yaml))"
memory		= "$(shell yq .node.memory $(params_yaml))"
disk_size = "$(shell yq .node.disk_size $(params_yaml))"

vsphere_server	 = "$(vsphere_server)"
vsphere_username = "$(vsphere_username)"
vsphere_password = "$(vsphere_password)"

vsphere_datacenter		= "$(shell yq .vsphere.datacenter $(params_yaml))"
vsphere_cluster				= "$(shell yq .vsphere.cluster $(params_yaml))"
vsphere_host					= "$(shell yq .vsphere.host $(params_yaml))"
vsphere_resource_pool = "$(vsphere_pool)

vsphere_network				 = "$(shell yq .vsphere.network $(params_yaml))"
vsphere_datastore			 = "$(vsphere_datastore)"

vsphere_folder				 = "$(shell yq .vsphere.folder $(params_yaml))"

kurl_script = "curl $(shell curl --silent -H 'Content-Type: text/yaml' --data-raw "$(kurl_yaml)" 'https://kurl.sh/installer' && echo "") | sudo bash"
endef

.PHONY: tfvars
tfvars: $(tfvars)

export TFVARS
$(tfvars): $(params_yaml)
	@echo "$$TFVARS" > $@

.PHONY: init
init: $(tfvars)
	@(cd $(SOURCE_DIR)/terraform && terraform init)

.PHONY: all
all: create 

.PHONY: create
create: init test cluster bootstrap

.PHONY: cluster
cluster: $(tfvars) init
	@(cd $(SOURCE_DIR)/terraform && terraform apply -var-file $(tfvars) --auto-approve)

.PHONY: bootstrap
bootstrap:
	@VSPHERE_USERNAME=$(vpshere_username) VSPHERE_PASSWORD=$(vsphere_password) clusterctl init --infrastructure vsphere --kubeconfig $(SECRETS_DIR)/kubeconfig
	@kubectl app ly -f https://raw.githubusercontent.com/shortrib-labs/management-cluster/main/base/flux-system/gotk-components.yaml

.PHONY: template
template: $(template_file)
	@govc import.ova -u $(vsphere_username):$(vsphere_password)@$(vsphere_server) -ds $(vsphere_datastore) -pool $(vsphere_pool) -k -folder $(template_folder) $(template_file)

$(template_file):
	@curl --output $(template_file) $(template_image)

.PHONY: test
test: $(tfvars)
	@(cd $(SOURCE_DIR)/terraform && terraform plan -var-file $(tfvars))

.PHONY: destroy
destroy: $(tfvars)
	@(cd $(SOURCE_DIR)/terraform && terraform destroy -var-file $(tfvars) --auto-approve)

clean:
	@rm $(tfvars)

.PHONY: encrypt
encrypt: 
	@sops --encrypt --in-place $(params_yaml)

.PHONY: decrypt
decrypt: 
	@sops --decrypt --in-place $(params_yaml)
