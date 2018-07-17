require 'spec_helper'

describe 'artifactory::repos' do
  let(:pre_condition) { 'include artifactory' }

  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
    end
  end
end
