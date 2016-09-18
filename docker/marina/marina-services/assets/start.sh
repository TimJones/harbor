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
echo "${OS_DISTRO}: Starting Harbor service update"
################################################################################
source /etc/os-container.env


if ! [ "$MARINA_SERVICE" == "raven" ]; then
  echo "${OS_DISTRO}: Launching service certificate management"
  ##############################################################################
  /usr/bin/harbor-manage-service-certs
fi


echo "${OS_DISTRO}: Launching user certificate management"
################################################################################
/usr/bin/harbor-manage-user-certs


if [ "$MARINA_SERVICE" == "kubernetes" ]; then
  echo "${OS_DISTRO}: Not launching kube service management (we are kube!)"
  ##############################################################################
elif [ "$MARINA_SERVICE" == "keystone" ]; then
  echo "${OS_DISTRO}: Launching federation management"
  ##############################################################################
  /usr/bin/harbor-manage-keystone-ldap
  /usr/bin/harbor-manage-keystone-federation
  /usr/bin/harbor-manage-kube || true
else
  echo "${OS_DISTRO}: Launching kube management"
  ##############################################################################
  /usr/bin/harbor-manage-kube || true
fi


echo "${OS_DISTRO}: Finished service update"
################################################################################
shutdown -h now
