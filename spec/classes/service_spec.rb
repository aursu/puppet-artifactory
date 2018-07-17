require 'spec_helper'

describe 'artifactory::service' do
  let(:pre_condition) { 'include artifactory' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      os_facts[:os]['architecture'] = os_facts[:architecture]
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
