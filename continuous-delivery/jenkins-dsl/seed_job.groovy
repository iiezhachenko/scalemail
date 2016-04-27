def jobProvisionInfraName = "${PIPELINE_NAME}_Provision_Infrastrucrure"
def jobProvisionDockerHostsName = "${PIPELINE_NAME}_Provision_Docker_Hosts"
def jobDestroyInfraName = "${PIPELINE_NAME}_Destroy_Infrastrucrure"

def jobProvisionInfra = freeStyleJob(jobProvisionInfraName)
def jobProvisionDockerHosts = freeStyleJob(jobProvisionDockerHostsName)
def jobDestroyInfra = freeStyleJob(jobDestroyInfraName)

def pipelineName = "${PIPELINE_NAME}"

def pipelineView = buildPipelineView(pipelineName)

pipelineView.with{
    title(jobProvisionInfraName)
    displayedBuilds(5)
    selectedJob(jobProvisionInfraName)
    showPipelineParameters(false)
    showPipelineDefinitionHeader()
    refreshFrequency(5)
}

jobProvisionInfra.with{
    parameters{
        stringParam("CORE_AMI_ID","ami-2bf21344","")
        stringParam("KEY_PAIR_NAME","","")
        stringParam("SWARM_NODES_AMOUNT","3","How many Docker Swarm nodes to create.")
        stringParam("DOCKER_MACHINE_HOST_INSTANCE_TYPE","t2.micro","Docker Machine host instance type.")
        stringParam("NGINX_INSTANCE_TYPE","t2.micro","Nginx host instance type.")
        stringParam("SWARM_MASTER_INSTANCE_TYPE","t2.micro","Swarm Master host instance type.")
        stringParam("SWARM_NODES_INSTANCE_TYPE","t2.micro","Swarm Nodes hosts instance type.")
        stringParam("REGISTRY_INSTANCE_TYPE","t2.micro","Docker Registry host instance type.")
        stringParam("APP_INSTANCES","6","How mush upstream instances spin up in Swarm.")
        configure { project ->
            project / 'properties' / 'hudson.model.ParametersDefinitionProperty'/ 'parameterDefinitions' << 'hudson.model.PasswordParameterDefinition' {
                name("AWS_ACCESS_KEY")
                description("AWS Access Key.")
            }
        }
        configure { project ->
            project / 'properties' / 'hudson.model.ParametersDefinitionProperty'/ 'parameterDefinitions' << 'hudson.model.PasswordParameterDefinition' {
                name("AWS_SECRET_ACCESS_KEY")
                description("AWS Secret Access Key.")
            }
        }
    }
    wrappers {
        preBuildCleanup()
    }
    scm {
        git {
            remote {
                name("origin")
                url("https://github.com/iiezhachenko/scalemail.git")
            }
            branch("*/master")
        }
    }
    steps {
        shell("""\
            set -o errexit
            set +x

            echo 'Starting template validation.'
            aws cloudformation validate-template --template-body file://\${WORKSPACE}/cloud-providers/aws/cfjson.json
            echo 'Stack validation successful'
            echo 'Starting stack creation'

            CLOUD_FORMATION_STACK_NAME="""+pipelineName+"""-CD-\${BUILD_NUMBER}

            aws cloudformation create-stack \
            --template-body file://\${WORKSPACE}/cloud-providers/aws/cfjson.json \
            --stack-name \${CLOUD_FORMATION_STACK_NAME} \
            --parameters ParameterKey=CoreAmiId,ParameterValue=\${CORE_AMI_ID} \
            ParameterKey=KeyName,ParameterValue=\${KEY_PAIR_NAME} \
            ParameterKey=AWSAccessKeyID,ParameterValue=\${AWS_ACCESS_KEY} \
            ParameterKey=AWSSecretAccessKey,ParameterValue=\${AWS_SECRET_ACCESS_KEY} \
            ParameterKey=SwarmNodesAmount,ParameterValue=\${SWARM_NODES_AMOUNT} \
            ParameterKey=DockerMachineInstanceType,ParameterValue=\${DOCKER_MACHINE_HOST_INSTANCE_TYPE} \
            ParameterKey=NginxInstanceType,ParameterValue=\${NGINX_INSTANCE_TYPE} \
            ParameterKey=SwarmMasterInstanceType,ParameterValue=\${SWARM_MASTER_INSTANCE_TYPE} \
            ParameterKey=SwarmNodesInstanceType,ParameterValue=\${SWARM_NODES_INSTANCE_TYPE} \
            ParameterKey=ConsulInstanceType,ParameterValue=\${CONSUL_INSTANCE_TYPE} \
            ParameterKey=RegistryInstanceType,ParameterValue=\${REGISTRY_INSTANCE_TYPE} \
            ParameterKey=AppInstances,ParameterValue=\${APP_INSTANCES}

            aws cloudformation wait stack-create-complete --stack-name \${CLOUD_FORMATION_STACK_NAME}
            echo 'Stack creation successful'
        """.stripIndent())
        downstreamParameterized {
            trigger(jobProvisionDockerHostsName) {
                parameters {
                    predefinedProp('CLOUD_FORMATION_STACK_NAME', pipelineName+"-CD-\${BUILD_NUMBER}")
                }
            }
        }
    }
}

jobProvisionDockerHosts.with{
    parameters{
        stringParam("CLOUD_FORMATION_STACK_NAME","","Name for CloudFormation step in which Docker Hosts will be created.")
    }
    steps {
        shell("""\
            set -o errexit
            set +x

            echo 'Getting Docker Machine IP from CloudFormation stack.'
            DOCKER_MACHINE_IP=\$(aws cloudformation describe-stacks \
            --output text \
            --stack-name \${CLOUD_FORMATION_STACK_NAME} | \
            grep OUTPUTS | \
            grep DockerMachinePublicIP | \
            grep -o '[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}\\.[0-9]\\{1,3\\}')

            echo \"Docker Machine IP is: \$DOCKER_MACHINE_IP\"

        """.stripIndent())
        downstreamParameterized {
            trigger(jobDestroyInfraName) {
                parameters {
                    predefinedProp('CLOUD_FORMATION_STACK_NAME', "\${CLOUD_FORMATION_STACK_NAME}")
                }
            }
        }
    }
}

jobDestroyInfra.with{
    parameters{
        stringParam("CLOUD_FORMATION_STACK_NAME","","Name for CloudFormation step that will be deleted.")
    }
    steps {
        shell('''
            aws cloudformation delete-stack --output text --stack-name ${CLOUD_FORMATION_STACK_NAME}
            aws cloudformation wait stack-delete-complete --stack-name ${CLOUD_FORMATION_STACK_NAME}
            while [ $? -ne 0 ]; do !!; done
        ''')
    }
}