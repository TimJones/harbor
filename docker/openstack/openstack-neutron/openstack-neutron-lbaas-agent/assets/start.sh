#!/bin/bash

# Copyright 2016 Port Direct
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
echo "${OS_DISTRO}: Launching Container Startup Scripts"
################################################################################
. /etc/os-container.env
. /opt/harbor/service-hosts.sh
. /opt/harbor/harbor-common.sh
. /opt/harbor/neutron/vars.sh


tail -f /dev/null
echo "${OS_DISTRO}: Testing service dependancies"
################################################################################
/usr/bin/mysql-test


echo "${OS_DISTRO}: Configuring Container"
################################################################################
check_required_vars NEUTRON_CONFIG_FILE \
                    OS_DOMAIN


echo "${OS_DISTRO}: Starting neutron config"
################################################################################
/opt/harbor/config-neutron.sh


echo "${OS_DISTRO}: Starting api-server config"
################################################################################
#/opt/harbor/neutron/components/config-lbaas.sh


################################################################################
check_required_vars NEUTRON_CONFIG_FILE \
                    NEUTRON_LBAAS_CONFIG_FILE \
                    NEUTRON_LBAAS_AGENT_CONFIG_FILE
exec neutron-lbaasv2-agent --config-file ${NEUTRON_CONFIG_FILE} \
                           --config-file ${NEUTRON_LBAAS_CONFIG_FILE} \
                           --config-file ${NEUTRON_LBAAS_AGENT_CONFIG_FILE} \
                           --debug
