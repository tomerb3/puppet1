require 'spec_helper'
describe 'bl' do
  context 'with default values for all parameters' do
    it { should contain_class('bl') }
  end
end
