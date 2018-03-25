VERSION             := $(shell cat ./VERSION)
COMMIT_SHA          := $(shell git rev-parse --short HEAD)
ANSIBLE_ROLES_PATH  := $(shell realpath ./ansible/roles)
VAGRANT_IMAGE       := mylinux-$(VERSION)
DOCKER_FINAL_IMAGE  := cirocosta/mylinux


run-vagrant-build-machine:
	cd ./vagrant/build && \
		vagrant up


provision-vagrant-build-machine:
	cd ./vagrant/build && \
		vagrant provision


build-vagrant-image: 
	cd ./vagrant/build && \
		vagrant package --output $(VAGRANT_IMAGE).box
	cd ./vagrant/build && \
		vagrant box add $(VAGRANT_IMAGE) $(VAGRANT_IMAGE).box


image:
	docker build -t $(DOCKER_FINAL_IMAGE):$(VERSION) .
	docker tag $(DOCKER_FINAL_IMAGE):$(VERSION) $(DOCKER_FINAL_IMAGE):$(VERSION)-$(COMMIT_SHA)
	docker tag $(DOCKER_FINAL_IMAGE):$(VERSION) $(DOCKER_FINAL_IMAGE):latest


push:
	docker push $(DOCKER_FINAL_IMAGE):$(VERSION) 
	docker push $(DOCKER_FINAL_IMAGE):$(VERSION)-$(COMMIT_SHA)
	docker push $(DOCKER_FINAL_IMAGE):latest

