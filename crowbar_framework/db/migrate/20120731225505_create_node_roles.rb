# Copyright 2013, Dell
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

class CreateNodeRoles < ActiveRecord::Migration
  def change
    create_table :node_roles do |t|
      t.string       :config               # CB1 TODO remove - replaced by NodeAttributes
      t.belongs_to   :role
      t.belongs_to   :node
      t.belongs_to   :proposal_config      # CB1 TODO > remove CB1 LEGACY
      t.belongs_to   :barclamp_instance
      t.timestamps
    end
  end
end