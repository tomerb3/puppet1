require 'spec_helper'
describe 'prerequisite' do
  context 'with default values for all parameters' do
    it { should contain_class('prerequisite') }
  end
end
