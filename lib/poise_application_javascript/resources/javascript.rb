#
# Copyright 2015-2016, Noah Kantrowitz
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
#

require 'poise_javascript/resources/javascript_runtime'

require 'poise_application_javascript/app_mixin'


module PoiseApplicationJavascript
  module Resources
    # (see Javascript::Resource)
    # @since 1.0.0
    module Javascript
      # An `application_javascript` resource to manage Javascript runtimes
      # inside an Application cookbook deployment.
      #
      # @provides application_javascript
      # @provides application_javascript_runtime
      # @action install
      # @action uninstall
      # @example
      #   application '/app' do
      #     javascript '3'
      #   end
      class Resource < PoiseJavascript::Resources::JavascriptRuntime::Resource
        include PoiseApplicationJavascript::AppMixin
        provides(:application_javascript)
        # Need the double javascript for application resource rewriting.
        provides(:application_javascript_runtime)
        container_default(false)
        subclass_providers!

        # We want to run the base class version of this, not the one from the
        # mixin. HULK SMASH.
        def npm_binary
          self.class.superclass.instance_method(:npm_binary).bind(self).call
        end

        # Set this resource as the app_state's parent javascript.
        #
        # @api private
        def after_created
          super.tap do |val|
            app_state_javascript(self)
          end
        end

      end
    end
  end
end
