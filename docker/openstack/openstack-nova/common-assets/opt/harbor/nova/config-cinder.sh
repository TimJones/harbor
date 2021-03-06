#!/bin/bash

# Copyright 2016 Port Direct
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e
echo "${OS_DISTRO}: Configuring cinder"
################################################################################
. /etc/os-container.env
. /opt/harbor/service-hosts.sh
. /opt/harbor/harbor-common.sh
. /opt/harbor/nova/vars.sh


################################################################################
check_required_vars NOVA_CONFIG_FILE \
                    OS_DOMAIN


################################################################################
crudini --set ${NOVA_CONFIG_FILE} cinder os_region_name "RegionOne"
crudini --set ${NOVA_CONFIG_FILE} cinder catalog_info "volumev2:cinderv2:internalURL"


################################################################################
crudini --set ${NOVA_CONFIG_FILE} privsep_osbrick helper_command "sudo nova-rootwrap \$rootwrap_config privsep-helper --config-file ${NOVA_CONFIG_FILE}"
