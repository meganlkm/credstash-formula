# Credstash Formula

Formulas to set up and manage credstash.

* [Flow](#flow)
* [Testing](#testing)
* [Available States](#states)
* [Pillar Customizations](#pillar)

---

##### Status: Planning/Development

##### Note:

See the full Salt Formulas installation and usage instructions
<http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>.

##### Assumptions:

`make` is on your system and available. If it is not or you are not sure what
`make` is, [this](https://www.gnu.org/software/make/) is a good place to start.

---

## <a name='flow'></a> Flow

* Build container
* Install dependencies
  - `salt-aws-boto3` (_modules)
  - `credstash`
* Salt State: setup
  - Create IAM policy: `credstash-setup-policy`
  - Create IAM role: `credstash-setup-role`
  - Create IAM policy: `credstash-write-policy`
  - Create IAM role: `credstash-write-role`
  - Create IAM policy: `credstash-read-policy`
  - Create IAM role: `credstash-read-role`
  - Create KMS key
  - Run `credstash setup`
* Salt State: destroy
  - Delete IAM policy: `credstash-setup-policy`
  - Delete IAM role: `credstash-setup-role`
  - Delete IAM policy: `credstash-write-policy`
  - Delete IAM role: `credstash-write-role`
  - Delete IAM policy: `credstash-read-policy`
  - Delete IAM role: `credstash-read-role`
  - Delete KMS key
  - Delete DynamoDB table
* Salt State: `put-secret`
* Salt State: `get-secret`
* Salt State: `delete-secret`
* Salt State: `list-secrets`
* Salt State: `keys`


## <a name='testing'></a> Testing

### <a name='run-tests'></a> Run Tests

Tests will be run on the following base images:

* `simplyadrian/allsalt:centos_master_2017.7.2`
* `simplyadrian/allsalt:debian_master_2017.7.2`
* `simplyadrian/allsalt:ubuntu_master_2017.7.2`
* `simplyadrian/allsalt:ubuntu_master_2016.11.3`

##### Start a virtualenv

```bash
pip install -U virtualenv
virtualenv .venv
source .venv/bin/activate
```

##### Install local requirements

```bash
make setup
```

#### Run tests

* `make test-centos_master_2017.7.2`
* `make test-debian_master_2017.7.2`
* `make test-ubuntu_master_2017.7.2`
* `make test-ubuntu_master_2016.11.3`

### <a name='run-containers'></a> Run Containers

* `make local-centos_master_2017.7.2`
* `make local-debian_master_2017.7.2`
* `make local-ubuntu_master_2017.7.2`
* `make local-ubuntu_master_2016.11.3`


## <a name='states'></a> Available States

### `credstash`

Install credstash and its dependencies.
Create the AWS objects required to run credstash.


## <a name='pillar'></a> Pillar Customizations

Any of these values can be overwritten in a pillar file. If you do find yourself needing
more overrides follow the example below.

[pillar.example](authconfig/tests/pillar/authconfig/init.sls)
