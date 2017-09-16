require 'spec_helper'
require 'timelapser_client/command/shoot'

RSpec.describe TimelapserClient::Command::Shoot do
  let(:options) { { result_path: 'spec/files/images/' } }

  subject { described_class.new(options) }

  describe '#command' do
    it 'calls raspistill to create file in result_path' do
      timestamp = Time.now.strftime('%Y%m%d_%H%M')
      resfile = "spec/files/images/snapshot_#{timestamp}.jpg"
      expect(subject.command).to match("raspistill -n -dt -o #{resfile}")
    end
  end
end
