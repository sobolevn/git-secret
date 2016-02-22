# Copyright 2016 Sobolev Nikita <mail@sobolevn.me>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at

#     http://www.apache.org/licenses/LICENSE-2.0

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Create binary:
PLUGIN_DIR="$(dirname $0)"

if [ ! -f "$PLUGIN_DIR/git-secret" ]; then
  cd "$PLUGIN_DIR" && make build && cd ..
fi

# Add our plugin's bin diretory to user's path
export PATH="${PATH}:${PLUGIN_DIR}"
