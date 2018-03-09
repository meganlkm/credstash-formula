FORMULA_NAME = "credstash"
PWD = $(shell pwd)

# ---------------------------------------------------------------
define render_dockerfile
	python $(PWD)/tools/filltmpl.py $(FORMULA_NAME) $(1)
endef

define docker_build
	docker build --force-rm -t $(FORMULA_NAME):salt-testing-$(1) -f Dockerfile.$(1) .
endef

define run_tests
	./tools/run-tests.sh $(FORMULA_NAME) $(1)
endef

# --- convenience functions -------------------------------------
define build_thing
	$(call render_dockerfile,$(1)) && $(call docker_build,$(1))
endef

define run_local_tests
	$(call build_thing,$(1)) && $(call run_tests,$(1))
endef

define run_sandbox
	docker pull simplyadrian/allsalt:$(1)
	docker run --rm -d \
		-v ${PWD}/credstash:/srv/salt/credstash \
		-v ${PWD}:/opt/credstash-formula \
		-e "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}" \
		-e "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}" \
		-e "AWS_REGION=${AWS_REGION}" \
		-h sandbox-salt-master-$(1) \
		--name sandbox-salt-master-$(1) \
		simplyadrian/allsalt:$(1)
	# docker exec -it sandbox-salt-master-$(1) bash
endef


# ---------------------------------------------------------------
setup:
	pip install Jinja2

clean:
	find . -name '*.pyc' -exec rm '{}' ';'
	rm -rf Dockerfile.*
	# delete pytest caches...
	# rm -rf tests/pytests/*/.pytest_cache
	# rm -rf tests/pytests/*/__pycache__
	rm -rf tests/pytests/apply-all-tests/.pytest_cache
	rm -rf tests/pytests/apply-all-tests/__pycache__
	# legacy ---
	# docker kill $(docker_ps)
	# docker rmi --force $(IMAGE_NAME)
	# rm -rf .dependencies
	# rm -rf salt/_modules


# --- centos_master_2017.7.2 ------------------------------------
test-centos_master_2017.7.2: clean
	$(call run_local_tests,centos_master_2017.7.2)

local-centos_master_2017.7.2: clean
	$(call run_sandbox,centos_master_2017.7.2)

# --- debian_master_2017.7.2 ------------------------------------
test-debian_master_2017.7.2: clean
	$(call run_local_tests,debian_master_2017.7.2)

local-debian_master_2017.7.2: clean
	$(call run_sandbox,debian_master_2017.7.2)

# --- opensuse_master_2017.7.2 ------------------------------------
test-opensuse_master_2017.7.2: clean
	$(call run_local_tests,opensuse_master_2017.7.2)

local-opensuse_master_2017.7.2: clean
	$(call run_local,opensuse_master_2017.7.2)

# --- ubuntu_master_2016.11.3 ------------------------------------
test-ubuntu_master_2016.11.3: clean
	$(call run_local_tests,ubuntu_master_2016.11.3)

local-ubuntu_master_2016.11.3: clean
	$(call run_sandbox,ubuntu_master_2016.11.3)

# --- ubuntu_master_2017.7.2 ------------------------------------
test-ubuntu_master_2017.7.2: clean
	$(call run_local_tests,ubuntu_master_2017.7.2)

local-ubuntu_master_2017.7.2: clean
	$(call run_sandbox,ubuntu_master_2017.7.2)


# --- legacy ----------------------------------------------------
IMAGE_NAME="credstash-setup"
docker_ps=`docker ps -f ancestor=$(IMAGE_NAME) -q`

build:
	rm -rf allsalt/ .dependencies/
	git clone https://github.com/simplyadrian/allsalt.git
	mkdir -p .dependencies
	cd .dependencies && git clone https://github.com/intuitivetechnologygroup/salt-aws-boto3.git
	mkdir -p salt/_modules
	cp -r .dependencies/salt-aws-boto3/aws_boto3 salt/_modules/
	docker build -t $(IMAGE_NAME) allsalt/debian/
	rm -rf allsalt/

run:
	docker run -d -v $(PWD)/salt:/srv/salt -e "AWS_REGION=us-west-1" $(IMAGE_NAME)

restart:
	docker restart $(docker_ps)

keys:
	docker exec $(docker_ps) salt-key

apply-state:
	docker exec $(docker_ps) salt -l all '*' state.apply $(filter-out $@,$(MAKECMDGOALS))

salt-cmd:
	docker exec $(docker_ps) salt -l all '*' $(filter-out $@,$(MAKECMDGOALS))

sync-mods:
	docker exec $(docker_ps) salt '*' saltutil.sync_modules

ssh:
	docker exec -it $(docker_ps) bash

%:
    @:
