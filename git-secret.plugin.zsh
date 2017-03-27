#!/usr/bin/env zsh

# Copyright 2016 Sobolev Nikita <mail@sobolevn.me>
#
# Licensed under the MIT License

# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Deprecation warning:
(>&2 echo "warning: this installation method is deprecated since version 0.2.3")
(>&2 echo "warning: it will be completely removed by the version 0.3.0")
(>&2 echo "warning: use binary installation instead")

# Create binary:
PLUGIN_DIR="$(dirname "$0")"

if [ ! -f "$PLUGIN_DIR/git-secret" ]; then
  cd "$PLUGIN_DIR" && make build && cd ..
fi

# Add our plugin's bin diretory to user's path
export PATH="${PATH}:${PLUGIN_DIR}"
