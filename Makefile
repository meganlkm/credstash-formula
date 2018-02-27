IMAGE_NAME="okta/credstash-setup"
docker_ps=`docker ps -f ancestor=$(IMAGE_NAME) -q`


setup:
	pip install -r requirements.pip
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
	docker run -d -v `pwd`/salt:/srv/salt -e "AWS_REGION=us-west-1" $(IMAGE_NAME)
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
clean:
	docker kill $(docker_ps)
	docker rmi --force $(IMAGE_NAME)
	rm -rf .dependencies
	rm -rf salt/_modules
%:
    @:
